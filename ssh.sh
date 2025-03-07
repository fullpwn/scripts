#!/bin/sh
USR=$1
IP=$2
while true
do 
    clear
    ssh -t $USR@$IP /bin/bash
    sleep 0.1
done