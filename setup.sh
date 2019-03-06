#!/bin/bash

STUSRC_FILE=`sed '/^STUSRC_FILE=/!d;s/.*=//' config.ini`
GIT_URL=`sed '/^GIT_URL=/!d;s/.*=//' config.ini`
PROJECT_BASE=`sed '/^PROJECT_BASE=/!d;s/.*=//' config.ini`
TEST_DIR=`sed '/^TEST_DIR=/!d;s/.*=//' config.ini`
RESULT_DIR=`sed '/^RESULT_DIR=/!d;s/.*=//' config.ini`

# get non-empty line in student.txt
NUM_STU=`cat students.txt | grep -v ^$ | wc -l`

if [ ! -d "${RESULT_DIR}" ]
then
    mkdir ${RESULT_DIR}
    RET=$?
    if [ ${RET} -eq 0 ]
    then
        echo "Create folder for all student projects successfully."
    else
        echo "Fail to create the folder for student projects."
        exit 0
    fi
else
    echo "The folder for student projects exists, continue..."
fi

if [ ! -d "${PROJECT_BASE}" ]
then
    mkdir ${PROJECT_BASE}
    RET=$?
    if [ ${RET} -eq 0 ]
    then
        echo "Create folder for all test results successfully."
    else
        echo "Fail to create the folder for test results."
        exit 0
    fi
else
    echo "The folder for test results exists, continue..."
fi

# enter the folder
cd ${PROJECT_BASE}

while read line
do
    #echo "Student ${STUDENT_NO}: $line"
    CUR_STU_NAME=${line%%/*}
    echo "fetch the project for current student is ${CUR_STU_NAME}"

    # clone the project
    git clone ${GIT_URL}/${CUR_STU_NAME}.git

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

