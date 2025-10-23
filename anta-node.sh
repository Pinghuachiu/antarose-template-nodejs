#!/usr/bin/env bash

#===============================================================================
# Antarose Node.js Template Initializer (Advanced Version)
#===============================================================================
# Description: Advanced template initialization script for creating new
#              Node.js projects from the Antarose template
# Version: 1.0.0
# Author: Antarose AI Tech Inc.
# Repository: https://github.com/Pinghuachiu/antarose-template-nodejs
#===============================================================================

set -euo pipefail

#===============================================================================
# Constants
#===============================================================================
readonly TEMPLATE_REPO="https://github.com/Pinghuachiu/antarose-template-nodejs.git"
readonly SCRIPT_VERSION="1.0.0"
readonly DEFAULT_AUTHOR="jackalchiu@antarose.com"
readonly DEFAULT_DESCRIPTION="A Node.js project built with Antarose Template"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color
readonly BOLD='\033[1m'

#===============================================================================
# Global Variables
#===============================================================================
PROJECT_NAME=""
PROJECT_DIR=""
TEMP_DIR=""

#===============================================================================
# Helper Functions
#===============================================================================

# Print functions
print_header() {
    echo -e "${CYAN}${BOLD}"
    echo "🚀 Antarose Node.js Template Initializer (v${SCRIPT_VERSION})"
    echo "========================================================"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1" >&2
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_step() {
    echo -e "\n${BOLD}$1${NC}"
}

# Cleanup function for error handling
cleanup() {
    if [[ -n "${TEMP_DIR:-}" && -d "${TEMP_DIR}" ]]; then
        print_warning "Cleaning up temporary files..."
        rm -rf "${TEMP_DIR}"
    fi

    if [[ -n "${PROJECT_DIR:-}" && -d "${PROJECT_DIR}" && "${1:-}" == "error" ]]; then
        print_warning "Removing incomplete project directory..."
        rm -rf "${PROJECT_DIR}"
    fi
}

# Trap errors and interrupts
trap 'cleanup error; print_error "Installation failed!"; exit 1' ERR
trap 'cleanup error; print_warning "Installation cancelled by user."; exit 130' INT TERM

#===============================================================================
# Validation Functions
#===============================================================================

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate project name (npm package naming rules)
validate_project_name() {
    local name="$1"

    # Check if empty
    if [[ -z "$name" ]]; then
        return 1
    fi

    # Check length (npm allows 1-214 characters)
    if [[ ${#name} -gt 214 ]]; then
        print_error "Project name is too long (max 214 characters)"
        return 1
    fi

    # Check for valid characters (lowercase letters, digits, hyphens, underscores)
    if ! [[ "$name" =~ ^[a-z0-9_-]+$ ]]; then
        print_error "Project name must contain only lowercase letters, digits, hyphens, and underscores"
        print_info "Invalid characters found. Please use: a-z, 0-9, -, _"
        return 1
    fi

    # Check if starts with . or _
    if [[ "$name" =~ ^\.|^_ ]]; then
        print_error "Project name cannot start with . or _"
        return 1
    fi

    return 0
}

# Check prerequisites
check_prerequisites() {
    print_step "📋 Checking prerequisites..."

    local has_errors=0

    # Check Git
    if command_exists git; then
        local git_version=$(git --version | awk '{print $3}')
        print_success "Git installed (${git_version})"
    else
        print_error "Git is not installed"
        print_info "Install from: https://git-scm.com/downloads"
        has_errors=1
    fi

    # Check Node.js
    if command_exists node; then
        local node_version=$(node --version)
        print_success "Node.js installed (${node_version})"
    else
        print_error "Node.js is not installed"
        print_info "Install from: https://nodejs.org/"
        has_errors=1
    fi

    # Check npm
    if command_exists npm; then
        local npm_version=$(npm --version)
        print_success "npm installed (${npm_version})"
    else
        print_error "npm is not installed"
        print_info "npm usually comes with Node.js"
        has_errors=1
    fi

    if [[ $has_errors -eq 1 ]]; then
        print_error "Please install missing prerequisites and try again."
        exit 1
    fi
}

#===============================================================================
# Project Setup Functions
#===============================================================================

# Clone template repository
clone_template() {
    print_step "📦 Cloning template repository..."

    TEMP_DIR=$(mktemp -d)

    if ! git clone --quiet "${TEMPLATE_REPO}" "${TEMP_DIR}" 2>/dev/null; then
        print_error "Failed to clone template repository"
        print_info "Repository: ${TEMPLATE_REPO}"
        exit 1
    fi

    print_success "Template cloned successfully"
}

# Setup project directory
setup_project_directory() {
    print_step "🎯 Setting up project: ${PROJECT_NAME}"

    # Check if directory already exists
    if [[ -d "${PROJECT_NAME}" ]]; then
        echo -n "Directory '${PROJECT_NAME}' already exists. Overwrite? (y/N): "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_warning "Installation cancelled."
            cleanup success
            exit 0
        fi
        rm -rf "${PROJECT_NAME}"
    fi

    # Move temp directory to project directory
    mv "${TEMP_DIR}" "${PROJECT_NAME}"
    PROJECT_DIR="${PROJECT_NAME}"
    TEMP_DIR=""

    cd "${PROJECT_DIR}"

    # Remove .git directory
    rm -rf .git
    print_success "Removed template Git history"

    # Remove docs/specs directory
    if [[ -d "docs/specs" ]]; then
        rm -rf docs/specs
        print_success "Removed OpenSpec documentation (docs/specs)"
    fi

    # Remove the script itself
    if [[ -f "anta-node.sh" ]]; then
        rm -f anta-node.sh
        print_success "Removed initialization script"
    fi

    print_success "Kept architecture documentation (docs/architecture)"
}

# Get user input with default value
prompt_with_default() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"

    echo -n "${prompt} (${default}): "
    read -r input

    if [[ -z "$input" ]]; then
        eval "${var_name}='${default}'"
    else
        eval "${var_name}='${input}'"
    fi
}

# Interactive configuration
interactive_config() {
    print_step "⚙️  Project Configuration"

    local description author repo_url install_deps

    # Project description
    prompt_with_default "? Project description" "${DEFAULT_DESCRIPTION}" description

    # Author
    prompt_with_default "? Author" "${DEFAULT_AUTHOR}" author

    # GitHub repository URL (optional)
    echo -n "? GitHub repository URL (leave empty to skip): "
    read -r repo_url

    # Install dependencies
    echo -n "? Install dependencies now? (Y/n): "
    read -r install_deps
    if [[ -z "$install_deps" || "$install_deps" =~ ^[Yy]$ ]]; then
        install_deps="yes"
    else
        install_deps="no"
    fi

    # Export variables for use in other functions
    export CONFIG_DESCRIPTION="$description"
    export CONFIG_AUTHOR="$author"
    export CONFIG_REPO_URL="$repo_url"
    export CONFIG_INSTALL_DEPS="$install_deps"
}

# Update package.json files
update_package_json() {
    print_step "🔧 Updating project configuration..."

    local pkg_name="${PROJECT_NAME}"

    # Update frontend/package.json
    if [[ -f "frontend/package.json" ]]; then
        # Use Node.js to update JSON (more reliable than sed)
        node -e "
            const fs = require('fs');
            const pkg = JSON.parse(fs.readFileSync('frontend/package.json', 'utf8'));
            pkg.name = '${pkg_name}-frontend';
            pkg.version = '1.0.0';
            pkg.description = '${CONFIG_DESCRIPTION}';
            pkg.author = '${CONFIG_AUTHOR}';
            fs.writeFileSync('frontend/package.json', JSON.stringify(pkg, null, 2) + '\n');
        "
        print_success "Updated frontend/package.json"
    fi

    # Update backend/package.json
    if [[ -f "backend/package.json" ]]; then
        node -e "
            const fs = require('fs');
            const pkg = JSON.parse(fs.readFileSync('backend/package.json', 'utf8'));
            pkg.name = '${pkg_name}-backend';
            pkg.version = '1.0.0';
            pkg.description = '${CONFIG_DESCRIPTION}';
            pkg.author = '${CONFIG_AUTHOR}';
            fs.writeFileSync('backend/package.json', JSON.stringify(pkg, null, 2) + '\n');
        "
        print_success "Updated backend/package.json"
    fi

    # Update README.md title
    if [[ -f "README.md" ]]; then
        # Replace the first heading with the project name
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS version
            sed -i '' "1s/.*/# ${PROJECT_NAME}/" README.md
        else
            # Linux version
            sed -i "1s/.*/# ${PROJECT_NAME}/" README.md
        fi
        print_success "Updated README.md"
    fi
}

# Install dependencies
install_dependencies() {
    if [[ "${CONFIG_INSTALL_DEPS}" != "yes" ]]; then
        print_info "Skipping dependency installation (you can run 'npm install' later)"
        return
    fi

    print_step "📦 Installing dependencies..."

    # Install frontend dependencies
    if [[ -d "frontend" && -f "frontend/package.json" ]]; then
        print_info "Installing frontend dependencies..."
        if (cd frontend && npm install --silent 2>&1 | grep -v "^npm WARN" || true); then
            print_success "Frontend dependencies installed"
        else
            print_warning "Frontend dependency installation encountered issues (non-critical)"
        fi
    fi

    # Install backend dependencies
    if [[ -d "backend" && -f "backend/package.json" ]]; then
        print_info "Installing backend dependencies..."
        if (cd backend && npm install --silent 2>&1 | grep -v "^npm WARN" || true); then
            print_success "Backend dependencies installed"
        else
            print_warning "Backend dependency installation encountered issues (non-critical)"
        fi
    fi
}

# Initialize Git repository
init_git_repo() {
    print_step "🎉 Initializing Git repository..."

    git init --quiet
    print_success "Git repository initialized"

    # Set remote if provided
    if [[ -n "${CONFIG_REPO_URL}" ]]; then
        git remote add origin "${CONFIG_REPO_URL}"
        print_success "Git remote 'origin' set to: ${CONFIG_REPO_URL}"
    fi

    # Create initial commit
    git add .
    git commit --quiet -m "chore: initialize project from antarose-template-nodejs

- Project: ${PROJECT_NAME}
- Description: ${CONFIG_DESCRIPTION}
- Author: ${CONFIG_AUTHOR}

🤖 Generated with Antarose Template Initializer v${SCRIPT_VERSION}"

    print_success "Initial commit created"
}

# Print next steps
print_next_steps() {
    print_step "✅ Project '${PROJECT_NAME}' created successfully!"

    echo -e "\n${BOLD}Next steps:${NC}"
    echo -e "  ${CYAN}cd ${PROJECT_NAME}${NC}"
    echo ""
    echo -e "${BOLD}Start development servers:${NC}"
    echo -e "  ${CYAN}# Terminal 1 - Frontend (http://localhost:3000)${NC}"
    echo -e "  ${CYAN}cd frontend && npm run dev${NC}"
    echo ""
    echo -e "  ${CYAN}# Terminal 2 - Backend (http://localhost:4000)${NC}"
    echo -e "  ${CYAN}cd backend && npm run dev${NC}"
    echo ""

    if [[ -n "${CONFIG_REPO_URL}" ]]; then
        echo -e "${BOLD}Push to GitHub:${NC}"
        echo -e "  ${CYAN}git push -u origin main${NC}"
        echo ""
    fi

    echo -e "${BOLD}Documentation:${NC}"
    echo -e "  ${CYAN}docs/architecture/${NC} - Technical documentation"
    echo ""
    echo -e "${GREEN}Happy coding! 🚀${NC}\n"
}

#===============================================================================
# Main Function
#===============================================================================

main() {
    print_header

    # Check if project name is provided
    if [[ $# -eq 0 ]]; then
        print_error "Usage: $0 <project-name>"
        print_info "Example: $0 my-awesome-project"
        exit 1
    fi

    PROJECT_NAME="$1"

    # Validate project name
    if ! validate_project_name "${PROJECT_NAME}"; then
        exit 1
    fi

    # Run setup steps
    check_prerequisites
    clone_template
    setup_project_directory
    interactive_config
    update_package_json
    install_dependencies
    init_git_repo

    # Cleanup (success)
    cleanup success

    # Print completion message
    print_next_steps
}

#===============================================================================
# Script Entry Point
#===============================================================================

main "$@"
