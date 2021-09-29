#!/bin/bash

while true
do
    sleep 5
    res=snapctl get system.seed.loaded
    if [ "$res" != "true"]; then 
        continue
    fi
    ${SNAP}/usr/bin/curl sS --unix-socket /run/snapd.socket http://localhost/v2/find\?select=refresh | grep "demo-release" 
    if [[ "$?" == "0" ]]; then
       echo "$SNAP_NAME finds demo-release update is available, so refreshing now."
       ${SNAP}/usr/bin/curl -X POST -sS --unix-socket /run/snapd.socket http://localhost/v2/snaps --header "Content-Type: application/json" --data-binary "@${SNAP}/refresh.json"
    fi
done
