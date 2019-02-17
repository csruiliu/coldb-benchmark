-- Load+create Data and shut down of tbl1 which has 1 attribute only
DROP TABLE IF EXISTS tbl1 CASCADE;
CREATE TABLE tbl1 (col1 int);

COPY tbl1 FROM '/home/cs165/cs165-management-scripts/project_tests_2017/data1-ps.csv' WITH (FORMAT csv, DELIMITER ',');

INSERT INTO tbl1 (col1)  VALUES (-1);
INSERT INTO tbl1 (col1)  VALUES (-2);
INSERT INTO tbl1 (col1)  VALUES (-3);
INSERT INTO tbl1 (col1)  VALUES (-4);
INSERT INTO tbl1 (col1)  VALUES (-5);
INSERT INTO tbl1 (col1)  VALUES (-6);
INSERT INTO tbl1 (col1)  VALUES (-7);
INSERT INTO tbl1 (col1)  VALUES (-8);
INSERT INTO tbl1 (col1)  VALUES (-9);
INSERT INTO tbl1 (col1)  VALUES (-10);

-- Load+create Data and shut down of tbl2 which has 4 attributes
DROP TABLE IF EXISTS tbl2 CASCADE;
CREATE TABLE tbl2 (col1 int, col2 int, col3 int, col4 int);

COPY tbl2 FROM '/home/cs165/cs165-management-scripts/project_tests_2017/data2-ps.csv' WITH (FORMAT csv, DELIMITER ',');

INSERT INTO tbl2 (col1,col2,col3,col4)  VALUES (-1,-11,-111,-1111);
INSERT INTO tbl2 (col1,col2,col3,col4)  VALUES (-2,-22,-222,-2222);
INSERT INTO tbl2 (col1,col2,col3,col4)  VALUES (-3,-33,-333,-2222);
INSERT INTO tbl2 (col1,col2,col3,col4)  VALUES (-4,-44,-444,-2222);
INSERT INTO tbl2 (col1,col2,col3,col4)  VALUES (-5,-55,-555,-2222);
INSERT INTO tbl2 (col1,col2,col3,col4)  VALUES (-6,-66,-666,-2222);
INSERT INTO tbl2 (col1,col2,col3,col4)  VALUES (-7,-77,-777,-2222);
INSERT INTO tbl2 (col1,col2,col3,col4)  VALUES (-8,-88,-888,-2222);
INSERT INTO tbl2 (col1,col2,col3,col4)  VALUES (-9,-99,-999,-2222);
INSERT INTO tbl2 (col1,col2,col3,col4)  VALUES (-10,-11,0,34);

DROP TABLE IF EXISTS tbl3 CASCADE;
DROP TABLE IF EXISTS tbl4 CASCADE;
DROP TABLE IF EXISTS tbl5 CASCADE;
CREATE TABLE tbl3 (col1 int, col2 int, col3 int, col4 int);
CREATE TABLE tbl4 (col1 int, col2 int, col3 int, col4 int);
CREATE TABLE tbl5 (col1 int, col2 int, col3 int, col4 int);
COPY tbl3 FROM '/home/cs165/cs165-management-scripts/project_tests_2017/data3-ps.csv' WITH (FORMAT csv, DELIMITER ',');
COPY tbl4 FROM '/home/cs165/cs165-management-scripts/project_tests_2017/data4-ps.csv' WITH (FORMAT csv, DELIMITER ',');
COPY tbl5 FROM '/home/cs165/cs165-management-scripts/project_tests_2017/data5-ps.csv' WITH (FORMAT csv, DELIMITER ',');
-- control
DROP TABLE IF EXISTS tbl3_ctrl CASCADE;
DROP TABLE IF EXISTS tbl4_ctrl CASCADE;
CREATE TABLE tbl4_ctrl (col1 int, col2 int, col3 int, col4 int);
CREATE TABLE tbl3_ctrl (col1 int, col2 int, col3 int, col4 int);
COPY tbl3_ctrl FROM '/home/cs165/cs165-management-scripts/project_tests_2017/data3_ctrl-ps.csv' WITH (FORMAT csv, DELIMITER ',');
COPY tbl4_ctrl FROM '/home/cs165/cs165-management-scripts/project_tests_2017/data4_ctrl-ps.csv' WITH (FORMAT csv, DELIMITER ',');
-- batch
DROP TABLE IF EXISTS tbl3_batch CASCADE;
CREATE TABLE tbl3_batch (col1 int, col2 int, col3 int, col4 int);
COPY tbl3_batch FROM '/home/cs165/cs165-management-scripts/project_tests_2017/data3_batch-ps.csv' WITH (FORMAT csv, DELIMITER ',');
