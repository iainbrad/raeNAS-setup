#!/bin/bash

# install additional packages needed and perform full upgrade of all other packages
echo Installing packages necessary for all installations...
apt install zip unzip -y && apt clean

# tidy directory
rm README.md
rm ~/*.deb
mv ~/raeNAS-setup/openvpn-as ~/
mv ~/raeNAS-setup/noip ~/
mv ~/raeNAS-setup/plex-server ~/

# set up openvpn
echo Setting up openVPN...
cd ~/openvpn-as
docker-compose up -d

# set up noip
echo Setting up noip...
cd ~/noip
docker-compose up -d

# set up plex server stack
echo Setting up Plex stack...
cd ~/plex-server
chmod +x plex-update.sh
chmod +x plex-claim.sh
docker-compose up -d
docker-compose stop

# copy configurations to docker volumes
cd ~
unzip ~/plex-server/configs.zip
rm ~/plex-server/configs.zip
cp -r ~/plex-server_jackett/_data/ /var/lib/docker/volumes/plex-server_jackett_data/_data/
cp -r ~/plex-server_radarr_data/_data/ /var/lib/docker/volumes/plex-server_radarr_data/_data/
rm -r ~/plex-server_radarr_data/
rm -r ~/plex-server_jackett_data/

# setup cron task to refresh all of Plex stack every Wednesday at midnight
crontab -l 2>/dev/null; echo "0 0 * * 3 ~/plex-server/plex-update.sh > /dev/null" | crontab -

# start script to claim Plex server
cd ~/plex-server
# ./plex-claim.sh