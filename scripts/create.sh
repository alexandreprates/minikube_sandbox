#!/bin/bash

BASH_PATH=$(dirname -- "${BASH_SOURCE[0]}")

source $BASH_PATH/helpers/usage_helper.sh
PARAMS="<environment>"

[[ -z "$1" ]] && arg_missing "environment"

FILES=$(find $BASH_PATH/../infra/base -name \*.yaml | sort)
for file in $FILES; do
    echo "  ## Deploying $file"
    cat $file | sed -e "s/{{environment}}/$1/" | kubectl apply -f -
    if [ $? == 0 ]; then
        echo "  ## $file deployed!"
    else
        echo "  ## Ooops error in $file aborting"
        exit 1
    fi
done

echo -e "\nDone!"
