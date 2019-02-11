# Set the expectation of the tests based on indicated user runs

def getExecutionTime(user,test_number):
	if test_number <= 9: 
		str_test_number = "0" + str(test_number)
	else:
		str_test_number = str(test_number)

	return int(open("../../projects/"+user+"/last/test"+str_test_number+".time",'rb').read())

def makeExpFile(exp_file_array,slack):
	exp_file = open("test"+str(exp_file_array[1])+".exp.time",'wb')
	exp_file.write("test"+str(exp_file_array[0])+" "+str((exp_file_array[2]*1.0/exp_file_array[3])*(1+slack)))
	print "test"+str(exp_file_array[1])+".exp.time:"
	print "test"+str(exp_file_array[0])+" "+str((exp_file_array[2]*1.0/exp_file_array[3])*(1+slack))


# slack 
slack = 0.25 # 50 percent

# The list of users to run to create expectation files
students = ["t1","t2","t3","t4","t5"]
students = ["t2"]

# List of tests for which performance is to be tested
exp_files = []

# the last two numbers in the sub-list track the sum of speed up between the tests and the number of users tested
exp_files.append([16,17,0,0]) # creates test17.exp.time
exp_files.append([20,21,0,0]) # creates test21.exp.time
exp_files.append([22,23,0,0]) # creates test23.exp.time
exp_files.append([26,27,0,0]) # creates test27.exp.time
exp_files.append([28,29,0,0]) # creates test29.exp.time



for exp_file in exp_files:
	for student in students:
		exp_file[2] += getExecutionTime(student,exp_file[1]) * 1.0 / getExecutionTime(student,exp_file[0]) * 1.0
		exp_file[3] += 1

for exp_file in exp_files:
	makeExpFile(exp_file,slack)
