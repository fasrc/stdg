#!/bin/bash
#This is the master job launcher for STDG.  It will take the data fed to it by stdg.sh and then run in a loop to generate the jobs that STDG specifies.

# Need to make our output directory if it doesn't exist.
mkdir "$OutputDir"

# Let's put ourselves into an infinite loop as we will rely on scancel or the time limit to kill this.
while :
do
	# Need to discriminate between using job arrays or not.
	if [ $UseArray == "T" ]; then
		echo "Using Array"
        sbatch -t "$Time" -p "$Partition" -A "$AccountName" -J "$AccountName"-job -o "$OutputDir"/"$AccountName"-%A-%a.log -n "$NumCPU" --mem "$Mem" -a 1-"$NumJobs" --qos="$QOS" --gres="$GRES" --constraint="$Resources" "$JobScript"
	else
		echo "Normal"
        i=1
        while [ $i -le $NumJobs ];
        do
            sbatch -t "$Time" -p "$Partition" -A "$AccountName" -J "$AccountName"-job -o "$OutputDir"/"$AccountName"-%A.log -n "$NumCPU" --mem "$Mem" --qos="$QOS" --gres="$GRES" --constraint="$Resources" "$JobScript"
            let i=i+1
        done
	fi

	# Sleep for specified amount of time then start all over again.
	sleep "$SubmitFreq"m
done
