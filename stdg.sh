#!/bin/bash

# Read in the config file.
# This generates bash arrays for the variables.
while read line; do 
    if [[ $line =~ ^"["(.+)"]"$ ]]; then 
        arrname=${BASH_REMATCH[1]}
        declare -A $arrname
    elif [[ $line =~ ^([_[:alpha:]][_[:alnum:]]*)"="(.*) ]]; then 
        declare ${arrname}[${BASH_REMATCH[1]}]="${BASH_REMATCH[2]}"
    fi
done < stdg.conf

# Setup General Logfile
LOGFILE=${info[LoggingLocation]}'/'${info[RunID]}.log

# Dump General Information to Log
echo "Starting Run Generator" | tee $LOGFILE
echo "Info" | tee -a $LOGFILE
echo "Logging Location:" ${info[LoggingLocation]} | tee -a $LOGFILE
echo "Run ID:" ${info[RunID]} | tee -a $LOGFILE
echo "Duration:" ${info[Duration]} | tee -a $LOGFILE
echo "NumAcct:" ${info[NumAcct]} | tee -a $LOGFILE

# Setup variables
index=1

# This loop works through each acct index and then sets up the dummy accounts
# and submits the jobs that will generate all the other jobs.
while [ $index -le ${info[NumAcct]} ];
do
	# Due to the fact that we are getting deep into bash vodoo here we are
	# going to simplify our lives by reading out the array into new variables
	# that should be easier to deal with.
	name=acct$index
	eval AccountName=\${$name[AccountName]}
	eval Fairshare=\${$name[Fairshare]}
	eval NumJobs=\${$name[NumJobs]}
	eval SubmitFreq=\${$name[SubmitFreq]}
	eval NumCPU=\${$name[NumCPU]}
	eval Mem=\${$name[Mem]}
	eval Time=\${$name[Time]}
	eval UseArray=\${$name[UseArray]}
	eval Partition=\${$name[Partition]}
	eval OutputDir=\${$name[OutputDir]}
	eval Resources=\${$name[Resources]}
	eval GRES=\${$name[GRES]}
	eval Clean=\${$name[Clean]}
	eval JobScript=\${$name[JobScript]}
    eval QOS=\${$name[QOS]}

	# Exporting these as environmental variables so that we can use them in slurm.
	export AccountName
	export Fairshare
	export NumJobs
	export SubmitFreq
	export NumCPU
	export Mem
	export Time
	export UseArray
	export Partition
	export OutputDir
	export Resources
	export GRES
	export Clean
    export JobScript
    export QOS

	echo "" | tee -a $LOGFILE
	echo "Account Parameters for" $AccountName | tee -a $LOGFILE
	echo "Fairshare:" $Fairshare | tee -a $LOGFILE
	echo "NumJobs:" $NumJobs | tee -a $LOGFILE
	echo "SubmitFreq:" $SubmitFreq | tee -a $LOGFILE
	echo "NumCPU:" $NumCPU | tee -a $LOGFILE
	echo "Mem:" $Mem | tee -a $LOGFILE
	echo "Time:" $Time | tee -a $LOGFILE
	echo "UseArray:" $UseArray | tee -a $LOGFILE
	echo "Partition:" $Partition | tee -a $LOGFILE
	echo "OutputDir:" $OutputDir | tee -a $LOGFILE
	echo "Resources:" $Resources | tee -a $LOGFILE
	echo "GRES:" $GRES | tee -a $LOGFILE
	echo "Clean:" $Clean | tee -a $LOGFILE
    echo "JobScript:" $JobScript | tee -a $LOGFILE
    echo "QOS:" $QOS | tee -a $LOGFILE

	# Clean up account if needed
	if [ $Clean == "T" ]; then
		sacctmgr -i delete account name="$AccountName"
	fi

	# Create Account and Associate user in Slurmdb
	sacctmgr -i create account name="$AccountName" 
	sacctmgr -i modify account name="$AccountName" set fairshare=$Fairshare
	sacctmgr -i add user name=$USER account="$AccountName" fairshare=parent

	# Submit Job Submitting Job to cluster
	sbatch -t ${info[Duration]} -p "$Partition" -A "$AccountName" -J "$AccountName"-master --qos="$QOS" -o "$AccountName"-master-%A.log joblauncher.slurm

	let index=index+1
done
