#! /bin/bash
#echo "DO NOT RUN - under refactoring"
# ENV=`env`
# echo -e "pull_run_compile.sh is in maintenace mode (ppid=$PPID).\n ENV:\n$ENV " | mail -s "Maintenance Notice" manos@cs.uchicago.edu, kester@cs.uchicago.edu;
# exit

trap "echo; echo SIGINT/SIGTERM detected. Exiting ...; exit;" SIGINT SIGTERM

##########################################
# Global Variables for Test Shell Script #
##########################################

#DUMMY_DIR="/home/rui/Development/coldb-benchmark/dummy_data"
TEST_DIR="/home/rui/Development/coldb-benchmark/project-test"
PROJECT_PATH="/home/rui/Development/coldb"

#Sleep times after server is enabled
SLEEP_SERVER=2
SLEEP_TEST=1

#Test id
MAX_TEST=09
CUR_TEST_ID=01
TEST_IDS=`seq -w 1 ${MAX_TEST}`


# Variables for formatting
RED="\x1b[31m"
GRN="\x1b[32m"
RST="\x1b[0m"
GREEN_OK="[${GRN}ok${RST}]"
RED_FAIL="[${RED}FAIL${RST}]"


##########################################
# Entire Testing Processing              #
##########################################

echo "Test" $TEST_IDS "will launch"
 
#-e will handle special character 
echo -e "\n****************************************************************"
echo -e "* Compiling  "
echo -e "****************************************************************\n"

cd $PROJECT_PATH/src
make clean
#$? the return code of previous function or command 
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

SERVER="./server"
CLIENT="./client"

# TODO: Check server and client exist or not

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
OUTPUT_DIR=${PROJECT_PATH}/test.${TS}

echo "Starting server for tests"
#Now this is the first time we start the server
mkdir ${OUTPUT_DIR}
${SERVER} 2>> ${OUTPUT_DIR}/server.err 1>> ${OUTPUT_DIR}/server.out & SERVER_PID=$!
sleep $SLEEP_SERVER

echo -e "\n****************************************************************"
echo -e "* Running tests  "
echo -e "****************************************************************\n"


for CUR_TEST_ID in $TEST_IDS;
do
    # Check whether the server is running
    # if not, restart it
    IS_RUNNING=`ps cax | grep ${SERVER_PID} | wc -l | awk '{print $1}'`
    if [ "$IS_RUNNING" -eq 0 ]
    then
        ${SERVER} 2>> ${OUTPUT_DIR}/server.err 1>> ${OUTPUT_DIR}/server.out & SERVER_PID=$!
    fi

    sleep $SLEEP_TEST

    # Run individual test
    echo -n "[Running test ${TEST_ID}]"

    # %s total seconds from 1970.1.1 %N = nanoseconds
    TEST_START_TIME=$(date "+%s%N")
    echo "${CLIENT} < ${TEST_DIR}/test${CUR_TEST_ID}.dsl"
    ${CLIENT} < ${TEST_DIR}/test${CUR_TEST_ID}.dsl 2> ${OUTPUT_DIR}/test${CUR_TEST_ID}.err 1> ${OUTPUT_DIR}/test${CUR_TEST_ID}.out 
    echo "RET_CODE: ${RET_CODE}"
    RET_CODE=$?
    TEST_DUR=$(($(date "+%s%N") - $TEST_START_TIME))

    # Check whether the status after testing,
    if [ "${RET_CODE}" -ne 0 ]
    then
        MESSAGE="client return an error code after test${CUR_TEST_ID} (err=${RET_CODE})."
        echo -e "$MESSAGE ${RED_FAIL}"
        if [ "${RET_CODE}" -eq 141 ]
        then
            echo -e "It seems that it is a segmentation fault error!"
            exit 0
        fi
        exit 0
    else
        echo "Time: ${TEST_DUR}" >> ${OUTPUT_DIR}/test${CUR_TEST_ID}.time 
    fi

    # The server is expected to shutdown after test 01 and test 02 in milestone
    if [ "${CUR_TEST_ID}" -eq 01 ] || [ "${CUR_TEST_ID}" -eq 02 ]
    then
        echo "shutdown the server for the next test"
        kill -9 ${SERVER_PID}
    fi
done

IS_RUNNING=`ps cax | grep ${SERVER_PID} | wc -l | awk '{print $1}'`
if [ "$IS_RUNNING" -eq 0 ]
then
    kill -9 ${SERVER_PID}
fi

