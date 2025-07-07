#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE} interactive development start ${NC}"
echo "=================================================="

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

cleanup() {
    echo -e "\n${YELLOW}cleaning up ${NC}"
    if [ ! -z "$HAKYLL_PID" ]; then
        kill $HAKYLL_PID 2>/dev/null || true
    fi
    if [ ! -z "$BROWSERSYNC_PID" ]; then
        kill $BROWSERSYNC_PID 2>/dev/null || true
    fi
    exit 0
}

trap cleanup SIGINT SIGTERM EXIT

echo -e "${BLUE} check dependencies ${NC}"

if ! command_exists cabal; then
    echo -e "${RED}Cabal error. ${NC}"
    exit 1
fi

echo -e "${GREEN} cabal ok${NC}"

if command_exists npm; then
    echo -e "${GREEN} Node.js found${NC}"
    
    if ! command_exists browser-sync; then
        echo -e "${YELLOW} browser-sync not found.${NC}"
        echo -e "install it for enhanced live reloading? (y/n)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}install browser-sync...${NC}"
            npm install -g browser-sync || {
                echo -e "${YELLOW}global install failed. attempt local install...${NC}"
                npm install browser-sync --save-dev
            }
        fi
    else
        echo -e "${GREEN}browser-sync found${NC}"
    fi
else
    echo -e "${YELLOW}Node.js not found ${NC}"
fi

# Create package.json if it doesn't exist (for local npm packages)
if [[ ! -f "package.json" ]] && command_exists npm; then
    echo -e "${BLUE} create package.json...${NC}"
    cat > package.json << 'EOF'
{
  "name": "rokokot-website-dev",
  "version": "0.0.1",
  "description": "dev env for personal portfolio website",
  "scripts": {
    "dev": "concurrently \"npm run hakyll\" \"npm run browser-sync\"",
    "hakyll": "cabal run rokokot-site watch",
    "browser-sync": "browser-sync start --proxy localhost:8000 --files '_site/**/*' --port 3000 --no-open",
    "build": "cabal run rokokot-site build",
    "clean": "cabal run rokokot-site clean"
  },
  "devDependencies": {
    "browser-sync": "^2.27.0",
    "concurrently": "^7.0.0"
  }
}
EOF
fi

echo -e "${BLUE} build rokokot.github.io...${NC}"
cabal build || {
    echo -e "${RED}check Hakyll config${NC}"
    exit 1
}

echo -e "${BLUE} clean build...${NC}"
cabal run rokokot-site clean
cabal run rokokot-site build

echo -e "${BLUE}start watch mode...${NC}"
cabal run rokokot-site watch &
HAKYLL_PID=$!

echo -e "${YELLOW} start up hakyll ... ${NC}"
sleep 5

if ! curl -s http://localhost:8000 > /dev/null; then
    echo -e "${RED} hakyll failed at port 8000${NC}"
    exit 1
fi

echo -e "${GREEN} running on http://localhost:8000${NC}"

if command_exists browser-sync; then
    echo -e "${BLUE} browser-sync live edit ${NC}"
    
    browser-sync start \
        --proxy "localhost:8000" \
        --files "_site/**/*.css, _site/**/*.html, _site/**/*.js" \
        --port 3000 \
        --no-notify \
        --no-open &
    BROWSERSYNC_PID=$!
    
    sleep 3
    
    echo ""
    echo -e "${GREEN} Dev env ready ${NC}"
    echo "=================================="
    echo ""
    echo -e "${BLUE}direct access help: ${NC}"
    echo -e "   🔗 Main: ${YELLOW}http://localhost:3000${NC} (with live reload)"
    echo -e "   🔗 Direct:    ${YELLOW}http://localhost:8000${NC} (Hakyll server)"
    echo ""
    echo "   1. Open http://localhost:3000 in your browser"
    echo "   2. Right-click any element → 'Inspect Element'"
    echo "   3. Edit CSS in dev tools to see instant changes"
    echo "   4. Copy working changes to site/css/main.css or site/css/academic.css"
    echo "   5. Save the file - Hakyll will rebuild and browser will refresh"
    echo ""

    echo "   - Use dev tools for rapid experimentation"
    echo "   - Changes to CSS files trigger automatic rebuild + refresh"
    echo "   - Template changes require manual refresh"
    echo "   - Press Ctrl+C to stop the development server"
    
else
    echo ""
    echo -e "${GREEN} development environment ready!${NC}"
    echo "=========================================="
    echo ""
    echo -e "${BLUE} Access site:${NC}"
    echo -e "   ${YELLOW}http://localhost:8000${NC}"
    echo ""
    echo -e "${BLUE}Basic styling workflow:${NC}"
    echo "   1. Open http://localhost:8000 in your browser"
    echo "   2. Right-click any element → 'Inspect Element'"
    echo "   3. Edit CSS in dev tools to see instant changes"
    echo "   4. Copy working changes to site/css/main.css or site/css/academic.css"
    echo "   5. Save the file - Hakyll will rebuild (refresh browser manually)"
    echo ""
    echo -e "${YELLOW}For enhanced experience:${NC}"
    echo "   Install Node.js and browser-sync for automatic refresh"
    echo "   npm install -g browser-sync"
    echo ""
    echo -e "${BLUE}Manual refresh needed after file changes${NC}"
    echo -e "${BLUE}Press Ctrl+C to stop the development server${NC}"
fi

# file locations
echo ""
echo -e "${BLUE}style files:${NC}"
echo "   Main styles: site/css/main.css"
echo "   personal theme: site/css/academic.css"
echo "   Layout template: site/templates/default.html"
echo "   Home page: site/index.md (or site/index.html)"

echo ""
echo -e "${BLUE} Real-time development log:${NC}"
echo "================================"

if command_exists inotifywait; then
    # unix file monitoring
    inotifywait -m -r --format '%w%f %e' site/ 2>/dev/null | while read file event; do
        if [[ $file == *.css ]] || [[ $file == *.md ]] || [[ $file == *.html ]]; then
            echo -e "${GREEN}change: $file${NC}"
        fi
    done &
elif command_exists fswatch; then
    # macOS
    fswatch -o site/ | while read; do
        echo -e "${GREEN} files changed in site/ directory${NC}"
    done &
fi

# Wait for user interruption
echo -e "${YELLOW}Press Ctrl+C to stop the dev ${NC}"
wait