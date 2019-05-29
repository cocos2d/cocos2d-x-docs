#!/bin/sh

# This script builds: Cocos2d-x-docs, Cocos Creator Manual, Cocos Creator API-Ref.

function convert_to_integer {
 echo "$@" | awk -F "." '{ printf("%03d%03d%03d\n", $1,$2,$3); }';
}

echo "**********************"
echo "Building Cocos Docs..."
echo "**********************"
echo "Hosekeeping..."
git_legacy=0
gitv1=2.7.4
git_string=0

git_version="$(git --version)"
git_version=${git_version#"git version "}
echo "Git version: "$git_version

if [ "$(convert_to_integer $git_version)" -gt "$(convert_to_integer $gitv1)" ];then
    #echo "$git_version is greater than or equal to $gitv1"
    git_legacy=0
    git_string="Already up to date"
    echo "Git version: modern"
else
    git_legacy=1
    git_string="Already up-to-date"
    echo "Git version: legacy"
fi

mkdir -p ../documentation/creator

# First Cocos2d-x docs, we are aready in this repo when executing this script
## pull latest from github
echo "***********************************************"
echo "Cocos2d-x Docs -- pulling latest from GitHub..."
echo "***********************************************"
git checkout master

if (git pull origin master | grep -q "$git_string"); then
    echo "*** Cocos2d-x skipped, GitHub repo up to date... ***"
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

echo "************************"
echo "Cocos Creator Manuals..."
echo "************************"
## pull latest from github
echo "Cocos Creator -- preparing to build documentation..."
cd ../creator-docs
rm -rf node_modules/

## pulling v1.9
echo "--------------------------------"
echo "Cocos Creator -- pulling v1.9..."
echo "--------------------------------"
git checkout v1.9

if (git pull origin v1.9 | grep -q "$git_string"); then
    echo "*** Cocos Creator v1.9 skipped, GitHub repo up to date... ***"
else
    #git pull origin v1.9
    cp -rf config/cocos2d-x.org/. ./
    echo "Cocos Creator v1.9 -- building GitBook docs...."
    echo "If this is your first time build this repo, please stop this process and run:"
    echo "npm install gulp -g"
    echo "npm install"
    echo "DO NOT COMMIT: package-lock.json"
    sudo npm install gulp -g
    sudo npm install
    echo "Cocos Creator v1.9 -- ensuring GitBook is up to date..."
    gitbook install
    npm run build
    echo "Cocos Creator v1.9 -- copy everything to deployment directory..."
    cp ../cocos2d-x-docs/redirect.html.en _book/index.html
    mv _book/ manual/
    rsync --recursive manual ../documentation/creator/1.9
    rm -rf manual/
    git stash
fi

echo "---------------------------------"
echo "Cocos Creator -- v1.9 done"
echo "---------------------------------"

## pulling v1.10
echo "---------------------------------"
echo "Cocos Creator -- pulling v1.10..."
echo "---------------------------------"
git checkout v1.10

if (git pull origin v1.10 | grep -q "$git_string"); then
    echo "*** Cocos Creator v1.10 skipped, GitHub repo up to date... ***"
else
    #git pull origin v1.10
    cp -rf config/cocos2d-x.org/. ./
    echo "Cocos Creator v1.10 -- building GitBook docs...."
    echo "If this is your first time build this repo, please stop this process and run:"
    echo "npm install gulp -g"
    echo "npm install"
    echo "DO NOT COMMIT: package-lock.json"
    sudo npm install gulp -g
    sudo npm install
    echo "Cocos Creator v1.10 -- ensuring GitBook is up to date..."
    gitbook install
    npm run build
    echo "Cocos Creator v1.10 -- copy everything to deployment directory..."
    cp ../cocos2d-x-docs/redirect.html.en _book/index.html
    mv _book/ manual/
    rsync --recursive manual ../documentation/creator/1.10
    rm -rf manual/
    git stash
fi
echo "---------------------------------"
echo "Cocos Creator -- v1.10 done"
echo "---------------------------------"

## pulling 2.0.x version
echo "---------------------------------"
echo "Cocos Creator -- pulling v2.0.x.."
echo "---------------------------------"
git checkout v2.0

if (git pull origin v2.0 | grep -q "$git_string"); then
    echo "*** Cocos Creator v2.x skipped, GitHub repo up to date... ***"
else
    #git pull origin v2.0
    cp -rf config/cocos2d-x.org/. ./
    echo "Cocos Creator v2.x-- building GitBook docs...."
    echo "If this is your first time build this repo, please stop this process and run:"
    echo "npm install gulp -g"
    echo "npm install"
    echo "DO NOT COMMIT: package-lock.json"
    sudo npm install gulp -g
    sudo npm install
    echo "Cocos Creator v2.x -- ensuring GitBook is up to date..."
    gitbook install
    npm run build
    echo "Cocos Creator v2.x -- copy everything to deployment directory..."
    cp ../cocos2d-x-docs/redirect.html.en _book/index.html
    mv _book/ manual/
    rsync --recursive manual ../documentation/creator/2.0
    rsync --recursive manual ../documentation/creator/
    rm -rf manual/
    git stash
fi
echo "---------------------------------"
echo "Cocos Creator - v2.0.x done"
echo "---------------------------------"

## pulling 2.10 version
echo "---------------------------------"
echo "Cocos Creator -- pulling v2.1...."
echo "---------------------------------"
git checkout v2.1

if (git pull origin v2.1 | grep -q "$git_string"); then
    echo "*** Cocos Creator v2.1.x skipped, GitHub repo up to date... ***"
else
    #git pull origin v2.1
    cp -rf config/cocos2d-x.org/. ./
    echo "Cocos Creator v2.1.x -- building GitBook docs...."
    echo "If this is your first time build this repo, please stop this process and run:"
    echo "npm install gulp -g"
    echo "npm install"
    echo "DO NOT COMMIT: package-lock.json"
    sudo npm install gulp -g
    sudo npm install
    echo "Cocos Creator v2.1.x -- ensuring GitBook is up to date..."
    gitbook install
    npm run build
    echo "Cocos Creator v2.1.x -- copy everything to deployment directory..."
    cp ../cocos2d-x-docs/redirect.html.en _book/index.html
    mv _book/ manual/
    rsync --recursive manual ../documentation/creator/2.1
    rm -rf manual/
    git stash
fi
echo "---------------------------------"
echo "Cocos Creator - v2.1 done"
echo "---------------------------------"

## pulling 2.2 version
echo "---------------------------------"
echo "Cocos Creator -- pulling v2.2...."
echo "---------------------------------"
git checkout v2.2

if (git pull origin v2.2 | grep -q "$git_string"); then
    echo "*** Cocos Creator v2.2 skipped, GitHub repo up to date... ***"
else
    #git pull origin v2.2
    cp -rf config/cocos2d-x.org/. ./
    echo "Cocos Creator v2.2.x -- building GitBook docs...."
    echo "If this is your first time build this repo, please stop this process and run:"
    echo "npm install gulp -g"
    echo "npm install"
    echo "DO NOT COMMIT: package-lock.json"
    sudo npm install gulp -g
    sudo npm install
    echo "Cocos Creator v2.2.x -- ensuring GitBook is up to date..."
    gitbook install
    npm run build
    echo "Cocos Creator v2.2.x -- copy everything to deployment directory..."
    cp ../cocos2d-x-docs/redirect.html.en _book/index.html
    mv _book/ manual/
    rsync --recursive manual ../documentation/creator/2.2
    rm -rf manual/
    git stash
fi
echo "---------------------------------"
echo "Cocos Creator - v2.2 done"
echo "---------------------------------"

echo "************************"
echo "Cocos Creator API-Ref..."
echo "************************"
echo "Cocos Creator API -- preparing to build documentation..."
cd ../creator-api-docs
rm -rf node_modules/

echo "---------------------------------"
echo "Cocos Creator API - v1.9...      "
echo "---------------------------------"
git checkout v1.9

if (git pull origin v1.9 | grep -q "$git_string"); then
    echo "*** Cocos Creator API v1.9 skipped, GitHub repo up to date... ***"
else
    #git pull origin v1.9
    cp -rf config/cocos2d-x.org/. ./
    echo "Cocos Creator API v1.9 -- ensuring GitBook is up to date..."
    gitbook install
    echo "Cocos Creator API v1.9 -- building GitBook docs...."
    gitbook build
    echo "Cocos Creator API v1.9 -- copy everything to deployment directory..."
    cp ../cocos2d-x-docs/redirect.html.en _book/index.html
    mv _book/ v1.9/
    rsync --recursive v1.9 ../documentation/api-ref/creator
    mv v1.9/ api/
    rsync --recursive api ../documentation/creator/1.9
    rm -rf api/
    git stash
fi
echo "---------------------------------"
echo "Cocos Creator API - v1.9 done"
echo "---------------------------------"

echo "---------------------------------"
echo "Cocos Creator API - v1.10..."
echo "---------------------------------"
git checkout v1.10

if (git pull origin v1.10 | grep -q "$git_string"); then
    echo "*** Cocos Creator API v1.10 skipped, GitHub repo up to date... ***"
else
    #git pull origin v1.10
    cp -rf config/cocos2d-x.org/. ./
    echo "Cocos Creator API v1.10 -- ensuring GitBook is up to date..."
    gitbook install
    echo "Cocos Creator API v1.10 -- building GitBook docs...."
    gitbook build
    echo "Cocos Creator API v1.10 -- copy everything to deployment directory..."
    cp ../cocos2d-x-docs/redirect.html.en _book/index.html
    mv _book/ v1.10/
    rsync --recursive v1.10 ../documentation/api-ref/creator
    mv v1.10/ api/
    rsync --recursive api ../documentation/creator/1.10
    rm -rf api/
    git stash
fi
echo "---------------------------------"
echo "Cocos Creator API - v1.10 done"
echo "---------------------------------"

echo "---------------------------------"
echo "Cocos Creator API - v2.0.x..."
echo "---------------------------------"
git checkout v2.0

if (git pull origin v2.0 | grep -q "$git_string"); then
    echo "*** Cocos Creator API v2.0 skipped, GitHub repo up to date... ***"
else
    #git pull origin v2.0
    cp -rf config/cocos2d-x.org/. ./
    echo "Cocos Creator API v2.0 -- ensuring GitBook is up to date..."
    gitbook install
    echo "Cocos Creator API v2.0 -- building GitBook docs...."
    gitbook build
    echo "Cocos Creator API v2.0 -- copy everything to deployment directory..."
    cp ../cocos2d-x-docs/redirect.html.en _book/index.html
    mv _book/ api/
    rsync --recursive api ../documentation/creator/
    rsync --recursive api ../documentation/creator/2.0/
    mv api/ v2.0/
    rsync --recursive v2.0 ../documentation/api-ref/creator
    rm -rf v2.0/
    git stash
fi
echo "---------------------------------"
echo "Cocos Creator API - v2.0.x"
echo "---------------------------------"

echo "---------------------------------"
echo "Cocos Creator API - v2.1..."
echo "---------------------------------"
git checkout v2.1

if (git pull origin v2.1 | grep -q "$git_string"); then
    echo "*** Cocos Creator API v2.1 skipped, GitHub repo up to date... ***"
else
    #git pull origin v2.1
    cp -rf config/cocos2d-x.org/. ./
    echo "Cocos Creator API v2.1 -- ensuring GitBook is up to date..."
    gitbook install
    echo "Cocos Creator API v2.1 -- building GitBook docs...."
    gitbook build
    echo "Cocos Creator API v2.1 -- copy everything to deployment directory..."
    cp ../cocos2d-x-docs/redirect.html.en _book/index.html
    mv _book/ v2.1/
    rsync --recursive v2.1 ../documentation/api-ref/creator
    mv v2.1/ api/
    rsync --recursive api ../documentation/creator/2.1
    rm -rf api/
    git stash
fi
echo "---------------------------------"
echo "Cocos Creator API - v2.1 done"
echo "---------------------------------"

echo "---------------------------------"
echo "Cocos Creator API - v2.2..."
echo "---------------------------------"
git checkout v2.2

if (git pull origin v2.2 | grep -q "$git_string"); then
    echo "*** Cocos Creator API v2.2 skipped, GitHub repo up to date... ***"
else
    #git pull origin v2.2
    cp -rf config/cocos2d-x.org/. ./
    echo "Cocos Creator API v2.2 -- ensuring GitBook is up to date..."
    gitbook install
    echo "Cocos Creator API v2.2 -- building GitBook docs...."
    gitbook build
    echo "Cocos Creator API v2.2 -- copy everything to deployment directory..."
    cp ../cocos2d-x-docs/redirect.html.en _book/index.html
    mv _book/ v2.2/
    rsync --recursive v2.2 ../documentation/api-ref/creator
    mv v2.2/ api/
    rsync --recursive api ../documentation/creator/2.2
    rm -rf api/
    git stash
fi
echo "---------------------------------"
echo "Cocos Creator API - v2.2 done"
echo "---------------------------------"

cd ..

echo "---------------------------------"
echo "Deploying to web-server location"
echo "---------------------------------"
echo "Copy to nginx..."
#cd ~
#rsync --recursive documentation /var/www

echo "---------------------------------"
echo "Restarting web-server..."
echo "---------------------------------"
#sudo /usr/sbin/nginx -s stop
#sudo /usr/sbin/nginx

echo "---------------------------------"
echo "Deployment done!"
echo "---------------------------------"
