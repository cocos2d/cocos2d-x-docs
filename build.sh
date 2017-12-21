#!/bin/sh

# This script builds: Cocos2d-x-docs, Cocos Creator Manual, Cocos Creator API-Ref.

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
cp index.html.en _book/index.html
cp ../api-refs-static-pages.tar.gz _book/.
cp ../editors_and_tools.tar.gz _book/.

## copy everything to deployment directory
cd _book/

echo "Cocos2d-x-docs -- extracting everything..."
tar xvf api-refs-static-pages.tar.gz
tar xvf editors_and_tools.tar.gz

echo "Cocos2d-x-docs -- removing unneeded files..."
rm -rf api-refs-static-pages.tar.gz
rm -rf editors_and_tools.tar.gz

cd ..

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

## make sure gitbook is up to date
echo "Cocos Creator -- ensuring GitBook is up to date..."
gitbook install

## build it, this repo uses npm to build
echo "Cocos Creator -- building GitBook docs...."
echo "If this is your first time build this repo, please stop this process and run:"
echo "npm install gulp -g"
echo "npm install"
echo "DO NOT COMMIT: package-lock.json"
npm run build

## copy everything to deployment directory
echo "Cocos Creator -- copy everything to deployment directory..."
cp ../cocos2d-x-docs/index.html.en _book/index.html
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

## make sure gitbook is up to date
echo "Cocos Creator API -- ensuring GitBook is up to date..."
gitbook install

## build it
echo "Cocos Creator API -- building GitBook docs...."
gitbook build

## copy everything to deployment directory
echo "Cocos Creator API -- copy everything to deployment directory..."
cp ../cocos2d-x-docs/index.html.en _book/index.html
mv _book/ creator-api/

rsync --recursive creator-api ../documentation

rm -rf creator-api/
