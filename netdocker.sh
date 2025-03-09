#!/bin/bash
ETEOL=$(tput el)
tput sc

clear
echo "--------------------"
echo "Archie docker0"
echo "--------------------"
    PRTXRD=$(head /sys/class/net/docker0/statistics/tx_bytes)
    PRRXRD=$(head /sys/class/net/docker0/statistics/rx_bytes)
while true
do 
    DISK=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
    TX=$(head /sys/class/net/docker0/statistics/tx_bytes)
    ptx="↓ $(numfmt --to iec --format "%8.4f" $TX)"
    RX=$(head /sys/class/net/docker0/statistics/rx_bytes)
    prx="↑ $(numfmt --to iec --format "%8.4f" $RX)"
    CONTCNT=$(sudo docker ps -qa | wc -l)
    CONTUPD=$(sudo docker ps -qaf "status=running" | wc -l)
    TXCLC=$(($TX - $PRTXRD))
    TXFRM=$(numfmt --to iec --format "%8.4f" $TXCLC)
    RXCLC=$(($RX - $PRRXRD))
    RXFRM=$(numfmt --to iec --format "%8.4f" $RXCLC)
    PRTXRD=$TX
    PRRXRD=$RX

    tput rc
    printf "$ptx $prx\033[0K\r\n"
    printf "↓ $TXFRM/s ↑ $RXFRM/s\033[0K\r\n"
    
    if [ $DISK -gt 20 ]
    then
        printf "Disk usage: $DISK\%$ETEOL\033[0K\r\n"
    fi
    if [ $CONTUPD -eq $CONTCNT ]
    then
        printf "All containers healthy.$ETEOL\033[0K\r\n"
    else    
        printf "$CONTUPD out of $CONTCNT alive containers$ETEOL\033[0K\r\n"
    fi
    sleep 1
done