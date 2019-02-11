cd ../datagen

if [ $? -ne 0 ]; then
    echo "Executing from wrong path. Exiting ..."
    exit
fi

echo "Generating tiny datasets ..."

make clean
make
./gen 100 1 db1.tbl1 0 > ../project_tests_2017/data1.csv
./gen 100 1 db1.tbl1 0 0 > ../project_tests_2017/data1-ps.csv
./gen 100 4 db1.tbl2 0 > ../project_tests_2017/data2.csv
./gen 100 4 db1.tbl2 0 0 > ../project_tests_2017/data2-ps.csv
./gen 100 4 db1.tbl3 0 > ../project_tests_2017/data3.csv
./gen 100 4 db1.tbl3 0 0 > ../project_tests_2017/data3-ps.csv
./gen 100 4 db1.tbl4 0 > ../project_tests_2017/data4.csv
./gen 100 4 db1.tbl4 0 0 > ../project_tests_2017/data4-ps.csv
./gen 100 4 db1.tbl5 0 > ../project_tests_2017/data5.csv
./gen 100 4 db1.tbl5 0 0 > ../project_tests_2017/data5-ps.csv
# control
./gen 100 4 db1.tbl3_ctrl 0 > ../project_tests_2017/data3_ctrl.csv
./gen 100 4 db1.tbl3_ctrl 0 0 > ../project_tests_2017/data3_ctrl-ps.csv
./gen 100 4 db1.tbl4_ctrl 0 > ../project_tests_2017/data4_ctrl.csv
./gen 100 4 db1.tbl4_ctrl 0 0 > ../project_tests_2017/data4_ctrl-ps.csv
# batch 
./gen 100 4 db1.tbl3_batch 0 > ../project_tests_2017/data3_batch.csv
./gen 100 4 db1.tbl3_batch 0 0 > ../project_tests_2017/data3_batch-ps.csv

