#!/bin/sh
ETEOL=$(tput el)

tput sc
clear
echo "--------------------"
echo "Archie docker0"
echo "STOP"
echo "--------------------"
CONTCNT=$(sudo docker ps -qa | wc -l)
sudo docker kill --signal=SIGINT $(sudo docker ps -qaf "status=running") > /dev/null
while true
do 
    TX=$(head /sys/class/net/docker0/statistics/tx_bytes)
    ptx="↓ $(numfmt --to iec --format "%8.4f" $TX)"
    RX=$(head /sys/class/net/docker0/statistics/rx_bytes)
    prx="↑ $(numfmt --to iec --format "%8.4f" $RX)"
    CONTUPD=$(sudo docker ps -qaf "status=running" | wc -l)
    tput rc
    printf "$ptx $prx\n"
    printf "$CONTUPD out of $CONTCNT alive containers$ETEOL\n"
    sleep 0.1
done