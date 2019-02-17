#!/bin/bash
#set -x

trap "echo; echo SIGINT/SIGTERM detected. Exiting ...; exit;" SIGINT SIGTERM

# File include all students emails
STUDENTS_FILE="/home/rui/Development/coldb-benchmark/students.tsv"

# Creating the path that all the projects will be stored in
RESULT_DIR="/home/rui/Development/coldb-benchmark/test-results"

if [ ! -d "${RESULT_DIR}" ]
then
    mkdir ${RESULT_DIR}
    RET=$?
    if [ ${RET} -eq 0 ]
    then
        echo "Create folder for all projects successfully."
    else
        echo "Fail to create the folder."
        exit 0
    fi
else
    echo "The folder exists. delete it and re mkdir"
    rm -rf ${RESULT_DIR}
    mkdir ${RESULT_DIR}
fi

STUDENT_NO=1
while read line
do
    echo "Student ${STUDENT_NO}: $line"
    CUR_STU_NAME=${line%@*}
    echo "Current student is ${CUR_STU_NAME}"
    mkdir ${RESULT_DIR}/${CUR_STU_NAME}
    ((STUDENT_NO++))
done < ${STUDENTS_FILE}


