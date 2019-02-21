# Benchmark for ColDB #

### fetch code via Git ###
Update `STUDENTS_FILE`, `GIT_URL`, `PROJECT_PATH_BASE` in `fetch-repo.sh`. `STUDENT_FILE` is the file store all students' emails; `GIT_URL` is the git base url, normally this url plus students' name should be the complete git url which can be used to get the code; `PROJECT_PATH_BASE` is the directory that all the student's code will be stored in. You can also use `fetch-repo-para.sh`, the only difference is that student name is a parameter. 

Usage: `./fetch-repo.sh` or `./fetch-repo-para.sh [student_name]`  

### run single test ### 
Update `TEST_DIR`,`PROJECT_DIR`,`RESULT_DIR` in the `single-test.sh`. `TEST_DIR` is the directory stores all the test files. `PROJECT_DIR` is the same directory as `PROJECT_PATH_BASE` in `fetch-repo.sh`. `RESULT_DIR` is the directory will store all the test results for each students. 

Usage: `./single-test.sh [student_name] [test_id]`

### run milstone test ###
`milestone[n].sh` is the collection of single tests. Again, update `TEST_DIR`,`PROJECT_DIR`,`RESULT_DIR` so that the script file can find the code the store the testing results correctly. 

Usage: `./milestone[n].sh [student_name]`

### miscellaneous ###
`clean-repo.sh`: delete all the students' code
`kill-server.sh`: kill any running `./server` process




