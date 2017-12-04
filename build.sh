#!/bin/sh

# This script builds: Cocos2d-x-docs, Cocos Creator Manual, Cocos Creator API-Ref.

echo "-----------------"
echo "Cocos2d-x-docs..."
echo "-----------------"
# First Cocos2d-x docs, we are aready in this repo when executing this script
## pull latest from github
echo "Cocos2d-x-docs -- pulling latest from GitHub..."
git pull origin master

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

echo "Cocos2d-x-docs -- copy everything to deployment directory..."
cp -R api-ref editors_and_tools en gitbook index.html package.json search_plus_index.json zh ../../documentation/

cd ..
rm -rf _book/

echo "-----------------------"
echo "Cocos Creator Manual..."
echo "-----------------------"
## pull latest from github
echo "Cocos Creator -- pulling latest from GitHub..."
cd ../creator-docs
git pull origin cocos2d-x.org

## build it
echo "Cocos Creator -- building GitBook docs...."
gitbook build

## copy everything to deployment directory
echo "Cocos Creator -- copy everything to deployment directory..."
cp ../cocos2d-x-docs/index.html.en _book/index.html
mv _book/ creator/
mv creator ../documentation/

rm -rf creator/

echo "------------------------"
echo "Cocos Creator API-Ref..."
echo "------------------------"
## pull latest from github
echo "Cocos Creator API -- pulling latest from GitHub..."
cd ../creator-api-docs
git pull origin cocos2d-x.org

## build it
echo "Cocos Creator API -- building GitBook docs...."
gitbook build

## copy everything to deployment directory
echo "Cocos Creator API -- copy everything to deployment directory..."
cp ../cocos2d-x-docs/index.html.en _book/index.html
mv _book/ creator-api/
mv creator-api ../documentation/

rm -rf creator-api/
