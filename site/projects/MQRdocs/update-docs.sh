#!/bin/bash

set -e

echo "Building MkDocs documentation..."
source .venv/bin/activate
cd site/projects/MQRdocs
mkdocs build
mkdir -p ../../../site/static/qtc-docs
cp -r site/* ../../../site/static/qtc-docs/

echo "Building Hakyll site..."
cd ../../../
cabal run rokokot-site build

echo "Documentation and site built successfully!"
echo "Run ./deploy.sh