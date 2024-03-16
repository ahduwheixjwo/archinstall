#!/bin/bash

checkError() {
    if [[ "$?" -ne 0 ]]; then
        echo "An error has occured [Exit Code: $?]. Aborting..."

        sleep 0.5
        exit 1
    fi
}