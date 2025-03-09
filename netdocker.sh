#!/bin/bash
ETEOL=$(tput el)
tput sc

clear
echo "--------------------"
echo "Archie docker0"
echo "--------------------"
    PRTXRD=$(head /sys/class/net/docker0/statistics/tx_bytes)
    PRRXRD=$(head /sys/class/net/docker0/statistics/rx_bytes)
    TRIP=0
while true
do 
    DISK=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
    DOCKERDSK=$(sudo du -sb /var/lib/docker/containers | awk '{print $1}')
    DOCKERDSKFRM=$(numfmt --to iec --format "%8.4f" $DOCKERDSK)
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
    
    if [ $DISK -gt 90 ]
    then
        sudo docker kill --signal=SIGINT $(sudo docker ps -qaf "status=running") > /dev/null
        TRIP=1

    elif [ $TRIP -eq 1 ]
        then
            if [ $CONTUPD -eq 0 ]
                then
                printf "Rebooting!\033[0K\r\n"
                sudo reboot
              exit 1
            else 
                printf "Pending reboot. $DISK/90$ETEOL\033[0K\r\n"
            fi
    else
        printf "Disk: $DISK/90$ETEOL\033[0K\r\n"
    fi
    printf "Taking: $DOCKERDSKFRM $ETEOL\033[0K\r\n"
    if [ $CONTUPD -eq $CONTCNT ]
    then
        printf "All containers healthy.$ETEOL\033[0K\r\n"
    else    
        printf "$CONTUPD out of $CONTCNT alive containers$ETEOL\033[0K\r\n"
    fi
    sleep 1
done