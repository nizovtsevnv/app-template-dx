# App Template DX

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Rust Version](https://img.shields.io/badge/rust-2024-blue.svg)](https://www.rust-lang.org)

A production-ready Rust workspace template for building efficient Dioxus web applications with exceptional developer experience.

## Overview

This template provides a minimalist yet comprehensive foundation for building web applications with:
- **Rust 2024 Edition** for latest language features and performance
- **Dioxus Framework** for reactive, component-based web UIs
- **Modular Architecture** with shared components and data models
- **Nix Flakes** for reproducible development environment
- **Automated Quality Assurance** with pre-commit hooks and comprehensive testing
- **Security-First Approach** with dependency auditing and license policy enforcement
- **Developer Experience Tools** for efficient development workflow
- **Template Initialization** for quick project setup

## Architecture

```
app-template-dx/
├── apps/
│   └── web/            # Dioxus web application
├── shared/
│   ├── ui/             # Reusable UI components
│   └── models/         # Data models and business logic
├── docs/               # Comprehensive documentation
├── scripts/            # Development and deployment scripts
└── Cargo.toml          # Workspace configuration
```

## Quick Start

### Using as Template

Initialize a new project from this template:

```bash
# Clone the template
git clone <template-repo-url> my-project
cd my-project

# Initialize your project
./scripts/init-template.sh my-project

# Enter development environment
nix develop
```

### Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- Git (for version control)

**Alternative (without Nix):**
- Rust toolchain with `wasm32-unknown-unknown` target
- Run `make install-deps` to install required tools

### Development

1. **Enter development environment (auto-installs pre-commit hooks):**
   ```bash
   nix develop
   ```

2. **Run the web application with hot reload:**
   ```bash
   make dev
   # Opens at http://localhost:8080 with hot reload enabled
   ```

3. **Run quality checks:**
   ```bash
   make test    # Run all tests
   make fmt     # Format code
   make lint    # Run clippy
   make audit   # Security audit
   make deny    # License and dependency policy checks
   ```

## Documentation

### Project Documentation
- **[Architecture](docs/ARCHITECTURE.md)** - Project structure and design principles
- **[Development](docs/DEVELOPMENT.md)** - Development methodologies and best practices
- **[Testing & Debug](docs/TESTING_DEBUG.md)** - Testing strategies and debugging techniques
- **[Build & Deploy](docs/BUILD.md)** - Build system and deployment guide

### Crate Documentation
- **[Web App](apps/web/README.md)** - Dioxus web application
- **[Shared UI](shared/ui/README.md)** - Reusable UI components library
- **[Shared Models](shared/models/README.md)** - Data models and business logic

## Key Features

### Modular Architecture
- Clean separation between UI, business logic, and application layers
- Reusable components across the application ecosystem
- Minimal dependencies and efficient compilation

### Developer Experience
- **Hot reload development server** with instant feedback
- **Automatic pre-commit hooks** for consistent code quality
- **Comprehensive testing** with unit, integration, and benchmark tests
- **Code formatting and linting** with rustfmt and clippy
- **Security vulnerability scanning** with cargo-audit
- **License and dependency policy** enforcement with cargo-deny
- **Development workflow tools** (cargo-watch, cargo-edit)
- **Type-safe components** with Dioxus props system
- **Nix development environment** for reproducible setup

### Production Ready
- **Optimized build profiles** for development and release
- **Static file generation** deployable to any hosting platform
- **Template initialization script** for quick project setup
- **Security best practices** with no hardcoded secrets
- **Minimal dependencies** following efficiency principles

## Development Commands

### Core Commands
```bash
# Development server with hot reload
make dev

# Build for production
make build-web

# Run all tests
make test

# Format code
make fmt

# Lint code
make lint

# Generate documentation
make docs

# Build for deployment
make deploy-build
```

### Quality Assurance
```bash
# Run pre-commit checks (works with/without Nix)
make pre-commit

# Security audit (requires cargo-audit)
make audit

# License and dependency policy checks (requires cargo-deny)
make deny

# Check for outdated dependencies (requires cargo-outdated)
make outdated

# Run complete CI pipeline
make ci
```

### Development Workflow
```bash
# Watch for changes and rebuild
make watch

# Update dependencies interactively
make update

# Install fallback dependencies (if not using Nix)
make install-deps
```

## Deployment

The project builds to static files that can be deployed to any static hosting:

```bash
# Build for production
make deploy-build

# Files are generated in apps/web/dist/
# Deploy this directory to:
# - Netlify, Vercel, GitHub Pages
# - Any CDN or static hosting service
# - S3 + CloudFront, etc.
```

## Contributing

1. Follow the development principles outlined in [DEVELOPMENT.md](docs/DEVELOPMENT.md)
2. Ensure all tests pass before submitting changes
3. Add documentation for new features
4. Follow the established code formatting and style

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
