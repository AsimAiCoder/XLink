#!/bin/bash
#═══════════════════════════════════════════════════════════
# XLink Deployment Script
# Deploy to GitHub Pages
#═══════════════════════════════════════════════════════════

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 XLink Deployment Script${NC}"
echo "═══════════════════════════════════════"

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    echo -e "${YELLOW}⚠️  Please run this script from the xlink directory${NC}"
    exit 1
fi

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}📦 Initializing git repository...${NC}"
    git init
    git remote add origin https://github.com/AsimAiCoder/xlink.git
fi

# Build/prepare files
echo -e "${BLUE}📋 Preparing files...${NC}"

# Validate HTML
if command -v tidy &> /dev/null; then
    echo -e "${BLUE}✓ Validating HTML...${NC}"
    tidy -q -e index.html || echo -e "${YELLOW}⚠️  HTML validation warnings (non-critical)${NC}"
fi

# Minify CSS (if uglify-css is available)
if command -v uglifycss &> /dev/null; then
    echo -e "${BLUE}✓ Minifying CSS...${NC}"
    uglifycss style.css > style.min.css
    mv style.min.css style.css
fi

# Minify JS (if uglify-js is available)
if command -v uglifyjs &> /dev/null; then
    echo -e "${BLUE}✓ Minifying JavaScript...${NC}"
    uglifyjs script.js -o script.min.js
    mv script.min.js script.js
fi

# Add all files
echo -e "${BLUE}📤 Adding files to git...${NC}"
git add .

# Commit
echo -e "${BLUE}💾 Committing changes...${NC}"
COMMIT_MSG="Deploy: $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MSG" || echo -e "${YELLOW}⚠️  No changes to commit${NC}"

# Push to main branch
echo -e "${BLUE}🚀 Pushing to GitHub...${NC}"
git push origin main

# Deploy to gh-pages
echo -e "${BLUE}📡 Deploying to GitHub Pages...${NC}"
git checkout -b gh-pages 2>/dev/null || git checkout gh-pages
git merge main
git push origin gh-pages
git checkout main

echo ""
echo -e "${GREEN}✅ Deployment complete!${NC}"
echo -e "${GREEN}🌐 Site will be available at: https://asimaicoder.github.io/xlink/${NC}"
echo ""
echo "═══════════════════════════════════════"