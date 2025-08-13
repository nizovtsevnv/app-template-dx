# Web App Assets

This directory contains assets specific to the web application.

## Structure

```
apps/web/assets/
├── README.md           # This file
├── generated.css       # Generated CSS (do not edit, ignored by git)
├── images/            # Web app specific images
├── fonts/             # Web app specific fonts
└── icons/             # Web app specific icons
```

## File Types

### Generated Files (ignored by git)
- `generated.css` - Generated styles compiled from `shared/ui/styles.css` and Tailwind classes used in this app

### Static Assets (tracked by git)
- Images: `.png`, `.jpg`, `.jpeg`, `.gif`, `.svg`, `.webp`
- Fonts: `.woff`, `.woff2`, `.ttf`, `.otf`
- Icons: `.ico`, `.svg`

## Usage in Dioxus

Access assets using the `asset!()` macro:

```rust
use dioxus::prelude::*;

#[component]
fn MyComponent() -> Element {
    rsx! {
        // Generated CSS
        document::Stylesheet {
            href: asset!("/assets/generated.css")
        }

        // App-specific images
        img {
            src: asset!("/assets/images/app-logo.png"),
            alt: "App Logo"
        }
    }
}
```

## Build Process

- **CSS Generation**: Run `make styles` or `make dev` to generate CSS
- **Asset Discovery**: Dioxus automatically includes assets from this directory
- **Optimization**: Assets are optimized during build process

## Shared Assets

For assets shared across multiple apps, use `shared/ui/assets/` instead.
