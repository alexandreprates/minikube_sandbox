#!/bin/bash

function arg_missing() {
    echo "Error: missing param $1.\n  usage: $ $0 $PARAMS"
    exit 1
}