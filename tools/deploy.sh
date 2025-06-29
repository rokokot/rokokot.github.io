#!/bin/bash

set -e
echo "Building website..."

cabal build
cabal run rokokot-site build

echo "Storing files in temp..."
mkdir -p _deploy
cp -R _site/* _deploy/

echo "Preparing for deployment"
git checkout -B gh-pages

echo "Clearing previous deployment..."
git rm -rf --ignore-unmatch index.html about.html research.html teaching.html publications.html projects.html css images files static

echo "Adding new files to git"
cp -r _deploy/* .
git add .

echo "Committing changes..."
git commit -m "deploy site $(date)"

echo "Pushing to GitHub Pages..."
git push -f origin gh-pages

echo "Checking out main branch..."
git checkout main

echo "Cleaning up temporary files..."
rm -rf _deploy

echo "complete! site is now live."