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

DUMMY_DIR=/home/rui/Development/coldb-benchmark/dummy_data
TEST_DIR=/home/rui/Development/coldb-benchmark/project-test
PROJECT_PATH="/home/rui/Development/coldb/src"

#The username (email)!
INPUT_USER_ID=""

#Global to require tag
REQUIRE_TAG=0

#This option is used when we want to only pull code and exit then
EXIT_AFTER_PULL=0
SKIP_PULL=0
EXIT_IF_CLIENT_FAILS_LOAD=0
KILL_ALL_RUNNING_SERVERS_IN_THE_END=1
DELETE_REPO_BEFORE_PULLING=-1
FORCE_DELETE=0
MAKE_DEBUG=0
SEND_TO_STUDENT=0
CC_TFS=0
NO_EMAIL=0
ONLY_GRADING=0

#Sleep times after server is enabled
SLEEP_SERVER=2
SLEEP_TEST=1

#TEST ID
MAX_TEST=41
CUR_TEST_ID=03
TEST_IDS=`seq -w 1 ${MAX_TEST}`

#Enable/Disable interaction with leaderboard
ENABLE_LEADERBOARD_UPDATE=1
ENABLE_BENCHMARKING=0
MAX_AVAILABLE_BENCHMARKS=8
################
## MS1 BENCH 1-2
## MS2 BENCH 3-4
## MS3 BENCH 5
## MS4 BENCH 6-7
## MS5 BENCH 8
################

#Configure tests for Milestones
### !!!! WARNING !!!! SERVER IS EXPECTED TO BE SHUT DOWN AT 0,2,3,11,14,15 LOOK AT LINES 948, 965 
MAX_AVAILABLE_MS=4
MAX_TEST=41
TEST_IDS=`seq -w 1 ${MAX_TEST}`
## MS1 1-9
MS1_LAST=9
MS1_BNDRY=10
## MS2 10-17
MS2_LAST=17
MS2_BNDRY=18
## MS3 18-29
MS3_LAST=29
MS3_BNDRY=30
## MS4 30-35
MS4_LAST=35
MS4_BNDRY=36
##For current milestone 
ATTACH=""
CUR_CHECKING_MS=0

#Enrolled students list 
ENROLLMENT_LIST="students.tsv"
FILE_LAST_SCORES="status.last_scores.tmp"

#Counters for grading
MS1_TOT=9
MS1_PASSED=0
MS2_TOT=9
MS2_PASSED=0
MS3_TOT=12
MS3_PASSED=0
MS4_TOT=9
MS4_PASSED=0



echo -e "\n****************************************************************"
echo -e "* Compiling  "
echo -e "****************************************************************\n"

cd $PROJECT_PATH
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
