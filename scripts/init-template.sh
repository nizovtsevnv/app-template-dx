#!/bin/sh

# Template initialization script
# This script helps initialize a new project from the template

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Template variables
TEMPLATE_NAME="app-template-dx"
TEMPLATE_AUTHOR="Nick Nizovtsev"
TEMPLATE_EMAIL=""

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

check_dependencies() {
    print_info "Checking dependencies..."

    local missing_deps=()

    if ! command -v cargo &> /dev/null; then
        missing_deps+=("cargo")
    fi

    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi

    if [ ${#missing_deps[@]} -ne 0 ]; then
        dep_list=$(printf "%s " "${missing_deps[@]}")
        print_error "Missing dependencies: $dep_list"
        print_info "Please install the missing dependencies and try again."
        exit 1
    fi

    print_success "All dependencies found"
}

get_user_input() {
    print_info "Enter project information:"

    # Project name
    while true; do
        read -p "Project name (kebab-case, e.g., my-awesome-app): " PROJECT_NAME
        case "$PROJECT_NAME" in
            *[A-Z]*|*_*|*.*)
                print_warning "Project name must be in kebab-case (lowercase, hyphens only)"
                continue
                ;;
            -*|*-)
                print_warning "Project name cannot start or end with a hyphen"
                continue
                ;;
            "")
                print_warning "Project name cannot be empty"
                continue
                ;;
            *)
                if echo "$PROJECT_NAME" | grep -q '^[a-z][a-z0-9]*\(-[a-z0-9]\+\)*$'; then
                    break
                else
                    print_warning "Project name must be in kebab-case (lowercase, hyphens only)"
                fi
                ;;
        esac
    done

    # Project description (optional)
    read -p "Project description (optional): " PROJECT_DESCRIPTION

    # Author name (optional)
    read -p "Author name (optional): " AUTHOR_NAME

    # Author email (optional)
    read -p "Author email (optional): " AUTHOR_EMAIL

    # Git repository URL (optional)
    read -p "Git repository URL (optional): " GIT_REPO_URL

    # Git initialization confirmation
    read -p "Initialize git repository and make initial commit? (Y/n): " INIT_GIT
    case "$INIT_GIT" in
        [Nn]*) INIT_GIT="no" ;;
        *) INIT_GIT="yes" ;;
    esac

    print_info "Project configuration:"
    print_info "  Name: $PROJECT_NAME"
    if [ -n "$PROJECT_DESCRIPTION" ]; then
        print_info "  Description: $PROJECT_DESCRIPTION"
    fi
    if [ -n "$AUTHOR_NAME" ]; then
        if [ -n "$AUTHOR_EMAIL" ]; then
            print_info "  Author: $AUTHOR_NAME <$AUTHOR_EMAIL>"
        else
            print_info "  Author: $AUTHOR_NAME"
        fi
    fi
    if [ -n "$GIT_REPO_URL" ]; then
        print_info "  Repository: $GIT_REPO_URL"
    fi
    print_info "  Initialize git: $INIT_GIT"

    read -p "Continue? (y/N): " CONFIRM
    case "$CONFIRM" in
        [Yy]*) ;;
        *)
            print_info "Aborted by user"
            exit 0
            ;;
    esac
}

