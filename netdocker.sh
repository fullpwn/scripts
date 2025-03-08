#!/bin/sh
ETEOL=$(tput el)
tput sc

clear
echo "--------------------"
echo "Archie docker0"
echo "--------------------"
    PRTXRD=0
    PRRXRD=0
while true
do 
    
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
    printf "$ptx $prx\n"
    printf "↓ $TXFRM ↑ $RXFRM\n"
    if [ $CONTUPD -eq $CONTCNT ]
    then
        printf "All containers healthy.$ETEOL\n"
    else    
        printf "$CONTUPD out of $CONTCNT alive containers$ETEOL\n"
    fi
    sleep 0.1
done