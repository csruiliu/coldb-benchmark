#!/bin/bash
#set -x

trap "echo; echo SIGINT/SIGTERM detected. Exiting ...; exit;" SIGINT SIGTERM

PROJECT_PATH_BASE="/home/rui/Development/coldb-benchmark/stu-projects"

rm -rf ${PROJECT_PATH_BASE}