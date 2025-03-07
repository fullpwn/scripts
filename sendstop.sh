#!/bin/sh
ETEOL=$(tput el)
clear
tput sc

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
    printf "Finalizing archive.. This might take a while.\n"
    printf "$ptx $prx\n"
    if [ $CONTUPD = 0 ];
    then
        printf "Goodbye!$ETEOL\n"
        sudo reboot
    else    
        printf "$CONTUPD out of $CONTCNT alive containers$ETEOL\n"
    fi
    
    sleep 0.1
done