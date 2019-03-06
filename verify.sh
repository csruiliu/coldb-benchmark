#!/bin/bash

CUR_OUT_FILE=$1

CUR_READY_FILE=$2

CUR_EXP_FILE=$3


#keep all numbers since the results are only numbers
sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g' ${CUR_OUT_FILE} | sed -r '/[a-zA-Z~\s!@#$%\^\+\*&\\\/\?\|:<>{}();="]/d' | sed "/--/d" | sed '/^$/d' > ${CUR_READY_FILE}

#Used for grading
CUR_TEST_PASSED=1

DIFF=`diff -B -w -y ${CUR_READY_FILE} ${CUR_EXP_FILE}`

echo ${DIFF}