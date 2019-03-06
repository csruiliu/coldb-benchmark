#!/bin/bash

STU_NAME=$1

TEST_PATH="/home/rui/Development/coldb-benchmark/test-results"

if [ ! -n "$1" ] ;then
    echo "clean all the students' test results."
    rm -rf ${TEST_PATH}/*
else
    echo "clean the test results of student $1"
    rm -rf ${TEST_PATH}/${STU_NAME}
fi

