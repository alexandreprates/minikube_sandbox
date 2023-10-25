#!/bin/bash

BASH_PATH=$(dirname -- "${BASH_SOURCE[0]}")

source $BASH_PATH/../helpers/usage_helper.sh
PARAMS="<app name> <environment>"

[[ -z "$1" ]] && arg_missing "app name"
[[ -z "$2" ]] && arg_missing "environment"

LASTTAG=$($BASH_PATH/../helpers/last_tag_of.sh $1)

echo "# Starting deployment of $1:$LASTTAG"
FILES=$(find $BASH_PATH/../../infra/apps/$1 -name \*.yml | sort)

for file in $FILES; do
    echo "  ## Deploying $file"
    cat $file | sed -e "s/{{environment}}/$2/" -e "s/{{imagename}}/$1:$LASTTAG/" | kubectl apply -f -
    if [ $? == 0 ]; then
        echo "  ## $file deployed!"
    else
        echo "  ## Ooops error in $file aborting"
        exit 1
    fi
done
echo "# Restarting $1"
kubectl rollout restart -n $2 deployment $1-deployment || echo "# Oops restarting failed!"

echo -e "# Deploy pipeline done!"
