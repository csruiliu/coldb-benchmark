#!/bin/bash

STU_NAME=$1
STU_SRC=$2
TEST_ID=$3
MS=$4
TS=$5
PROJECT_BASE=$6
TEST_DIR=$7
RESULT_DIR=$8

#Sleep times after server is enabled
SLEEP_SERVER=2
SLEEP_TEST=1

echo "Test" $TEST_ID "will launch"

cd ${PROJECT_BASE}/${STU_SRC}

SERVER="./server"
CLIENT="./client"

if [ ! -f ${SERVER} ] || [ ! -f ${CLIENT} ]
then
    MESSAGE="Cannot find ./server or ./client executables in directory in the project path."
    echo ${MESSAGE}
    exit 0
else
    MESSAGE="Found ./server and ./client executables in directory in the project path."
    echo ${MESSAGE}
fi

if [ -d ${TEST_DIR} ]
then
	echo "Test dir found: $TEST_DIR!"
else
	echo -e "No tests to use, please populate them!"
    exit 0
fi

#this is the timestamp of the whole trial
OUTPUT_DIR=${RESULT_DIR}/${STU_NAME}/${MS}.${TS}

echo "Starting server for tests"


${SERVER} 2>> ${OUTPUT_DIR}/test${TEST_ID}-server.err 1>> ${OUTPUT_DIR}/test${TEST_ID}-server.out & SERVER_PID=$!
echo "Server Process: ${SERVER_PID}"

IS_RUNNING=`ps cax | grep ${SERVER_PID} | wc -l | awk '{print $1}'`
if [ "$IS_RUNNING" -eq 1 ]
then
    echo "server start normally" >> ${OUTPUT_DIR}/server.out
else
    echo "server cannot start normally" >> ${OUTPUT_DIR}/server.err
fi

echo -n "[Running test ${TEST_ID}]"

# %s total seconds from 1970.1.1 %N = nanoseconds
TEST_START_TIME=$(date "+%s%N")
echo "${CLIENT} < ${TEST_DIR}/test${TEST_ID}.dsl"


${CLIENT} < ${TEST_DIR}/test${TEST_ID}.dsl 2>> ${OUTPUT_DIR}/test${TEST_ID}-server.err 1>> ${OUTPUT_DIR}/test${TEST_ID}-client.out
RET_CODE=$?
echo "client return with code ${RET_CODE}"
TEST_DUR=$(($(date "+%s%N") - $TEST_START_TIME))
echo "Time: ${TEST_DUR}" >> ${OUTPUT_DIR}/test${TEST_ID}-server.time

echo "Test is finished"

CUR_READY_FILE=${OUTPUT_DIR}/test${TEST_ID}-ready.out

if [ "${TEST_ID}" -eq 01 ] || [ "${TEST_ID}" -eq 02 ] || [ "${TEST_ID}" -eq 10 ] || [ "${TEST_ID}" -eq 19 ] || [ "${TEST_ID}" -eq 20 ] || [ "${TEST_ID}" -eq 30 ]
then
   if [[ ! -s ${OUTPUT_DIR}/test${TEST_ID}-server.err ]]
   then
       echo "test${TEST_ID} passed, Time(ns): ${TEST_DUR}" >> ${RESULT_DIR}/${TS}.txt
   else
       echo "test${TEST_ID} failed" >> ${RESULT_DIR}/${TS}.txt
   fi
else
   sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g' ${OUTPUT_DIR}/test${TEST_ID}-client.out | sed -r '/[a-zA-Z~\s!@#$%\^\+\*&\\\/\?\|:<>{}();="]/d' | sed "/--/d" | sed '/^$/d' > ${CUR_READY_FILE}
   DIFF=`diff -B -w ${CUR_READY_FILE} ${TEST_DIR}/test${TEST_ID}.exp`
   if [ -z "${DIFF}" ]
   then
        echo "test${TEST_ID} passed, Time(ns): ${TEST_DUR}" >> ${RESULT_DIR}/${TS}.txt
   else
        echo "test${TEST_ID} failed" >> ${RESULT_DIR}/${TS}.txt
   fi
fi

IS_RUNNING=`ps cax | grep ${SERVER_PID} | wc -l | awk '{print $1}'`
if [ "${IS_RUNNING}" -eq 1 ]
then
    echo "the server is shutdown"
    ${CLIENT} < "shutdown"
fi

IS_RUNNING=`ps cax | grep ${SERVER_PID} | wc -l | awk '{print $1}'`
if [ "${IS_RUNNING}" -eq 1 ]
then
    echo "force to shutdown the server"
    kill -9 ${SERVER_PID}
fi
