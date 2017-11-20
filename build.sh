#!/bin/sh

# pull latest from github
git pull origin master

# build it
gitbook build

# copy everything to deployment directory
cd _build
cp en/ gitbook/ gitment/ package.json search_plus_index.json sh/ ../../documentation


# Api-ref

# ensure index.html redirect
