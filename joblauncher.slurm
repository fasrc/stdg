#!/bin/bash
#This is the master job launcher for STDG.  It will take the data fed to it by stdg.sh and then run in a loop to generate the jobs that STDG specifies.

# Let's put ourselves into an infinite loop as we will rely on scancel or the time limit to kill this.
while :
do
	# Need to discriminate between using job arrays or not.
	if [ $UseArray == "T" ]; then
		echo "Using Array"
	else
		echo "Normal"
	fi

	# Sleep for specified amount of time then start all over again.
	sleep "$SubmitFreq"m
done
