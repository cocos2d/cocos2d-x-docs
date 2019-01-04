#!/bin/sh

# This script builds: Cocos2d-x-docs, Cocos Creator Manual, Cocos Creator API-Ref.

echo "-----------------------------------------------"
echo "Cocos2d-x-docs "
echo "-----------------------------------------------"
git checkout master
git pull origin master

./deploy_cron.sh