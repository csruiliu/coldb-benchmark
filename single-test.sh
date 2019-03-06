#!/bin/bash

trap "echo; echo SIGINT/SIGTERM detected. Exiting ...; exit;" SIGINT SIGTERM

##########################################
# Global Variables for Test Shell Script #
##########################################

STU_NAME=$1
TEST_ID=$2

TEST_DIR="/home/rui/Development/coldb-benchmark/project-tests"
PROJECT_DIR="/home/rui/Development/coldb-benchmark/stu-projects"
RESULT_DIR="/home/rui/Development/coldb-benchmark/test-results"

#Sleep times after server is enabled
SLEEP_SERVER=2
SLEEP_TEST=1

# Variables for formatting
RED="\x1b[31m"
GRN="\x1b[32m"
RST="\x1b[0m"
GREEN_OK="[${GRN}ok${RST}]"
RED_FAIL="[${RED}FAIL${RST}]"

echo "Test" $TEST_ID "will launch"

#-e will handle special character
echo -e "\n****************************************************************"
echo -e "* Compiling  "
echo -e "****************************************************************\n"

cd ${PROJECT_DIR}/${STU_NAME}/coldb/src
make clean
RET_CODE=$?
echo ${RET_CODE}

if [ ${RET_CODE} -ne 0 ]
then
    echo "[Please make sure you have a \"make clean\" option.]"
    exit 0
fi
echo "Compiling ..."
make
RET_CODE=$?
if [ ${RET_CODE} -ne 0 ]
then
    echo "[Please make sure you have a \"make\" option.]"
    exit 0
fi

echo -e "\n****************************************************************"
echo -e "* Checking whether exec files exist"
echo -e "****************************************************************\n"

SERVER="./server"
CLIENT="./client"

# Check whether the exec files exits
echo -e "Looking for server and client executables in ${PROJECT_DIR}/${STU_NAME}/coldb/src ..."

if [ ! -f ${SERVER} ] || [ ! -f ${CLIENT} ]
then
    MESSAGE="Cannot find ./server or ./client executables in directory in the project path."
    echo -e "${RED_FAIL} ${MESSAGE}"
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

echo -e "\n****************************************************************"
echo -e "* Setup tests"
echo -e "****************************************************************\n"

#this is the timestamp of the whole trial
TS=`date +%Y%m%d-%H%M%S`
OUTPUT_DIR=${RESULT_DIR}/${STU_NAME}/test${TEST_ID}.${TS}


echo "Starting server for tests"
#Now this is the first time we start the server
mkdir ${OUTPUT_DIR}

${SERVER} 2>> ${OUTPUT_DIR}/server.err 1>> ${OUTPUT_DIR}/server.out & SERVER_PID=$!
echo "Server Process: ${SERVER_PID}"
sleep ${SLEEP_SERVER}

IS_RUNNING=`ps cax | grep ${SERVER_PID} | wc -l | awk '{print $1}'`
if [ "$IS_RUNNING" -eq 1 ]
then
    echo "server start normally" >> ${OUTPUT_DIR}/server.out
else
    echo "server cannot start normally" >> ${OUTPUT_DIR}/server.err
fi

echo -e "\n****************************************************************"
echo -e "* Running tests  "
echo -e "****************************************************************\n"

echo -n "[Running test ${TEST_ID}]"

# %s total seconds from 1970.1.1 %N = nanoseconds
TEST_START_TIME=$(date "+%s%N")
echo "${CLIENT} < ${TEST_DIR}/test${TEST_ID}.dsl"

cd "${PROJECT_DIR}/${STU_NAME}/coldb/src"

${CLIENT} < ${TEST_DIR}/test${TEST_ID}.dsl 2>> ${OUTPUT_DIR}/test${TEST_ID}.err 1>> ${OUTPUT_DIR}/test${TEST_ID}.out
RET_CODE=$?
echo "client return with code ${RET_CODE}"
TEST_DUR=$(($(date "+%s%N") - $TEST_START_TIME))
echo "Time: ${TEST_DUR}" >> ${OUTPUT_DIR}/test${TEST_ID}.time

echo "Test is finished"

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