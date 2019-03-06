#!/bin/bash

NO=`ps -ef | grep -E "server|strace" | grep cs165 | grep -v grep | wc -l | awk '{print $1}'` 

if [ "$NO" -ne 0 ]; then
    echo "Killing $NO unnecessary processes (server and strace)."
else
    echo "Nothing to kill."
    exit
fi

kill `ps -ef | grep -E "server|strace" | grep cs165 | grep -v grep | awk '{printf("%s ",$2)}'`

