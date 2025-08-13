# Shared Models Library

Common data structures and business logic shared across the application ecosystem.

## Overview

The `shared-models` crate provides core data structures for the template architecture. Currently featuring a comprehensive `User` model, it demonstrates best practices for building business logic that focuses on:

- **Type Safety**: Leveraging Rust's type system for data integrity
- **Serialization**: JSON support via serde for API integration
- **Validation**: Input validation and business rule enforcement
- **Testing**: Comprehensive unit, integration, and benchmark testing
- **Documentation**: Clear examples and usage patterns

## Architecture

### Current Structure
```
src/
├── lib.rs              # Public API exports
├── user.rs             # User model with validation and tests
├── tests/              # Integration tests
└── benches/            # Performance benchmarks
```

### Testing & Benchmarking
- **Unit tests** within modules for core functionality
- **Integration tests** for serialization and cross-module behavior
- **Benchmarks** using criterion for performance measurement
- **Comprehensive coverage** including error cases and edge conditions

### Design Principles

#### 1. Validation-First Design
The current `User` model demonstrates validation-focused construction:

```rust
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct User {
    pub id: u64,
    pub name: String,
    pub email: String,
}

impl User {
    pub fn new(id: u64, name: String, email: String) -> Result<Self, String> {
        if name.trim().is_empty() {
            return Err("Name cannot be empty".to_string());
        }
        if !email.contains('@') {
            return Err("Invalid email format".to_string());
        }
        Ok(Self { id, name, email })
    }
}
```

#### 2. Comprehensive Testing
Every model includes multiple testing strategies:

- **Unit tests** for validation logic
- **Integration tests** for serialization/deserialization
- **Benchmark tests** for performance measurement
- **Error case testing** for robustness

#### 3. Performance Monitoring
Using criterion benchmarks to track performance:

```rust
// Benchmarks track creation, serialization, and deserialization performance
fn user_creation_benchmark(c: &mut Criterion) { ... }
fn user_serialization_benchmark(c: &mut Criterion) { ... }
fn user_deserialization_benchmark(c: &mut Criterion) { ... }
```

## Current Models

### User Model

The template includes a foundational `User` model demonstrating best practices:

```rust
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct User {
    pub id: u64,
    pub name: String,
    pub email: String,
}

// Usage with validation
let user = User::new(1, "John Doe".to_string(), "john@example.com".to_string())?;

// Serialization support
let json = serde_json::to_string(&user)?;
let deserialized: User = serde_json::from_str(&json)?;
```

## Extension Points

This crate is designed to be extended with additional models as your application grows:

### Adding Models
1. Create new model file in `src/` (e.g., `product.rs`, `order.rs`)
2. Implement validation constructor following the `User::new` pattern
3. Add comprehensive tests (unit, integration, benchmarks)
4. Export from `lib.rs` for public use
5. Document with usage examples

### Future Models
Consider adding models such as:
- Authentication models (Session, Token, Credentials)
- Business domain models (Product, Order, Payment)
- API models (Request/Response wrappers, Pagination)
- Configuration models (Settings, Feature flags)

### Testing Patterns
All models should include:
```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_valid_creation() { ... }

    #[test]
    fn test_validation_failures() { ... }

    #[test]
    fn test_serialization() { ... }
}
```

## Integration with Template

### With UI Components
Models integrate seamlessly with shared-ui components:

```rust
// In shared-ui
use shared_models::User;

#[component]
pub fn UserCard(user: User) -> Element {
    rsx! {
        div {
            h3 { "{user.name}" }
            p { "{user.email}" }
        }
    }
}
```

### With Applications
Models provide type-safe data for applications:

```rust
// In apps/web
use shared_models::User;
use shared_ui::Button;

fn App() -> Element {
    let user = User::new(1, "Demo User".to_string(), "demo@example.com".to_string())
        .expect("Valid user data");

    rsx! {
        UserCard { user }
        Button {
            text: "Edit User",
            onclick: |_| { /* Handle edit */ }
        }
    }
}
```

## Performance Metrics

The template includes comprehensive benchmarking:

```bash
# Run benchmarks
cargo bench -p shared-models

# View benchmark results in target/criterion/
# - User creation performance
# - Serialization/deserialization throughput
# - Memory usage patterns
```
