#!/bin/sh

# pull latest from github
git pull origin master

# build it
gitbook build

# copy everything to deployment directory
cd _build
cp en/ gitbook/ package.json search_plus_index.json zh/ ../../documentation
cd ..

# Api-ref

# ensure index.html redirect
