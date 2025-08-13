# Build and Deployment

## Build System

### Development Environment

#### Nix Flake Setup
```bash
# Enter development shell
nix develop

# Verify tools
cargo --version
rustc --version
```

#### Manual Setup (without Nix)
```bash
# Install Rust 2024 edition
rustup install stable
rustup default stable
rustup component add rust-src rust-analyzer
```

### Build Commands

#### Development Build
```bash
# Build all workspace crates
cargo build --workspace

# Build specific crate
cargo build -p app
cargo build -p shared-ui
cargo build -p shared-models
```

#### Release Build
```bash
# Optimized release build
cargo build --workspace --release

# Profile-guided optimization
cargo build --workspace --release --profile release-lto
```

#### Web Target (for Dioxus app)
```bash
# Install tools
cargo install dioxus-cli wasm-pack

# Development server
dx serve --hot-reload

# Production build
dx build --release
```

### Build Profiles

#### Cargo.toml workspace configuration
```toml
[profile.dev]
debug = true
opt-level = 0
overflow-checks = true

[profile.release]
debug = false
opt-level = 3
lto = true
codegen-units = 1
panic = "abort"

[profile.release-lto]
inherits = "release"
lto = "fat"
```

## Testing Strategy

### Test Execution
```bash
# Run all tests
cargo test --workspace

# Run specific crate tests
cargo test -p shared-models

# Run with coverage
cargo tarpaulin --workspace --out Html
```

### Integration Testing
```bash
# End-to-end tests
cd e2e && npm test

# Browser testing
dx test --chrome --firefox
```

## Code Quality

### Linting and Formatting
```bash
# Format code
cargo fmt --all

# Check formatting
cargo fmt --all --check

# Lint with Clippy
cargo clippy --workspace -- -D warnings

# Security audit
cargo audit
```

### Documentation
```bash
# Generate docs
cargo doc --workspace --no-deps

# Test documentation examples
cargo test --doc --workspace
```

## Deployment

### Web Application

The Dioxus web application compiles to static files (HTML, CSS, JS, WASM) that can be deployed to any static hosting service.

#### Build for Production
```bash
# Using Makefile
make deploy-build

# Or manually
cd apps/web && dx build --release
```

#### Deployment Options
Static files are generated in `apps/web/dist/` and can be deployed to:

- **Static Hosting**: Netlify, Vercel, GitHub Pages
- **CDN**: AWS CloudFront, Cloudflare Pages
- **Object Storage**: AWS S3, Google Cloud Storage
- **Traditional Hosting**: Any web server serving static files

#### Example Deployments
```bash
# Netlify CLI
netlify deploy --prod --dir=apps/web/dist

# Vercel CLI
vercel --prod apps/web/dist

# GitHub Pages (via Actions)
# Files automatically deployed from dist/ directory
```

### CI/CD Pipeline

#### GitHub Actions
```yaml
name: Build and Deploy
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: cachix/install-nix-action@v24
      - name: Run tests
        run: nix develop --command cargo test --workspace

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: cachix/install-nix-action@v24
      - name: Build release
        run: nix develop --command cargo build --workspace --release

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: cachix/install-nix-action@v24
      - name: Build web app
        run: nix develop --command make deploy-build
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./apps/web/dist
```

## Performance Optimization

### Build Performance
```bash
# Parallel builds
export CARGO_BUILD_JOBS=$(nproc)

# Shared target directory
export CARGO_TARGET_DIR=/tmp/cargo-target

# Incremental compilation
export CARGO_INCREMENTAL=1
```

### Runtime Performance
```bash
# Profile-guided optimization
cargo build --release
./target/release/app  # Generate profile data
cargo build --release  # Rebuild with PGO
```

### Bundle Size Optimization
```bash
# Analyze WASM bundle
wasm-pack build --target web
twiggy top pkg/*.wasm

# Strip debug info
wasm-strip pkg/*.wasm

# Optimize with wee_alloc
# Add to Cargo.toml:
# wee_alloc = "0.4"
```

## Environment Configuration

### Development
```bash
# Environment variables
export RUST_LOG=debug
export RUST_BACKTRACE=1

# Development server
dx serve --port 3000 --hot-reload
```

### Production
```bash
# Production environment
export RUST_LOG=info
export RUST_ENV=production

# Serve static files
dx build --release
python -m http.server 8080 -d dist
```

### Monitoring
```bash
# Performance monitoring
cargo install cargo-profdata
cargo profdata -- --bin app

# Memory usage
valgrind --tool=massif ./target/debug/app
```
