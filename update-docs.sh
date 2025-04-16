#!/bin/bash

set -e

echo "Building MkDocs documentation..."
source .venv/bin/activate

# Build MQR documentation
if [ -d "site/projects/MQRdocs" ]; then
  cd site/projects/MQRdocs
  mkdocs build
  mkdir -p ../../../site/static/MQR-docs
  cp -r site/* ../../../site/static/MQR-docs/
  cd ../../../
else
  echo "Warning: MQRdocs directory not found. Skipping MQR documentation build."
fi

echo "Building Hakyll site..."
cabal run rokokot-site build

echo "Documentation and site built successfully!"
echo "Run ./deploy.sh to deploy to GitHub Pages"
