#!/bin/bash
#set -x

trap "echo; echo SIGINT/SIGTERM detected. Exiting ...; exit;" SIGINT SIGTERM

#Some globals for the messages
RED="\x1b[31m"
GRN="\x1b[32m"
RST="\x1b[0m"

#Check a few things:
# 1) which milestone
# 2) where are the emails being sent

FORCE=0
DELETE=0
BENCHMARKING=""
TIMEOUT=300s
TEST=0
MS=5
NO_EMAIL=0
CLEAR_ALL=0

#;; is the end of case 
#stdin,stdout,stderr are &1, &2, &3, so >&2 means print content to stdout

while getopts ":fhdT:m:tBNC" opt; do
    case $opt in
        C)
            echo "-C (clear all contents)" >&2
            CLEAR_ALL=1
            ;;
        N)
            echo "-N (No email whatsoever!)" >&2
            NO_EMAIL=1
            ;;
        B)
            echo "-B (enable Benchmarking)" >&2
            BENCHMARKING=" -B "
            ;;
        T)
            echo "-T (set Timeout to $OPTARG)" >&2
            TIMEOUT=$OPTARG
            ;;
        m)
            echo "-m (set milestone to $OPTARG)" >&2
            MS=$OPTARG
            ;;
        t)
            echo "-t (this is a test run -- no emails)" >&2
            TEST=1
            ;;
        d)
            echo "-d (delete repos contents before pulling)" >&2
            DELETE=1
            ;;
        f)
            echo "-f (no interactive questions, just do it)" >&2
            FORCE=1
            ;;
        h)
            echo "$0 can be called with the following options"
            echo -e "\t-h\tthis help message"
            echo -e "\t-C\tclear all projects (delete and download code)"
            echo -e "\t-T\tset Timeout (default $TIMEOUT)"
            echo -e "\t-B\tenable Benchmarking!"
            echo -e "\t-m\tset milestone (default $MS)"
            echo -e "\t-t\ttest run (no emails to students)"
            echo -e "\t-N\tNo email whatsoever (not even to TAs)"
            echo -e "\t-f\tjust do it, do not complain"
            echo -e "\t-d\tdelete repos contents before pulling (default no)"
            exit
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit
            ;;
    esac
done

MSG=""
if [ ! -z "${BENCHMARKING}" ]; then
    MSG=" (for benchmarking)"
fi

#echo $MSG

############
# STARTING #
############
echo " ##Starting full workflow at `date`$MSG" >> status.full_workflow
echo "Starting full workflow at `date`$MSG"

########################################################
# GET LATEST GIT URL SUBMISSIONS FROM THE GOOGLE DRIVE #
########################################################
#No need since it is too late in the semester
#TODO enable again for next year
#./load_students_GF_to_notgaius.sh


##########################################
# POPULATE THE MOST RECENT STUDENTS LIST #
##########################################
#No need since it is late in the semester
#TODO enable again for next year
#./get_current_student_list.sh

echo
echo
echo "**************************************************************************"
echo "Checking the current settings before sending out a massive load of emails!"
echo "**************************************************************************"
echo "Milestone: $MS"
echo "Delete: $DELETE"
echo "Force: $FORCE"
echo "Timeout: $TIMEOUT"
echo "Test (no emails): $TEST"
echo "**************************************************************************"
#echo "This execution will look for LATEST tag and WILL be looking for a tag unless"
#echo "the script ./pull_run_compile.sh is called with different arguments."
#echo "**************************************************************************"
#echo "The emails are being sent to (\$TO is the student's email):"
#grep -n -E "SEND_EMAIL_TO|SEND_EMAIL_CC|DEFAULT_TO|DEFAULT_CC" pull_run_compile.sh | grep -v echo | grep -v "#" | grep -v mutt | grep -v "\-z"
echo "**************************************************************************"
echo "Max email size is `grep MAX_EMAIL_SIZE pull_run_compile.sh | head -1 | awk -F "=" '{print $2}'` bytes."
echo "**************************************************************************"
echo -n "The script will check the projects of "
#Make sure we get the latest updates for the students info; this is done within list_all_students.sh
echo -n `./list_all_students.sh 2>&1 | grep "students submitted" | awk '{print $1}'`
echo " students."
echo "**************************************************************************"
echo

if [ "$FORCE" -eq 0 ]; then
    read -p "Do you want to continue? (y/n) " ANS
else
    ANS="y" # just for now so the cron will run.
fi

rm -f status.timed_out_projects
rm -f status.emails_sent
rm -f status.emails_failed_to_send
rm -f status.last_scores

if [ ! "$ANS" = "y" ]
then
    echo
    echo "Change options here and in \"pull_run_compile.sh\" and run $0 again!"
    echo "Exiting ..."
    exit
fi

#Make sure we have the latest tests
./fetch_tests.sh

DELETE_COMMAND=""
if [ "$DELETE" -eq 1 ]; then
    DELETE_COMMAND="-f"
fi

EMAIL_COMMAND="-C -S"
if [ "$TEST" -eq 1 ]; then
    EMAIL_COMMAND=""
fi

if [ "$NO_EMAIL" -eq 1 ]; then
    EMAIL_COMMAND="-N"
fi

#STUDENT_INFO_FILE=/home/cs165/cs165_students.tsv
STUDENT_INFO_FILE=sampleStudents.tsv

COUNT=`cat $STUDENT_INFO_FILE | wc -l | awk '{print $1}'`
#TODO it was count-1 but it seems that it was wrong. keep that in mmind
#let COUNT=COUNT-1

echo "**************************************************************************"
echo "Delete command: $DELETE_COMMAND."
echo "**************************************************************************"
echo "Email command: $EMAIL_COMMAND."
echo "**************************************************************************"

for i in `seq 1 $COUNT`;do
    EMAIL=`./get_email.sh $i`

    if [ $CLEAR_ALL -eq 1 ]; then
        ./pull_run_compile.sh -u $EMAIL $EMAIL_COMMAND -f -p
    else
        #set -x
        timeout --signal=HUP ${TIMEOUT} ./pull_run_compile.sh -u $EMAIL $EMAIL_COMMAND -m $MS $DELETE_COMMAND $BENCHMARKING
    fi
    if [ "$?" -ne 0 ]; then
        echo -e "Execution for $EMAIL timed out after $TIMEOUT ... ${RED}FAIL${RST}"
        echo "$EMAIL" >> status.timed_out_projects
    fi
done


## Calculate stats
./project_overview.sh > status.last_project_overview


echo "**************************************************************************"
echo -n "The script prepared "
echo -n `cat emails_sent 2> /dev/null | wc -l | awk '{print $1}'`
echo " emails."
echo "**************************************************************************"

#############
# COMPLETED #
#############
echo " ##Full workflow completed at `date`$MSG" >> status.full_workflow
