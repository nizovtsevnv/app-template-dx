# Shared UI Components Library

Reusable Dioxus components for building consistent user interfaces across the application.

## Overview

The `shared-ui` crate provides a foundational UI components library designed for the template architecture. Currently featuring a minimal `Button` component, it demonstrates best practices for building reusable Dioxus components that focus on:

- **Type Safety**: Leveraging Rust's type system for compile-time correctness
- **Composability**: Simple, focused components that combine into complex UIs
- **Template Integration**: Seamless integration with workspace architecture
- **Testing**: Comprehensive testing including compilation and props validation

## Architecture

### Current Structure
```
src/
├── lib.rs              # Public API exports
├── components/         # UI components
│   ├── mod.rs         # Component module declarations
│   └── button.rs      # Button component implementation
└── tests/             # Integration tests for components
```

### Testing Structure
- **Integration tests** verify component compilation and props handling
- **Unit tests** validate component behavior and edge cases

### Design Principles

#### 1. Minimal Props Surface
The current `Button` component demonstrates minimal prop design:

```rust
#[derive(Props, Clone, PartialEq)]
pub struct ButtonProps {
    pub text: String,
    #[props(default)]
    pub onclick: Option<EventHandler<MouseEvent>>,
}
```

#### 2. Event Handler Flexibility
Components support optional event handlers for maximum flexibility:

```rust
button {
    onclick: move |evt| {
        if let Some(handler) = &props.onclick {
            handler.call(evt);
        }
    },
    "{props.text}"
}
```

#### 3. Consistent Styling
All components follow consistent styling patterns and support theming.

## Current Components

### Button Component

The template includes a foundational `Button` component demonstrating best practices:

```rust
use shared_ui::Button;

// Basic usage
Button {
    text: "Click me",
    onclick: |_| println!("Button clicked!")
}

// Optional event handler
Button {
    text: "Submit",
    onclick: None  // No click handler
}
```

### Component Implementation

The `Button` component showcases:
- **Type-safe props** with Dioxus `Props` derive
- **Optional event handlers** for flexible usage
- **Clean RSX syntax** following Dioxus best practices
- **Integration testing** for compilation verification

## Extension Points

This crate is designed to be extended with additional components as needed:

### Adding Components
1. Create new component file in `src/components/`
2. Follow the `Button` component pattern for consistency
3. Add comprehensive tests for new components
4. Export from `lib.rs` for public use

### Future Components
Consider adding components such as:
- Input fields and form controls
- Layout components (Container, Grid, Flex)
- Navigation components (Menu, Breadcrumbs)
- Feedback components (Modal, Toast, Alert)
- Data display components (Table, List, Card)

## Development Guidelines

### Adding New Components

1. **Create component file** in `src/components/`
2. **Define Props struct** with appropriate derives
3. **Implement component function** with clear documentation
4. **Add to module exports** in `mod.rs` and `lib.rs`
5. **Write tests** for component behavior
6. **Document usage** with examples

### Component Template
```rust
use dioxus::prelude::*;

/// A reusable component for [purpose].
///
/// # Example
/// ```rust
/// MyComponent {
///     prop1: "value",
///     prop2: 42
/// }
/// ```
#[derive(Props, Clone, PartialEq)]
pub struct MyComponentProps {
    /// Description of prop1
    pub prop1: String,
    /// Description of prop2
    #[props(default = 0)]
    pub prop2: i32,
}

#[component]
pub fn MyComponent(props: MyComponentProps) -> Element {
    rsx! {
        div {
            // Component implementation
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_my_component() {
        // Component tests
    }
}
```

### Best Practices

1. **Keep components focused**: Each component should have a single responsibility
2. **Use semantic HTML**: Ensure accessibility and proper semantics
3. **Handle edge cases**: Consider empty states, loading states, error states
4. **Performance**: Use `memo` for expensive computations
5. **Testing**: Test component rendering and event handling

## Integration with Models

Components can accept and work with data models:

```rust
use shared_models::User;

#[derive(Props, Clone, PartialEq)]
pub struct UserCardProps {
    pub user: User,
    #[props(default)]
    pub onclick: Option<EventHandler<MouseEvent>>,
}

#[component]
pub fn UserCard(props: UserCardProps) -> Element {
    rsx! {
        div {
            class: "user-card",
            onclick: move |evt| {
                if let Some(handler) = &props.onclick {
                    handler.call(evt);
                }
            },
            h3 { "{props.user.name}" }
            p { "{props.user.email}" }
        }
    }
}
```

## Accessibility

### ARIA Support
Components include proper ARIA attributes:

```rust
button {
    "aria-label": "Close dialog",
    role: "button",
    tabindex: 0
}
```

### Keyboard Navigation
All interactive components support keyboard navigation following web standards.

### Screen Reader Support
Semantic HTML and proper labeling ensure screen reader compatibility.
