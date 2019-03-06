#! /bin/bash

trap "echo; echo SIGINT/SIGTERM detected. Exiting ...; exit;" SIGINT SIGTERM

STUSRC_FILE=`sed '/^STUSRC_FILE=/!d;s/.*=//' config.ini`
PROJECT_BASE=`sed '/^PROJECT_BASE=/!d;s/.*=//' config.ini`
TEST_DIR=`sed '/^TEST_DIR=/!d;s/.*=//' config.ini`
RESULT_DIR=`sed '/^RESULT_DIR=/!d;s/.*=//' config.ini`
ROOT_DIR=`sed '/^ROOT_DIR=/!d;s/.*=//' config.ini`

#Sleep times after server is enabled
SLEEP_SERVER=2
SLEEP_TEST=1

#Test id
MS=ALL
MAX_TEST=35
MIN_TEST=01
TEST_IDS=`seq -w ${MIN_TEST} ${MAX_TEST}`

#this is the timestamp of the whole trial
TS=`date +%Y%m%d-%H%M%S`
echo "Test at ${TS}" > ${RESULT_DIR}/${TS}.txt


while read line
do
    #echo "Student ${STUDENT_NO}: $line"

    CUR_STU_NAME=${line%%/*}
    CUR_STU_SRC=${line%@*}
    echo "Current student is ${CUR_STU_NAME}"
    echo "student name: ${CUR_STU_NAME}" >> ${RESULT_DIR}/${TS}.txt
    echo "Current student src code is at ${PROJECT_BASE}/${CUR_STU_SRC}"

    cd ${PROJECT_BASE}/${CUR_STU_SRC}
    make clean
    RET_CODE=$?
    echo ${RET_CODE}

    if [ ${RET_CODE} -ne 0 ]
    then
        echo "[Please make sure you have a \"make clean\" option.]"
    fi

    echo "Compiling ..."
    make > build.out
    RET_CODE=$?
    if [ ${RET_CODE} -ne 0 ]
    then
        echo "[Please make sure you have a \"make\" option.]"
    fi

    OUTPUT_DIR=${RESULT_DIR}/${CUR_STU_NAME}/${MS}.${TS}
    mkdir ${OUTPUT_DIR}

    for CUR_TEST_ID in ${TEST_IDS}
    do
        ${ROOT_DIR}/single-test.sh ${CUR_STU_NAME} ${CUR_STU_SRC} ${CUR_TEST_ID} ${MS} ${TS} ${PROJECT_BASE} ${TEST_DIR} ${RESULT_DIR}
    done



done < ${STUSRC_FILE}