update_files() {
    print_info "Updating project files..."

    # Update Cargo.toml
    sed -i.bak "s/$TEMPLATE_NAME/$PROJECT_NAME/g" Cargo.toml
    if [ -n "$AUTHOR_NAME" ]; then
        if [ -n "$AUTHOR_EMAIL" ]; then
            # Replace with name and email
            sed -i.bak "s/$TEMPLATE_AUTHOR/$AUTHOR_NAME <$AUTHOR_EMAIL>/g" Cargo.toml
        else
            # Replace with just name
            sed -i.bak "s/$TEMPLATE_AUTHOR/$AUTHOR_NAME/g" Cargo.toml
        fi
    else
        # Remove entire authors line if no author provided
        sed -i.bak '/^authors = /d' Cargo.toml
    fi

    # Update apps/web/Cargo.toml
    sed -i.bak "s/name = \"web\"/name = \"$PROJECT_NAME\"/g" apps/web/Cargo.toml

    # Update apps/web/Dioxus.toml
    sed -i.bak "s/name = \"web\"/name = \"$PROJECT_NAME\"/g" apps/web/Dioxus.toml
    if [ -n "$PROJECT_DESCRIPTION" ]; then
        sed -i.bak "s/title = \"App Template DX\"/title = \"$PROJECT_DESCRIPTION\"/g" apps/web/Dioxus.toml
    else
        sed -i.bak "s/title = \"App Template DX\"/title = \"$PROJECT_NAME\"/g" apps/web/Dioxus.toml
    fi

    # Update README.md
    if [ -n "$PROJECT_DESCRIPTION" ]; then
        PROJECT_TITLE="$PROJECT_DESCRIPTION"
    else
        PROJECT_TITLE="$PROJECT_NAME"
    fi

    cat > README.md << EOF
# $PROJECT_NAME

$PROJECT_TITLE

## Quick Start

### Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled

### Development

1. **Enter development environment:**
   \`\`\`bash
   nix develop
   \`\`\`

2. **Build the workspace:**
   \`\`\`bash
   cargo build --workspace
   \`\`\`

3. **Run the web application:**
   \`\`\`bash
   cd apps/web && dx serve --hot-reload
   \`\`\`

4. **Run tests:**
   \`\`\`bash
   cargo test --workspace
   \`\`\`

## Development Commands

\`\`\`bash
# Development server with hot reload
make dev

# Build for production
make deploy-build

# Run all tests
make test

# Format code
make fmt

# Lint code
make lint

# Generate documentation
make docs
\`\`\`

## Deployment

\`\`\`bash
# Build static files for deployment
make deploy-build

# Deploy apps/web/dist/ to any static hosting
\`\`\`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
EOF

    # Update LICENSE
    if [ -n "$AUTHOR_NAME" ]; then
        sed -i.bak "s/Copyright (c) 2025 $TEMPLATE_AUTHOR/Copyright (c) $(date +%Y) $AUTHOR_NAME/g" LICENSE
    else
        # Remove author from LICENSE if not provided
        sed -i.bak "s/Copyright (c) 2025 $TEMPLATE_AUTHOR/Copyright (c) $(date +%Y)/g" LICENSE
    fi

    # Update .env.example
    sed -i.bak "s/APP_NAME=$TEMPLATE_NAME/APP_NAME=$PROJECT_NAME/g" .env.example

    # Remove backup files
    find . -name "*.bak" -delete

    print_success "Files updated successfully"
}

setup_git() {
    # Remove existing git repository if it exists
    if [ -d .git ]; then
        print_info "Removing existing git repository..."
        rm -rf .git
    fi

    print_info "Initializing new git repository..."

    git init
    git add .
    # Build commit message
    COMMIT_MSG="Initial commit from template\n\nGenerated from $TEMPLATE_NAME template"
    if [ -n "$PROJECT_DESCRIPTION" ]; then
        COMMIT_MSG="$COMMIT_MSG\n\nDescription: $PROJECT_DESCRIPTION"
    fi

    printf "$COMMIT_MSG" | git commit -F -

    if [ -n "$GIT_REPO_URL" ]; then
        git remote add origin "$GIT_REPO_URL"
        print_info "Added remote origin: $GIT_REPO_URL"
        print_info "Push to remote with: git push -u origin main"
    fi

    print_success "Git repository initialized"
}

setup_pre_commit() {
    if command -v pre-commit &> /dev/null; then
        print_info "Installing pre-commit hooks..."
        pre-commit install
        print_success "Pre-commit hooks installed"
    else
        print_warning "pre-commit not found, skipping hook installation"
        print_info "Install pre-commit and run 'pre-commit install' to enable hooks"
    fi
}

verify_setup() {
    print_info "Verifying project setup..."

    # Check if project builds
    if cargo check --workspace; then
        print_success "Project builds successfully"
    else
        print_error "Project build failed"
        exit 1
    fi

    # Check if tests pass
    if cargo test --workspace; then
        print_success "All tests pass"
    else
        print_warning "Some tests failed"
    fi
}

cleanup() {
    print_info "Cleaning up template files..."

    # Remove this script
    rm -f scripts/init-template.sh

    # Remove template-specific files if they exist
    rm -f TEMPLATE.md

    print_success "Cleanup completed"
}

main() {
    print_info "🚀 Initializing project from template..."

    check_dependencies
    get_user_input
    update_files
    if [ "$INIT_GIT" = "yes" ]; then
        setup_git
        setup_pre_commit
    else
        print_info "Skipping git repository initialization"
    fi
    verify_setup
    cleanup

    print_success "🎉 Project initialization completed!"
    print_info "Next steps:"
    print_info "  1. Go to the project folder:"
    print_info "     \$ cd $PROJECT_NAME"
    print_info "  2. Prepare your development environment:"
    print_info "     \$ nix develop"
    print_info "  3. Run the application:"
    print_info "     \$ make dev"
    print_info "     or"
    print_info "     \$ cd apps/web && dx serve --hot-reload"
    print_info ""
    print_info "Happy coding! 🦀"
}

# Check if running from template directory
if [ ! -f "Cargo.toml" ] || [ ! -d "apps/web" ]; then
    print_error "This script must be run from the template root directory"
    exit 1
fi

main "$@"
