#!/bin/bash
# Pings slurm to create rpc traffic.

while :
do
	/usr/bin/squeue
	/usr/bin/sacct -u pedmon
	sleep 10s
done
