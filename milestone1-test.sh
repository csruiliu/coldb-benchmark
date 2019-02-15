#! /bin/bash
#testing with ./pull_run_compile.sh -u aelmore@cs.uchicago.edu -N -m 1
#set -x

#echo "DO NOT RUN - under refactoring"
# ENV=`env`
# echo -e "pull_run_compile.sh is in maintenace mode (ppid=$PPID).\n ENV:\n$ENV " | mail -s "Maintenance Notice" manos@cs.uchicago.edu, kester@cs.uchicago.edu;
# exit

trap "echo; echo SIGINT/SIGTERM detected. Exiting ...; exit;" SIGINT SIGTERM

##########################################
# Global Varibles for Test Shell Scirpt  #
##########################################

#DUMMY_DIR="/home/rui/Development/coldb-benchmark/dummy_data"
TEST_DIR="/home/rui/Development/coldb-benchmark/project-test"
PROJECT_PATH="/home/rui/Development/coldb"

#Sleep times after server is enabled
SLEEP_SERVER=2
SLEEP_TEST=1

#TEST ID
MAX_TEST=09
CUR_TEST_ID=01
TEST_IDS=`seq -w 1 ${MAX_TEST}`


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
if [ "${RET_CODE}" -ne 0 ]; then
    echo "<p>Please make sure you have a \"make clean\" option.</p>"
    exit 0
fi
echo "Compiling ..."
make
RET_CODE=$?
if [ "${RET_CODE}" -ne 0 ]; then
    echo "<p>Please make sure you have a \"make\" option.</p>"
    exit 0
fi

SERVER="./server"
CLIENT="./client"

#################################################################
# Testing engine!
# Checking whether tests exist!
# (This should be updated because no they will doing tests)
#################################################################

if [ -d ${TEST_DIR} ]
then
	echo "Test dir found: $TEST_DIR!"
#echo "Fetching new tests ..."
#$SCRIPT_DIR/fetch_tests.sh
else
	echo -e "No tests to use, please populate them!"
    exit 0
fi

#this is the timestamp of the whole trial
TS=`date +%Y%m%d-%H%M%S`
OUTPUT_DIR=${PROJECT_PATH}/run.${TS}

echo "Starting server for tests"
#Now this is the first time we start the server
mkdir ${OUTPUT_DIR}
${SERVER} 2>> ${OUTPUT_DIR}/server.err 1>> ${OUTPUT_DIR}/server.out &
SERVER_PID=$!
sleep $SLEEP_SERVER

echo -e "\n****************************************************************"
echo -e "* Running tests  "
echo -e "****************************************************************\n"


# runt test
echo -n "[Running test ${TEST_ID}]"
start=$(date +%s%N)
echo "${CLIENT} < ${TEST_DIR}/test${CUR_TEST_ID}.dsl"
${CLIENT} < ${TEST_DIR}/test${CUR_TEST_ID}.dsl 2> ${OUTPUT_DIR}/test${CUR_TEST_ID}.err 1> ${OUTPUT_DIR}/test${CUR_TEST_ID}.out

