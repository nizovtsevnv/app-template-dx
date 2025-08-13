# Development Principles and Methodologies

## Core Principles

### 1. Codebase Volume Minimization
- **DRY (Don't Repeat Yourself)**: Avoiding code duplication
- **YAGNI (You Aren't Gonna Need It)**: Implementing only necessary functionality
- **KISS (Keep It Simple, Stupid)**: Simplicity over complexity

### 2. Efficiency Through Architecture
- Modular structure for reusability
- Clear interfaces between components
- Minimal dependencies

### 3. Code Quality
- **Rust type safety** and memory safety guarantees
- **Automated quality assurance** with pre-commit hooks
- **Documentation** of all public APIs with examples
- **Consistent coding style** enforced through tooling

## Development Methodologies

### Feature-Driven Development
1. **Planning**: Define functionality requirements
2. **Design**: Architectural solution within existing structure
3. **Implementation**: Iterative development with testing
4. **Integration**: Inclusion into common codebase

### Code Review Process
- Verification of architectural principle compliance
- Test coverage validation
- Code convention adherence
- Performance and security review

### Refactoring
- Regular architecture review
- Extraction of common patterns into shared crates
- Dependency optimization
- Simplification of complex components

## Workflow

### 1. Environment Setup

**With Nix (Recommended):**
```bash
# Enter Nix development environment (auto-installs pre-commit hooks)
nix develop

# Verify environment
cargo --version
rustc --version
pre-commit --version

# Start development server
make dev
```

**Without Nix:**
```bash
# Install WASM target and tools
make install-deps

# Verify environment
cargo --version
rustup target list --installed | grep wasm32

# Start development server
make dev
```

### 2. New Feature Development
```bash
# Create feature branch
git checkout -b feature/new-component

# Development with hot reload
make dev  # Runs dx serve with hot reload

# Quality checks (automatically run on commit)
make test   # cargo test --workspace
make fmt    # cargo fmt --all
make lint   # cargo clippy --all-targets --workspace

# Manual verification
cargo build --workspace
```

### 3. Adding Dependencies
- Preference for workspace.dependencies
- Minimal feature flags
- Document reasons for addition

### 4. Creating New Crates
- Clear responsibility definition
- Minimal public API
- Comprehensive documentation

## Code Conventions

### File Structure
```rust
// lib.rs or main.rs
//! Module documentation

mod internal_module;
pub mod public_module;

pub use public_module::PublicType;

// Public types and functions
// Private implementations
```

### Documentation
- All public elements must be documented
- Usage examples for complex APIs
- Links to related components

### Error Handling
- Use Result for fallible operations
- Specific error types
- Informative error messages

### Testing
- Unit tests for each function
- Integration tests for public APIs
- Documentation tests for examples

## Development Tools

### Integrated (via Nix)
- **`pre-commit`**: Automatic quality checks on commit
- **`cargo fmt`**: Code formatting (stable features only)
- **`cargo clippy`**: Static analysis with MSRV awareness
- **`cargo test`**: Comprehensive testing (unit, integration, benchmarks)
- **`dx`**: Dioxus CLI for development server with hot reload
- **`cargo-audit`**: Security vulnerability scanning
- **`cargo-deny`**: License and dependency policy enforcement
- **`cargo-outdated`**: Dependency update checking
- **`cargo-edit`**: Dependency management utilities
- **`cargo-watch`**: Automatic rebuilding on file changes

### Make Commands
```bash
make dev         # Start development server with hot reload
make build-web   # Build web application for production
make test        # Run all tests
make fmt         # Format all code
make lint        # Run clippy checks
make audit       # Run security audit
make deny        # Run dependency policy checks
make outdated    # Check for outdated dependencies
make update      # Update dependencies (interactive)
make watch       # Watch for changes and run checks
make docs        # Generate documentation
make deploy-build # Build for deployment
make ci          # Run all CI checks (fmt, lint, test, audit, deny)
```

### Quality Assurance
- **Pre-commit hooks** automatically run on every commit:
  - Code formatting verification
  - Clippy linting with warnings as errors
  - All tests must pass
  - Security vulnerability scanning (cargo-audit)
  - YAML/TOML syntax validation
  - Trailing whitespace and end-of-file fixes

### Security and Dependencies
- **`cargo-audit`**: Scans for known security vulnerabilities in dependencies
- **`cargo-deny`**: Enforces license policies and dependency constraints
- **License policy**: Only allows approved open-source licenses (MIT, Apache-2.0, BSD, etc.)
- **Dependency management**: Tools for keeping dependencies up-to-date and secure

### Development Workflow Helpers
- **`cargo-watch`**: Automatically rebuild and test on file changes
- **`cargo-edit`**: Add, remove, and upgrade dependencies easily
- **Makefile with fallbacks**: Commands work with or without Nix environment

## Performance

### Compilation
- Use workspace for shared dependencies
- Parallel crate building
- Build artifact caching

### Runtime
- Minimal heap allocations
- Efficient algorithms
- Profiling of critical paths
