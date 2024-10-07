if [ -z "$HUB_API" ]; then
  echo "HUB_API must be set"
  exit 1
fi

HUB_API="${HUB_API%/}"
APPS=("98.ticket-monster" "99.kitchensink")

for app in "${APPS[@]}"
do
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
            echo "Creating initial analysis - ./hub/${app}/unsolved.analysis.manifest"
            response=$(curl -s -X POST ${HUB_API}/applications/${app_id}/analyses \
                -H "Content-Type: application/x-yaml" \
                --data-binary @./hub/${app}/01.unsolved.analysis.manifest)
            echo "Created analysis - ${response}"
        else
            echo "Failed creating app ${error}"
        fi
    else
        echo "Invalid response - ${response}"
    fi
done