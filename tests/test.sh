#!/bin/bash

#exec_command test
../nimsh < ./test_data/exec_command.test.txt &> ./result/exec_command.result.txt
diff ./should_be/exec_command.should_be.txt ./result/exec_command.result.txt || echo "ExecuteCommandTest is Faild."

