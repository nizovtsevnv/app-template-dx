# Testing and Debugging

## Testing Strategy

### Testing Levels

#### 1. Unit Tests
- Testing individual functions and methods
- Location: alongside tested code
- Coverage: all public functions

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_user_creation() {
        let user = User {
            id: 1,
            name: "Test".to_string(),
            email: "test@example.com".to_string(),
        };
        assert_eq!(user.id, 1);
    }
}
```

#### 2. Integration Tests
- Testing interactions between crates
- Location: `tests/` directory in each crate
- Coverage: public APIs of crates

```rust
// tests/integration_test.rs
use shared_models::User;
use shared_ui::Button;

#[test]
fn test_ui_with_models() {
    // Testing integration of UI components with models
}
```

#### 3. End-to-End Tests
- Testing complete application workflow
- Tools: playwright, cypress (for web)
- Location: `e2e/` directory in workspace

### Testing Configuration

#### Cargo.toml workspace
```toml
[workspace.dependencies]
tokio-test = "0.4"
mockall = "0.12"
proptest = "1.0"
```

#### Test Utilities
- Creating common test utilities in shared crates
- Mock objects for external dependencies
- Property-based testing for complex logic

## Debugging

### Debugging Tools

#### 1. Logging
```rust
use tracing::{debug, info, warn, error};

#[component]
fn MyComponent() -> Element {
    info!("Rendering MyComponent");
    // ...
}
```

#### 2. Dioxus DevTools
- Browser developer tools for DOM inspection
- Dioxus-specific extensions
- State inspection through React DevTools

#### 3. Rust Debugging
```bash
# Debug build with symbols
cargo build

# GDB debugging
rust-gdb target/debug/app

# LLDB debugging
rust-lldb target/debug/app
```

### Profiling

#### Performance Profiling
```bash
# CPU profiling
cargo install flamegraph
cargo flamegraph --bin app

# Memory profiling
cargo install cargo-profdata
cargo profdata -- --bin app
```

#### Bundle Analysis (for web)
```bash
# Bundle size analysis
wasm-pack build --target web
du -h pkg/

# Detailed analysis
twiggy top pkg/app_bg.wasm
```

## Debugging Strategies

### 1. Compiler as First Line of Defense
- Maximum use of types to prevent errors
- Compiler warnings as errors
- Clippy lints for additional checks

### 2. Step-by-Step Debugging
1. **Problem Isolation**: Identify specific component/function
2. **Replication**: Create minimal reproducing example
3. **Analysis**: Use logging and debugger
4. **Fix**: Apply minimal change
5. **Verification**: Confirm fix with tests

### 3. Debugging Techniques

#### Print Debugging
```rust
dbg!(&variable);
println!("Debug: {:?}", value);
eprintln!("Error context: {}", error);
```

#### Conditional Compilation
```rust
#[cfg(debug_assertions)]
fn debug_only_function() {
    // Code only for debug builds
}
```

#### Test-Driven Debugging
```rust
#[test]
fn reproduce_bug() {
    // Test reproducing the bug
    // Fails first, then gets fixed
}
```

## Continuous Integration

### GitHub Actions Workflow
```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: cachix/install-nix-action@v20
      - run: nix develop --command cargo test --workspace
      - run: nix develop --command cargo clippy --workspace
      - run: nix develop --command cargo fmt --check
```

### Pre-commit Hooks
```bash
# Install pre-commit
nix develop
cargo install pre-commit

# Configuration
echo "cargo test && cargo clippy && cargo fmt --check" > .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

## Quality Metrics

### Code Coverage
```bash
cargo install cargo-tarpaulin
cargo tarpaulin --workspace --out Html
```

### Static Analysis
```bash
# Clippy lints
cargo clippy --workspace -- -D warnings

# Security audit
cargo audit

# Dependency analysis
cargo tree --duplicates
```

### Documentation Coverage
```bash
# Documentation check
cargo doc --workspace --no-deps
```
