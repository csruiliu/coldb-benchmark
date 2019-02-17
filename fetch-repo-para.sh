#!/bin/bash
#set -x

trap "echo; echo SIGINT/SIGTERM detected. Exiting ...; exit;" SIGINT SIGTERM

# username
CUR_STU_NAME=$1

# Git base url
GIT_URL="https://mit.cs.uchicago.edu/cmsc23500-win-19"

# Creating the path that all the projects will be stored in
PROJECT_PATH_BASE="/home/rui/Development/coldb-benchmark/stu-projects"

if [ ! -d "${PROJECT_PATH_BASE}" ]
then
    mkdir ${PROJECT_PATH_BASE}
    RET=$?
    if [ ${RET} -eq 0 ]
    then
        echo "Create folder for all projects successfully."
    else
        echo "Fail to create the folder."
        exit 0
    fi
else
    echo "The folder exists."
fi

# enter the folder
cd ${PROJECT_PATH_BASE}

echo "Current student is ${CUR_STU_NAME}"

# clone the project
if [ -d "${PROJECT_PATH_BASE}/${CUR_STU_NAME}" ]
then
    rm -rf "${PROJECT_PATH_BASE}/${CUR_STU_NAME}"
    echo "delete the folder"
    git clone ${GIT_URL}/${CUR_STU_NAME}.git
else
    git clone ${GIT_URL}/${CUR_STU_NAME}.git
fi

if [ -n "$2" ]
then
    cd ${PROJECT_PATH_BASE}/${CUR_STU_NAME}
    git checkout "$2"
fi
