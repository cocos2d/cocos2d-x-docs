#!/bin/sh

# This script builds: Cocos2d-x-docs, Cocos Creator Manual, Cocos Creator API-Ref.

# on production this script should be run as:
# (cd /data/home/docops/cocos2d-x-docs && exec /data/home/docops/cocos2d-x-docs/deploy_cron.sh)

echo "-----------------"
echo "Cocos2d-x-docs..."
echo "-----------------"
# First Cocos2d-x docs, we are aready in this repo when executing this script
## pull latest from github
echo "Cocos2d-x-docs -- pulling latest from GitHub..."
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

echo "-----------------------"
echo "Cocos Creator Manual..."
echo "-----------------------"
## pull latest from github
echo "Cocos Creator -- pulling latest from GitHub..."
cd ../creator-docs
git pull origin cocos2d-x.org

cp -rf config/cocos2d-x.org/. ./

## make sure gitbook is up to date
echo "Cocos Creator -- ensuring GitBook is up to date..."
gitbook install

## build it
echo "Cocos Creator -- building GitBook docs...."
echo "If this is your first time build this repo, please stop this process and run:"
echo "npm install gulp -g"
echo "npm install"
echo "DO NOT COMMIT: package-lock.json"
npm run build

## copy everything to deployment directory
echo "Cocos Creator -- copy everything to deployment directory..."
cp ../cocos2d-x-docs/redirect.html.en _book/index.html
mv _book/ creator/

rsync --recursive creator ../documentation

rm -rf creator/

echo "------------------------"
echo "Cocos Creator API-Ref..."
echo "------------------------"
## pull latest from github
echo "Cocos Creator API -- pulling latest from GitHub..."
cd ../creator-api-docs
git pull origin cocos2d-x.org

cp -rf config/cocos2d-x.org/. ./

## make sure gitbook is up to date
echo "Cocos Creator API -- ensuring GitBook is up to date..."
gitbook install

## build it
echo "Cocos Creator API -- building GitBook docs...."
gitbook build

## copy everything to deployment directory
echo "Cocos Creator API -- copy everything to deployment directory..."
cp ../cocos2d-x-docs/redirect.html.en _book/index.html
mv _book/ creator-api/

rsync --recursive creator-api ../documentation

rsync --recursive creator-api ../documentation/api-ref/creator
mv ../documentation/api-ref/creator/creator-api/ ../documentation/api-ref/creator/v1.7/

rm -rf creator-api/

cd ..
