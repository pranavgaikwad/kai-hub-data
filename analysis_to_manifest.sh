#!/bin/sh

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_file.json> <output_file.yaml>"
    exit 1
fi

input_path="$1"
output_path="$2"

{
    echo -e "\x1DBEGIN-MAIN\x1D"
    jq -r '{commit: .commit}' ${input_path} | yq -P
    echo -e "\x1DEND-MAIN\x1D"

    echo -e "\x1DBEGIN-ISSUES\x1D"
    jq -c '.issues[]' ${input_path} | while IFS= read -r issue; do
        echo "---"
        echo ${issue} | yq -P
    done
    echo -e "\x1DEND-ISSUES\x1D"

    echo -e "\x1DBEGIN-DEPS\x1D"
    jq -c '.dependencies[]' ${input_path} | while IFS= read -r dependency; do
        echo "---"
        echo ${dependency} | yq -P
    done
    echo -e "\x1DEND-DEPS\x1D"
} > ${output_path}

echo "Done!"