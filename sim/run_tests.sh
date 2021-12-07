# -----------------------------------------------------------------------------
# Project name   :
# File name      : run_tests.sh
# Created date   : Mar 30 2018
# Author         : Huy-Hung Ho
# Last modified  : Mar 30 2018 10:12
# Guide          :
# -----------------------------------------------------------------------------
#!/bin/bash
num_of_test=10;
start_test=1;
img_size=784*1000;
file_test="../tb/test_input.bin"
file_in="../tb/input.bin"
file_out="../tb/output_ann.bin"

rm -r $file_out
for i in `seq 0 $(($num_of_test-1))`
do
	first_line=$(($start_test+$i*$img_size));
	end_line=$(($start_test+($i+1)*$img_size - 1));
	sed $first_line,$end_line'!d' $file_test > $file_in
	vsim -c -do "log -r /*; run -a; exit;" top_module_tb
done

