#!/bin/sh
#Config
PROJECT="urls"
USERNAME="fullpwnmedia"
#Prep
ident() {
clear
echo "--------------------"
echo "$1"
echo "--------------------"
}

# Update System
ident "Archie OVH"
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=remote/ssh
# many other tests omitted
    curl https://missaustraliana.net/warrior/netdocker.sh | sh
else
  case $(ps -o comm= -p "$PPID") in
    sshd|*/sshd) SESSION_TYPE=remote/ssh;;
    
  esac
  
fi
sudo apt update
sudo apt -y upgrade
# Clear out the bitch
ident "Cleaning sessions"
sudo docker rm -v -f $(sudo docker ps -qa)
ident "Building $1 sessions.."
sudo docker run --detach --name watchtower --restart=on-failure --volume /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --label-enable --include-restarting --cleanup --interval 3600
for (( i=0; i<$1; ++i)); do
    if (("$i" < 10)); then
	prt="0$i"
	else
	prt="$i"
	fi
	#echo $prt
#    sudo docker run --env DOWNLOADER=$USERNAME --env HTTP_USERNAME= --env HTTP_PASSWORD= --env SELECTED_PROJECT=$PROJECT --env SHARED_RSYNC_THREADS=6 --detach --name s$i --label=.com.centurylinklabs.watchtower.enable=true --log-driver json-file --log-opt max-size=50m --publish 80$prt:8001 --restart=on-failure atdr.meo.ws/archiveteam/warrior-dockerfile
    sudo docker run -d --name s$i --label=com.centurylinklabs.watchtower.enable=true --restart=unless-stopped atdr.meo.ws/archiveteam/$PROJECT-grab --concurrent 16 fullpwnmedia
#echo "session$i $USERNAME $PROJECT"
done


#sudo docker container stats
clear
curl https://missaustraliana.net/warrior/watchdog | bash -s -- 0