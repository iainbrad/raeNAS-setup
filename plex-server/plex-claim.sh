#!/bin/bash

# remove all setup scripts
rm -r ~/raeNAS-setup

clear
echo "**********************************************"
echo "**********************************************"
echo "*****                                    *****"
echo "*****         USER INPUT NEEDED          *****"
echo "*****                                    *****"
echo "*****  Go to https://www.plex.tv/claim/  *****"
echo "*****    click on 'Copy to Clipboard'    *****"
echo "*****      paste into prompt below       *****"
echo "*****                                    *****"
echo "**********************************************"
echo "**********************************************"

read -p 'Plex Claim Code: ' claimcode

# replace PLEXCLAIM with user input
sed -i "s/PLEXCLAIM/$claimcode/g" docker-compose.yml

# start plex stack
docker-compose up -d

cd
