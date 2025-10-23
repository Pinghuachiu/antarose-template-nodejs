#!/bin/bash

##############################################################################
# Antarose Node.js Template Bootstrapper
#
# Description: Downloads and initializes a new project from the template
# Usage: ./anta-node.sh <project-name>
# Author: Antarose AI Tech Inc.
# Repository: https://github.com/Pinghuachiu/antarose-template-nodejs
##############################################################################

set -e  # Exit immediately if a command exits with a non-zero status

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Template repository
TEMPLATE_REPO="https://github.com/Pinghuachiu/antarose-template-nodejs.git"

# Default values
DEFAULT_AUTHOR="jackalchiu@antarose.com"

##############################################################################
# Helper Functions
##############################################################################

print_header() {
  echo ""
  echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║                                                            ║${NC}"
  echo -e "${CYAN}║     ${GREEN}Antarose Node.js Template Bootstrapper${CYAN}             ║${NC}"
  echo -e "${CYAN}║                                                            ║${NC}"
  echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
  echo ""
}

print_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
  echo -e "${RED}❌ $1${NC}"
}

print_step() {
  echo ""
  echo -e "${CYAN}▶ $1${NC}"
}

##############################################################################
# Main Script
##############################################################################

print_header

# Validate project name argument
if [ -z "$1" ]; then
  print_error "Project name is required"
  echo ""
  echo "Usage: ./anta-node.sh <project-name>"
  echo ""
  echo "Example:"
  echo "  ./anta-node.sh my-awesome-project"
  echo ""
  exit 1
fi

PROJECT_NAME=$1

# Validate project name format (alphanumeric, hyphens, underscores)
if [[ ! $PROJECT_NAME =~ ^[a-zA-Z0-9_-]+$ ]]; then
  print_error "Invalid project name. Use only letters, numbers, hyphens, and underscores."
  exit 1
fi

# Check if directory already exists
if [ -d "$PROJECT_NAME" ]; then
  print_error "Directory '$PROJECT_NAME' already exists in current location"
  echo ""
  echo "Please choose a different name or remove the existing directory:"
  echo "  rm -rf $PROJECT_NAME"
  echo ""
  exit 1
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
  print_error "Git is not installed. Please install Git first."
  exit 1
fi

# Check internet connection by testing GitHub
if ! curl -s --head --max-time 5 https://github.com &> /dev/null; then
  print_error "Cannot connect to GitHub. Please check your internet connection."
  exit 1
fi

print_info "Creating project: ${GREEN}$PROJECT_NAME${NC}"
print_info "Template: $TEMPLATE_REPO"
echo ""

##############################################################################
# Step 1: Clone Template Repository
##############################################################################

print_step "Step 1/8: Downloading template from GitHub..."

if git clone --quiet "$TEMPLATE_REPO" "$PROJECT_NAME"; then
  print_success "Template downloaded successfully"
else
  print_error "Failed to clone template repository"
  exit 1
fi

cd "$PROJECT_NAME"

##############################################################################
# Step 2: Remove Template Git History
##############################################################################

print_step "Step 2/8: Removing template git history..."

rm -rf .git
print_success "Template git history removed"

##############################################################################
# Step 3: Clean Up Unnecessary Files
##############################################################################

print_step "Step 3/8: Cleaning up unnecessary files..."

# Remove OpenSpec proposal files (users don't need these)
if [ -d "docs/specs" ]; then
  rm -rf docs/specs
  print_success "Removed docs/specs/ (OpenSpec proposals)"
fi

# Keep docs/architecture/ for reference
print_info "Keeping docs/architecture/ for reference"

# Remove bootstrap script itself
if [ -f "anta-node.sh" ]; then
  rm -f anta-node.sh
  print_success "Removed bootstrap script"
fi

##############################################################################
# Step 4: Interactive Project Configuration
##############################################################################

print_step "Step 4/8: Project configuration (interactive)"

# Project description
echo ""
echo -e "${YELLOW}Enter project description (or press Enter to skip):${NC}"
read -r PROJECT_DESCRIPTION

# Author name
echo ""
echo -e "${YELLOW}Enter author name (default: Antarose):${NC}"
read -r AUTHOR_NAME
AUTHOR_NAME=${AUTHOR_NAME:-"Antarose"}

# Author email
echo ""
echo -e "${YELLOW}Enter author email (default: $DEFAULT_AUTHOR):${NC}"
read -r AUTHOR_EMAIL
AUTHOR_EMAIL=${AUTHOR_EMAIL:-"$DEFAULT_AUTHOR"}

# Update package.json files with project info
print_info "Updating package.json files..."

# Update backend/package.json
if [ -f "backend/package.json" ]; then
  BACKEND_PKG=$(cat backend/package.json)
  BACKEND_PKG=$(echo "$BACKEND_PKG" | sed "s/\"name\": \"backend\"/\"name\": \"$PROJECT_NAME-backend\"/")
  if [ -n "$PROJECT_DESCRIPTION" ]; then
    BACKEND_PKG=$(echo "$BACKEND_PKG" | sed "s/\"description\": \"\"/\"description\": \"$PROJECT_DESCRIPTION - Backend API\"/")
  fi
  BACKEND_PKG=$(echo "$BACKEND_PKG" | sed "s/\"author\": \"\"/\"author\": \"$AUTHOR_NAME <$AUTHOR_EMAIL>\"/")
  echo "$BACKEND_PKG" > backend/package.json
fi

