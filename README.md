STDG (Slurm Test Deck Generator)

# Overview

The STDG is designed to generate a synthetic work load for a slurm scheduler.  Rather than replaying a run log this simulator creates synthetic load and can be tuned to produce any style of workload.  While this doesn't support time modification to speed up run time, one can emulate that by simply shortening the runtimes of the jobs and their spacing.  The Test Deck Generator is meant to work through normal slurm commands so that one can see the additional load and hang ups due to different options and configurations.

# Usage

The configuration file contains all the relevant job parameters of the test decks you wish to submit.  There is an example stdg.conf that is in in stdg.conf.example.  Simply place the conf you want to use at stdg.conf and stdg.sh will read it in and generate your test run.  The generator will launch master jobs to your test cluster.  These master jobs will then act as submission scripts that will behave like users submiting jobs to the cluster at regular periods.  When you are done simply run scancel to destroy all the jobs.  Currently this runs as your user so you will need to have permission to use sacctmgr and create accounts.

##stdg.conf
The conf itself has a number of features and leverages bash arrays.  The first section is just general info with the following parameters:

LoggingLocation: Where do you want to create the log file for this run.

RunID: What is the name of your run.  The logfile will have this name.

Duration: How long do you want the jobsubmitting jobs to run for.

NumAcct: How many different submitters will you have.  Recall all jobs are submitted as your user, so accounts are necessary for differentiating between fairshare.

Next is the account set up.  Each account is denoted by acct#index, where #index is an integer from 1 to NumAcct.  For each account you have the following parameters to define:

AccountName: What is the name for the account in the slurm database.

Clean: (T/F), should the account be started from scratch or pick up from its previous history.

Fairshare: What fairshare score should the account have.

NumJobs: How many jobs in a batch should this account submit.

SubmitFreq (minutes): How often should the account submit a batch of jobs numbering NumJobs.  This is in minutes.

NumCPU: How many cpu should each job ask for.

Mem (MB): How much memory should each job ask for in MB.

Time (minutes): How long should each job last for in minutes.

UseArray: (T/F), should the jobs be submitted using an array or by looping over sbatch.

Partition: Which partitions should the jobs use, note that the master job will use these same partitions.

OutputDir: Where should the output and error logs for these runs be dumped.

Resources: Do you have any resources/constraints you want to apply to the jobs.  Note that this can be blank.

GRES: Do you have any GRES options for this job.  Note that this can be blank.

JobScript: What script do you want to run for each job.

QOS: Do you have any QOS's you want to use for this job.  Note that this can be blank.
