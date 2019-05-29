#!/bin/sh

# This script builds: Cocos2d-x-docs, Cocos Creator Manual, Cocos Creator API-Ref.

echo "-----------------------------------------------"
echo "Cocos2d-x-docs "
echo "-----------------------------------------------"
git checkout master
git pull origin master

./deploy_cron.sh

echo "---------------------------------"
echo "Deploying to web-server location"
echo "---------------------------------"
echo "Copy to nginx..."
cd ~
rsync --recursive documentation /var/www

echo "---------------------------------"
echo "Restarting web-server..."
echo "---------------------------------"
sudo /usr/sbin/nginx -s stop
sudo /usr/sbin/nginx

echo "---------------------------------"
echo "Deployment done!"
echo "---------------------------------"
