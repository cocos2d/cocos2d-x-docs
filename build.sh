#!/bin/sh

# This script builds: Cocos2d-x-docs, Cocos Creator Manual, Cocos Creator API-Ref.

# First Cocos2d-x docs, we are aready in this repo when executing this script
## pull latest from github
git pull origin master

## build it
gitbook build

## copy everything to deployment directory
cd _build
cp en/ gitbook/ package.json search_plus_index.json zh/ ../../documentation
cd ..

## Api-ref, we only have this as a .tar.gz file.
cp ../api-refs-static-pages.tar.gz .
tar xvf api-refs-static-pages.tar.gz
rm -rf api-refs-static-pages.tar.gz




# ensure index.html redirect
