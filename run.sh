if [ -z "$HUB_API" ]; then
  echo "HUB_API must be set"
  exit 1
fi

create_analysis_report () {
    app_id=$1
    analysis_path=$2
    response=$(curl -s -X POST ${HUB_API}/applications/${app_id}/analyses \
        -H "Content-Type: application/x-yaml" \
        --data-binary @${analysis_path})
    analysis_id=$(echo "$response" | jq -r '.id')
    if [ "$analysis_id" != 'null' ]; then
        echo "Created analysis with id $analysis_id"
    else
        echo "Failed creating analysis"
        exit 1
    fi
}

ask_yes_no () {
    local prompt_message="$1"
    local user_response

    while true; do
        read -rp "$prompt_message (y/n): " user_response
        case "$user_response" in
            [Yy]|[Yy][Ee][Ss])
                return 0
                ;;
            *)
                return 1
                ;;
        esac
    done
}

HUB_API="${HUB_API%/}"
APPS=("98.ticket-monster" "99.kitchensink")

for app in "${APPS[@]}"
do
    if ask_yes_no "Create app ${app}? (Y/n)"; then
        echo "Creating app '${app}'"
        response=$(curl -s -X POST ${HUB_API}/applications \
            -H "Content-Type: application/json" \
            -d @./hub/${app}/00.app.json)
        if echo "$response" | jq . > /dev/null 2>&1; then
            app_id=$(echo "$response" | jq -r '.id')
            error=$(echo "$response" | jq -r '.error')
            if [[ "$app_id" != "null" ]] || [[ "$error" =~ ^UNIQUE.*$ ]]; then
                if [[ "$app_id" == 'null' ]]; then
                    app_id=$(cat ./hub/${app}/00.app.json | jq -r '.id')
                fi
                echo "Created app with id ${app_id}"
                analysis="./hub/${app}/01.unsolved.analysis.manifest"
                if ask_yes_no "Create report ${analysis}? (Y/n)"; then
                    echo "Creating initial analysis - ${analysis}"
                    create_analysis_report $app_id $analysis
                fi
                analysis="./hub/${app}/02.solved.analysis.manifest"
                if ask_yes_no "Create report ${analysis}? (Y/n)"; then
                    echo "Creating solved analysis - ${analysis}"
                    create_analysis_report $app_id $analysis
                fi
            else
                echo "Failed creating app ${error}"
            fi
        else
            echo "Invalid response - ${response}"
        fi
    fi
done