# Update frontend/package.json
if [ -f "frontend/package.json" ]; then
  FRONTEND_PKG=$(cat frontend/package.json)
  FRONTEND_PKG=$(echo "$FRONTEND_PKG" | sed "s/\"name\": \"frontend\"/\"name\": \"$PROJECT_NAME-frontend\"/")
  echo "$FRONTEND_PKG" > frontend/package.json
fi

print_success "Package.json files updated"

##############################################################################
# Step 5: Initialize New Git Repository
##############################################################################

print_step "Step 5/8: Initializing new git repository..."

git init --quiet

# Configure git user (if not already configured globally)
if [ -z "$(git config user.email)" ]; then
  git config user.email "$AUTHOR_EMAIL"
  git config user.name "$AUTHOR_NAME"
  print_info "Git user configured: $AUTHOR_NAME <$AUTHOR_EMAIL>"
fi

git add .
git commit --quiet -m "chore: initialize project from antarose-template-nodejs

Project: $PROJECT_NAME
Template: https://github.com/Pinghuachiu/antarose-template-nodejs
Author: $AUTHOR_NAME <$AUTHOR_EMAIL>
"

print_success "New git repository initialized with initial commit"

##############################################################################
# Step 6: Git Remote Setup (Optional)
##############################################################################

print_step "Step 6/8: Git remote setup (optional)"

echo ""
echo -e "${YELLOW}Set up GitHub remote repository? (y/N):${NC}"
read -r SETUP_REMOTE

if [[ $SETUP_REMOTE =~ ^[Yy]$ ]]; then
  echo ""
  echo -e "${YELLOW}Enter GitHub repository URL (e.g., https://github.com/user/repo.git):${NC}"
  read -r REMOTE_URL

  if [ -n "$REMOTE_URL" ]; then
    git remote add origin "$REMOTE_URL"
    print_success "Git remote 'origin' added: $REMOTE_URL"

    echo ""
    echo -e "${YELLOW}Push to remote now? (y/N):${NC}"
    read -r PUSH_NOW

    if [[ $PUSH_NOW =~ ^[Yy]$ ]]; then
      git branch -M main
      if git push -u origin main; then
        print_success "Pushed to remote repository"
      else
        print_warning "Failed to push. You may need to authenticate or check repository permissions."
      fi
    else
      print_info "You can push later with: git push -u origin main"
    fi
  fi
else
  print_info "Skipped remote setup. You can add it later with:"
  echo "    git remote add origin <repository-url>"
fi

##############################################################################
# Step 7: Install Dependencies
##############################################################################

print_step "Step 7/8: Installing dependencies..."

echo ""
echo -e "${YELLOW}Install dependencies now? This may take a few minutes. (Y/n):${NC}"
read -r INSTALL_DEPS

if [[ ! $INSTALL_DEPS =~ ^[Nn]$ ]]; then
  # Check if npm is installed
  if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install Node.js and npm first."
    exit 1
  fi

  # Install backend dependencies
  print_info "Installing backend dependencies..."
  if (cd backend && npm install --silent); then
    print_success "Backend dependencies installed"
  else
    print_warning "Backend dependency installation failed. You may need to run manually."
  fi

  # Install frontend dependencies
  print_info "Installing frontend dependencies..."
  if (cd frontend && npm install --silent); then
    print_success "Frontend dependencies installed"
  else
    print_warning "Frontend dependency installation failed. You may need to run manually."
  fi
else
  print_info "Skipped dependency installation. Run manually:"
  echo "    cd $PROJECT_NAME/backend && npm install"
  echo "    cd $PROJECT_NAME/frontend && npm install"
fi

##############################################################################
# Step 8: Final Summary
##############################################################################

print_step "Step 8/8: Project setup complete! 🎉"

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}║           ✅ Project Created Successfully! ✅              ║${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}📁 Project Location:${NC}"
echo "   $(pwd)"
echo ""
echo -e "${CYAN}📚 Project Information:${NC}"
echo "   Name:        $PROJECT_NAME"
if [ -n "$PROJECT_DESCRIPTION" ]; then
  echo "   Description: $PROJECT_DESCRIPTION"
fi
echo "   Author:      $AUTHOR_NAME <$AUTHOR_EMAIL>"
echo ""
echo -e "${CYAN}🚀 Next Steps:${NC}"
echo ""
echo "   1. Navigate to project directory:"
echo -e "      ${YELLOW}cd $PROJECT_NAME${NC}"
echo ""
echo "   2. Start development servers:"
echo ""
echo "      ${YELLOW}# Terminal 1 - Backend (http://localhost:4000)${NC}"
echo "      cd backend && npm run dev"
echo ""
echo "      ${YELLOW}# Terminal 2 - Frontend (http://localhost:3000)${NC}"
echo "      cd frontend && npm run dev"
echo ""
echo "   3. Open your browser:"
echo -e "      Frontend: ${BLUE}http://localhost:3000${NC}"
echo -e "      Backend:  ${BLUE}http://localhost:4000/health${NC}"
echo ""
echo -e "${CYAN}📖 Documentation:${NC}"
echo "   - README.md - Project overview"
echo "   - backend/README.md - Backend API documentation"
echo "   - docs/architecture/ - Technical architecture docs"
echo ""
echo -e "${CYAN}🎯 Tech Stack:${NC}"
echo "   Frontend: Next.js 15 + React 19 + Tailwind + shadcn/ui"
echo "   Backend:  Express 5 + TypeScript + CORS + Helmet"
echo ""
echo -e "${GREEN}Happy coding! 🎉${NC}"
echo ""
