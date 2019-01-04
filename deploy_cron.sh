#!/bin/sh

# This script builds: Cocos2d-x-docs, Cocos Creator Manual, Cocos Creator API-Ref.

# on production this script should be run as:
# (cd /data/home/docops/cocos2d-x-docs && exec /data/home/docops/cocos2d-x-docs/deploy_cron.sh)

echo "-----------------"
echo "Cocos2d-x-docs..."
echo "-----------------"
# First Cocos2d-x docs, we are aready in this repo when executing this script
## pull latest from github
echo "-----------------------------------------------"
echo "Cocos2d-x-docs -- pulling latest from GitHub..."
echo "-----------------------------------------------"
git checkout master
git pull origin master

cp -rf config/cocos2d-x.org/. ./

## make sure gitbook is up to date
echo "Cocos2d-x-docs -- ensuring GitBook is up to date..."
gitbook install

## build it
echo "Cocos2d-x-docs -- building GitBook docs...."
gitbook build

## copy some needed files
echo "Cocos2d-x-docs -- copying needed files..."
cp redirect.html.en _book/index.html
cp index.html.en ../documentation/index.html

## copy everything to deployment directory
echo "Cocos2d-x-docs -- copy everything to deployment directory..."

mv _book/ cocos2d-x/

rsync --recursive cocos2d-x ../documentation

rm -rf cocos2d-x/

git stash

echo "-----------------------"
echo "Cocos Creator Manual..."
echo "-----------------------"
## pull latest from github
echo "Cocos Creator -- preparing to build documentation..."
cd ../creator-docs
rm -rf node_modules/

## pulling legacy version
echo "--------------------------------"
echo "Cocos Creator -- pulling v1.9..."
echo "--------------------------------"
git checkout v1.9
git pull origin v1.9
cp -rf config/cocos2d-x.org/. ./
echo "Cocos Creator -- building GitBook docs...."
echo "If this is your first time build this repo, please stop this process and run:"
echo "npm install gulp -g"
echo "npm install"
echo "DO NOT COMMIT: package-lock.json"
sudo npm install gulp -g
sudo npm install
echo "Cocos Creator -- ensuring GitBook is up to date..."
gitbook install
npm run build
echo "Cocos Creator -- copy everything to deployment directory..."
cp ../cocos2d-x-docs/redirect.html.en _book/index.html
mv _book/ manual/
rsync --recursive manual ../documentation/creator/1.9
rm -rf manual/
git stash
echo "---------------------------------"
echo "Cocos Creator -- v1.9 done"
echo "---------------------------------"

## pulling previous version
echo "---------------------------------"
echo "Cocos Creator -- pulling v1.10..."
echo "---------------------------------"
git checkout master
git pull origin master
cp -rf config/cocos2d-x.org/. ./
echo "Cocos Creator -- building GitBook docs...."
echo "If this is your first time build this repo, please stop this process and run:"
echo "npm install gulp -g"
echo "npm install"
echo "DO NOT COMMIT: package-lock.json"
sudo npm install gulp -g
sudo npm install
echo "Cocos Creator -- ensuring GitBook is up to date..."
gitbook install
npm run build
echo "Cocos Creator -- copy everything to deployment directory..."
cp ../cocos2d-x-docs/redirect.html.en _book/index.html
mv _book/ manual/
rsync --recursive manual ../documentation/creator/1.10
rm -rf manual/
git stash
echo "---------------------------------"
echo "Cocos Creator - v1.10 done"
echo "---------------------------------"

## pulling 2.0.x version
echo "---------------------------------"
echo "Cocos Creator -- pulling v2.0.x.."
echo "---------------------------------"
git checkout next
git pull origin next
cp -rf config/cocos2d-x.org/. ./
echo "Cocos Creator -- building GitBook docs...."
echo "If this is your first time build this repo, please stop this process and run:"
echo "npm install gulp -g"
echo "npm install"
echo "DO NOT COMMIT: package-lock.json"
sudo npm install gulp -g
sudo npm install
echo "Cocos Creator -- ensuring GitBook is up to date..."
gitbook install
npm run build
echo "Cocos Creator -- copy everything to deployment directory..."
cp ../cocos2d-x-docs/redirect.html.en _book/index.html
mv _book/ manual/
rsync --recursive manual ../documentation/creator
rm -rf manual/
git stash
echo "---------------------------------"
echo "Cocos Creator - v2.0.x done"
echo "---------------------------------"

