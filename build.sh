#!/bin/sh

# This script lets developers test docs locally

echo "-----------------"
echo "Cocos2d-x-docs..."
echo "-----------------"

cp -rf config/cocos2d-x.org/. ./

## build it
echo "Cocos2d-x-docs -- building GitBook docs...."
gitbook build

gitbook serve
