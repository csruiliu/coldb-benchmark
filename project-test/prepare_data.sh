cd ../datagen

if [ $? -ne 0 ]; then
    echo "Executing from wrong path. Exiting ..."
    exit 1
fi

DATA_SIZE_TEST=1000000 #1M
DATA_SIZE_BENCH=100000000
DATA_SIZE_BATCH=10000000 #10M

make clean
make
./gen $DATA_SIZE_TEST 1 db1.tbl1 0 > ../project_tests_2017/data1.csv
./gen $DATA_SIZE_TEST 1 db1.tbl1 0 0 > ../project_tests_2017/data1-ps.csv
./gen $DATA_SIZE_TEST 4 db1.tbl2 1 > ../project_tests_2017/data2.csv
./gen $DATA_SIZE_TEST 4 db1.tbl2 1 0 > ../project_tests_2017/data2-ps.csv
./gen $DATA_SIZE_TEST 4 db1.tbl3 1 > ../project_tests_2017/data3.csv
./gen $DATA_SIZE_TEST 4 db1.tbl3 1 0 > ../project_tests_2017/data3-ps.csv
./gen $DATA_SIZE_TEST 4 db1.tbl4 1 > ../project_tests_2017/data4.csv
./gen $DATA_SIZE_TEST 4 db1.tbl4 1 0 > ../project_tests_2017/data4-ps.csv
./gen $DATA_SIZE_TEST 4 db1.tbl5 2 > ../project_tests_2017/data5.csv
./gen $DATA_SIZE_TEST 4 db1.tbl5 2 0 > ../project_tests_2017/data5-ps.csv
# control
./gen $DATA_SIZE_TEST 4 db1.tbl3_ctrl 1 > ../project_tests_2017/data3_ctrl.csv
./gen $DATA_SIZE_TEST 4 db1.tbl3_ctrl 1 0 > ../project_tests_2017/data3_ctrl-ps.csv
./gen $DATA_SIZE_TEST 4 db1.tbl4_ctrl 1 > ../project_tests_2017/data4_ctrl.csv
./gen $DATA_SIZE_TEST 4 db1.tbl4_ctrl 1 0 > ../project_tests_2017/data4_ctrl-ps.csv
# batch
./gen $DATA_SIZE_BATCH 4 db1.tbl3_batch 1 > ../project_tests_2017/data3_batch.csv
./gen $DATA_SIZE_BATCH 4 db1.tbl3_batch 1 0 > ../project_tests_2017/data3_batch-ps.csv

# Benchmark

# ./gen $DATA_SIZE_BENCH 4 db1.tbl2B 1 > ../project_tests_2017/data2B.csv
# cat ../project_tests_2017/data2B.csv | tail -n +2 > ../project_tests_2017/data2B-ps.csv
# #./gen $DATA_SIZE_BENCH 4 db1.tbl2B 1 0 > ../project_tests_2017/data2B-ps.csv
#
# ./gen $DATA_SIZE_BENCH 4 db1.tbl3B 1 > ../project_tests_2017/data3B.csv
# cat ../project_tests_2017/data3B.csv | tail -n +2 > ../project_tests_2017/data3B-ps.csv
# #./gen $DATA_SIZE_BENCH 4 db1.tbl3B 1 0 > ../project_tests_2017/data3B-ps.csv
#
# ./gen $DATA_SIZE_BENCH 4 db1.tbl5B 2 > ../project_tests_2017/data5B.csv
# cat ../project_tests_2017/data5B.csv | tail -n +2 > ../project_tests_2017/data5B-ps.csv
# #./gen $DATA_SIZE_BENCH 4 db1.tbl5B 2 0 > ../project_tests_2017/data5B-ps.csv
