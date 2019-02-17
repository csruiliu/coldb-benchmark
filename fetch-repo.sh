#!/bin/bash
#set -x

trap "echo; echo SIGINT/SIGTERM detected. Exiting ...; exit;" SIGINT SIGTERM

# File include all students emails
STUDENTS_FILE="/home/rui/Development/coldb-benchmark/students.tsv"

# Git base url
GIT_URL="https://mit.cs.uchicago.edu/cmsc23500-win-19"

# Creating the path that all the projects will be stored in
PROJECT_PATH_BASE="/home/rui/Development/coldb-benchmark/stu-projects"

# sha1 code for submission
SHA1=3ae1dfa684d363f496f725f67c501022f753b9df

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

STUDENT_NO=1
while read line
do
    echo "Student ${STUDENT_NO}: $line"
    CUR_STU_NAME=${line%@*}
    echo "Current student is ${CUR_STU_NAME}"

    # clone the project
    git clone ${GIT_URL}/${CUR_STU_NAME}.git
    git checkout ${SHA1}
    ((STUDENT_NO++))
done < ${STUDENTS_FILE}


