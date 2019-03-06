#! /bin/bash

trap "echo; echo SIGINT/SIGTERM detected. Exiting ...; exit;" SIGINT SIGTERM

##########################################
# Global Variables for Test Shell Script #
##########################################

STU_NAME=$1

TEST_DIR="/home/rui/Development/coldb-benchmark/project-tests"
PROJECT_DIR="/home/rui/Development/coldb-benchmark/stu-projects"
RESULT_DIR="/home/rui/Development/coldb-benchmark/test-results"

SLEEP_SERVER=2
SLEEP_TEST=1

#Test id
MAX_TEST=09
CUR_TEST_ID=01
TEST_IDS=`seq -w 1 ${MAX_TEST}`

##########################################
# Testing Processing
##########################################

echo "Test" $TEST_IDS "will launch"

echo -e "\n****************************************************************"
echo -e "* Compiling  "
echo -e "****************************************************************\n"

cd ${PROJECT_DIR}/${STU_NAME}/coldb/src
make clean
RET_CODE=$?
if [ ${RET_CODE} -ne 0 ]
then
    echo "[Please make sure you have a \"make clean\" option.]"
    exit 0
fi

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

echo -e "\n****************************************************************"
echo -e "* Checking whether tests exist"
echo -e "****************************************************************\n"

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
OUTPUT_DIR=${RESULT_DIR}/${STU_NAME}/MS1.${TS}

echo "Starting server for tests"
#Now this is the first time we start the server
mkdir ${OUTPUT_DIR}
${SERVER} 2>> ${OUTPUT_DIR}/server.err 1>> ${OUTPUT_DIR}/server.out & SERVER_PID=$!
echo "Server Process: ${SERVER_PID}"
sleep ${SLEEP_SERVER}

IS_RUNNING=`ps cax | grep ${SERVER_PID} | wc -l | awk '{print $1}'`
if [ "$IS_RUNNING" -ne 1 ]
then
    echo "server cannot start normally" >> ${OUTPUT_DIR}/server.err
    exit 1
else
    echo "server start normally"
fi

echo -e "\n****************************************************************"
echo -e "* Running tests  "
echo -e "****************************************************************\n"

for CUR_TEST_ID in ${TEST_IDS}
do
    echo -n "[Running test ${CUR_TEST_ID}]"

    IS_RUNNING=`ps cax | grep ${SERVER_PID} | wc -l | awk '{print $1}'`
    if [ "${IS_RUNNING}" -eq 0 ]
    then
        echo "server is off, restart it"
        ${SERVER} 2>> ${OUTPUT_DIR}/server.err 1>> ${OUTPUT_DIR}/server.out & SERVER_PID=$!
    fi

    # %s total seconds from 1970.1.1 %N = nanoseconds
    TEST_START_TIME=$(date "+%s%N")
    echo "${CLIENT} < ${TEST_DIR}/test${CUR_TEST_ID}.dsl"

    ${CLIENT} < ${TEST_DIR}/test${CUR_TEST_ID}.dsl 2> ${OUTPUT_DIR}/test${CUR_TEST_ID}.err 1> ${OUTPUT_DIR}/test${CUR_TEST_ID}.out
    RET_CODE=$?
    MESSAGE="client return an code ${RET_CODE} after test${CUR_TEST_ID}"
    echo -e "$MESSAGE"
    TEST_DUR=$(($(date "+%s%N") - $TEST_START_TIME))
    echo "Time: ${TEST_DUR}" >> ${OUTPUT_DIR}/test${CUR_TEST_ID}.time

    # The server is expected to shutdown after test 01 and test 02 in milestone
    if [ "${CUR_TEST_ID}" -eq 01 ] || [ "${CUR_TEST_ID}" -eq 02 ]
    then
        echo "check test ${CUR_TEST_ID}"
        IS_RUNNING=`ps cax | grep ${SERVER_PID} | wc -l | awk '{print $1}'`
        if [ "${IS_RUNNING}" -eq 1 ]
        then
            # if the server is still running after test 01, 02, shutdown and restart
            echo "shutdown the server for the next test"
            kill -9 ${SERVER_PID}
            ${SERVER} 2>> ${OUTPUT_DIR}/server.err 1>> ${OUTPUT_DIR}/server.out & SERVER_PID=$!
        else
            # restart the server for the next test
            ${SERVER} 2>> ${OUTPUT_DIR}/server.err 1>> ${OUTPUT_DIR}/server.out & SERVER_PID=$!
        fi
    fi
done

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

