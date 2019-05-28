#!/bin/sh

echo "----------------------"
echo "Building Cocos Docs..."
echo "----------------------"
# First Cocos2d-x docs, we are aready in this repo when executing this script
## pull latest from github
echo "-----------------------------------------------"
echo "Cocos2d-x-docs -- pulling latest from GitHub..."
echo "-----------------------------------------------"
git checkout master

## git 2.7.4 returns different message than later versions

if ((git pull origin master | grep -q "Already up-to-date") || 
(git pull origin master | grep -q "Already up to date")); then
    echo "Cocos2d-x skipped, GitHub repo up to date..."
else
    echo "Building Cocos2d-x docs..."
    #git pull origin master
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
fi
