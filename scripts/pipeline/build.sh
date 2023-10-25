#!/bin/bash

BASH_PATH=$(dirname -- "${BASH_SOURCE[0]}")

source $BASH_PATH/../helpers/usage_helper.sh
PARAMS="<app name>"

[[ -z "$1" ]] && arg_missing "app name"

LASTTAG=$($BASH_PATH/../helpers/last_tag_of.sh $1)
NEXTTAG=$(expr $LASTTAG + 1)

pushd . > /dev/null

echo " # Starting pipeline of $1"
cd $BASH_PATH/../../apps/$1

echo "  ## build image version $NEXTTAG"
docker build . -t $1:$NEXTTAG
[[ $? != 0 ]] && echo "#### Ooops image build failed!" && exit 1

popd > /dev/null

echo "  ## pushing image $1:$NEXTTAG to cluster"
minikube image load --daemon $1:$NEXTTAG && echo "    ## push success" || echo -e "\n\n# Ooops build failed :("

echo "# Build pipeline done!" 
