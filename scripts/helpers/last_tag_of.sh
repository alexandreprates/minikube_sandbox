#!/bin/bash

LASTTAG=$(docker images --format '{{.Tag}}' $1 | tr -dc "0-9\n" | sort --version-sort | tail -n 1)
[[ -z "${LASTTAG//[0-9]+}" ]] && LASTTAG=0

echo $LASTTAG