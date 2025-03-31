#!/bin/bash

set -e

echo "Building site..."

ghc --make site.hs
./site clean
./site build

echo "storing files in temporary directory..."
mkdir -p _deploy

echo "storing build in temporary directory..."
cp -R _site/* _deploy/

echo "preparing for deployment"
git checkout -B gh-pages

git rm -rf

echo "adding files to git"
git add .

echo "commiting changes.."
git commit -m "Deploy site $(date)"

echo "pushing.."
git push -f origin gh-pages

echo "checkout main..."
git checkout main

echo "complete! ok"
