#!/bin/bash
# Pings slurm to create rpc traffic.

while :
do
	/usr/bin/squeue > /dev/null
	/usr/bin/sacct -u pedmon > /dev/null
	sleep 1m
done
