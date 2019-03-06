#!/bin/bash

STUSRC_FILE=`sed '/^STUSRC_FILE=/!d;s/.*=//' config.ini`
RESULT_DIR=`sed '/^RESULT_DIR=/!d;s/.*=//' config.ini`


rm -rf ${RESULT_DIR}
mkdir ${RESULT_DIR}
while read line
do
    #echo "Student ${STUDENT_NO}: $line"
    CUR_STU_NAME=${line%%/*}
    echo "fetch the project for current student is ${CUR_STU_NAME}"

    if [ ! -d "${RESULT_DIR}/${CUR_STU_NAME}" ]
    then
        mkdir ${RESULT_DIR}/${CUR_STU_NAME}
        RET=$?
        if [ ${RET} -eq 0 ]
        then
            echo "Create folder for student ${CUR_STU_NAME} test results successfully."
        else
            echo "Fail to create the folder for student ${CUR_STU_NAME} test results."
            exit 0
        fi
    else
        echo "The folder for test results exists."
    fi

done < ${STUSRC_FILE}
