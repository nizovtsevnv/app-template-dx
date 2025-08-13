# Shared UI Assets

This directory contains shared assets used across the UI component library.

## Purpose

Common resources that can be reused by multiple applications in the workspace:
- Icons and graphics for UI components
- Shared fonts
- Common images (logos, illustrations)

## Structure

```
shared/ui/assets/
├── README.md       # This file
├── icons/          # SVG icons for UI components
├── fonts/          # Shared fonts
└── images/         # Common images and graphics
```

## Usage

These assets are typically referenced by UI components in `shared/ui/src/components/` and can be used by any application in the workspace.

## App-Specific Assets

For application-specific assets (including generated CSS), use the respective app's assets directory:
- `apps/web/assets/` for web app assets
