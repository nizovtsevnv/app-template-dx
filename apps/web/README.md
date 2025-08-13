# Web Application

Main Dioxus web application demonstrating the template architecture.

## Overview

The web application serves as the primary entry point and demonstrates best practices for building Dioxus applications with the template. It orchestrates UI components from `shared-ui` and manages data using models from `shared-models`, showcasing clean architecture principles.

## Architecture

### Components Structure
```
src/
├── main.rs          # Application entry point
├── app.rs           # Root App component
├── components/      # App-specific components
├── hooks/           # Custom Dioxus hooks
├── pages/           # Page components for routing
└── state/           # Application state management
```

### Dependencies
- **dioxus**: Core framework for reactive, component-based UIs
- **shared-ui**: Reusable UI components library from workspace
- **shared-models**: Common data models and business logic from workspace

### Current Implementation
The current app provides a minimal "Hello, Dioxus!" implementation as a starting point for development.

## Key Features

### Component Composition
The app crate focuses on composing higher-level features from basic components:

```rust
use shared_ui::{Button, Layout};
use shared_models::User;

#[component]
fn UserProfile(user: User) -> Element {
    rsx! {
        Layout {
            h1 { "User Profile" }
            p { "Name: {user.name}" }
            p { "Email: {user.email}" }
            Button {
                text: "Edit Profile",
                onclick: |_| {
                    // Handle edit action
                }
            }
        }
    }
}
```

### State Management
Application-wide state is managed using Dioxus hooks and context:

```rust
use dioxus::prelude::*;
use shared_models::User;

#[derive(Clone)]
struct AppState {
    current_user: Option<User>,
    // Other global state
}

fn use_app_state() -> &AppState {
    use_context::<AppState>()
}
```

### Routing
Page navigation and URL handling:

```rust
use dioxus::prelude::*;
use dioxus_router::prelude::*;

#[derive(Clone, Routable, Debug, PartialEq)]
enum Route {
    #[route("/")]
    Home {},
    #[route("/profile")]
    Profile {},
}
```

## Development

### Running the Application
```bash
# Development server with hot reload (workspace root)
make dev
# or manually: cd apps/web && dx serve --platform web --hot-reload true

# Production build (workspace root)
make build-web
# or manually: cd apps/web && dx build --platform web --release

# Deploy build (workspace root)
make deploy-build
```

### Adding New Features
1. Create components in `src/components/`
2. Import and use shared components from `shared-ui`
3. Use data models from `shared-models`
4. Add routing if needed
5. Update tests

### Testing
```bash
# Run all tests (from workspace root)
make test

# Run app-specific tests
cargo test -p web

# Run with coverage
cargo test -p web --verbose
```

## Configuration

### Build Configuration
Build settings are configured in `Cargo.toml` with workspace dependencies.

### Environment Variables
Application-specific environment variables should be documented here.
See `apps/web/.env.example` for available configuration options.

## Performance Considerations

### Bundle Size
- **Static file generation** for optimal deployment size
- **Selective imports** from shared crates
- **Minimal dependencies** following template principles

### Rendering Performance
- **Component-based architecture** for efficient updates
- **Type-safe props** preventing runtime errors
- **Hot reload** for fast development iteration

## Deployment

The application builds to static files suitable for any hosting platform:

```bash
# Build optimized static files
make deploy-build

# Generated files in apps/web/dist/ ready for:
# - Static hosting (Netlify, Vercel, GitHub Pages)
# - CDN deployment (CloudFront, etc.)
# - Container deployment
```