## pulling 2.10 version
echo "---------------------------------"
echo "Cocos Creator -- pulling v2.1...."
echo "---------------------------------"
git checkout v2.1
git pull origin v2.1
cp -rf config/cocos2d-x.org/. ./
echo "Cocos Creator -- building GitBook docs...."
echo "If this is your first time build this repo, please stop this process and run:"
echo "npm install gulp -g"
echo "npm install"
echo "DO NOT COMMIT: package-lock.json"
sudo npm install gulp -g
sudo npm install
echo "Cocos Creator -- ensuring GitBook is up to date..."
gitbook install
npm run build
echo "Cocos Creator -- copy everything to deployment directory..."
cp ../cocos2d-x-docs/redirect.html.en _book/index.html
mv _book/ manual/
rsync --recursive manual ../documentation/creator/2.1
rm -rf manual/
git stash
echo "---------------------------------"
echo "Cocos Creator - v2.1 done"
echo "---------------------------------"

echo "------------------------"
echo "Cocos Creator API-Ref..."
echo "------------------------"
## pull latest from github
echo "Cocos Creator API -- preparing to build documentation..."
cd ../creator-api-docs
rm -rf node_modules/

echo "---------------------------------"
echo "Cocos Creator API - v1.9..."
echo "---------------------------------"
git checkout v1.9
git pull origin v1.9
cp -rf config/cocos2d-x.org/. ./
echo "Cocos Creator API -- ensuring GitBook is up to date..."
gitbook install
echo "Cocos Creator API -- building GitBook docs...."
gitbook build
echo "Cocos Creator API -- copy everything to deployment directory..."
cp ../cocos2d-x-docs/redirect.html.en _book/index.html
mv _book/ v1.9/
rsync --recursive v1.9 ../documentation/api-ref/creator
mv v1.9/ api/
rsync --recursive api ../documentation/creator/1.9


#rm -rf ../documentation/api-ref/creator/v1.9/
#mv ../documentation/api-ref/creator/api/ ../documentation/api-ref/creator/v1.9/

rm -rf api/
git stash
echo "---------------------------------"
echo "Cocos Creator API - v1.9 done"
echo "---------------------------------"

echo "---------------------------------"
echo "Cocos Creator API - v1.10..."
echo "---------------------------------"
git checkout master
git pull origin master
cp -rf config/cocos2d-x.org/. ./
echo "Cocos Creator API -- ensuring GitBook is up to date..."
gitbook install
echo "Cocos Creator API -- building GitBook docs...."
gitbook build
echo "Cocos Creator API -- copy everything to deployment directory..."
cp ../cocos2d-x-docs/redirect.html.en _book/index.html
mv _book/ v1.10/
rsync --recursive v1.10 ../documentation/api-ref/creator
mv v1.10/ api/
rsync --recursive api ../documentation/creator/1.10


#rm -rf ../documentation/api-ref/creator/v1.9/
#mv ../documentation/api-ref/creator/api/ ../documentation/api-ref/creator/v1.9/

rm -rf api/
git stash
echo "---------------------------------"
echo "Cocos Creator API - v1.10 done"
echo "---------------------------------"

echo "---------------------------------"
echo "Cocos Creator API - v2.0.x..."
echo "---------------------------------"
git checkout v2.0
git pull origin v2.0
cp -rf config/cocos2d-x.org/. ./
echo "Cocos Creator API -- ensuring GitBook is up to date..."
gitbook install
echo "Cocos Creator API -- building GitBook docs...."
gitbook build
echo "Cocos Creator API -- copy everything to deployment directory..."
cp ../cocos2d-x-docs/redirect.html.en _book/index.html
mv _book/ api/
rsync --recursive api ../documentation/creator/
mv api/ v2.0/
rsync --recursive v2.0 ../documentation/api-ref/creator

#rm -rf ../documentation/api-ref/creator/v1.9/
#mv ../documentation/api-ref/creator/api/ ../documentation/api-ref/creator/v1.9/

rm -rf v2.0/
git stash
echo "---------------------------------"
echo "Cocos Creator API - v2.0.x"
echo "---------------------------------"

echo "---------------------------------"
echo "Cocos Creator API - v2.1..."
echo "---------------------------------"
git checkout v2.1
git pull origin v2.1
cp -rf config/cocos2d-x.org/. ./
echo "Cocos Creator API -- ensuring GitBook is up to date..."
gitbook install
echo "Cocos Creator API -- building GitBook docs...."
gitbook build
echo "Cocos Creator API -- copy everything to deployment directory..."
cp ../cocos2d-x-docs/redirect.html.en _book/index.html
mv _book/ v2.1/
rsync --recursive v2.1 ../documentation/api-ref/creator
mv v2.1/ api/
rsync --recursive api ../documentation/creator/2.1

#rm -rf ../documentation/api-ref/creator/v1.9/
#mv ../documentation/api-ref/creator/api/ ../documentation/api-ref/creator/v1.9/

rm -rf api/
git stash
echo "---------------------------------"
echo "Cocos Creator API - v2.1 done"
echo "---------------------------------"

cd ..

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
