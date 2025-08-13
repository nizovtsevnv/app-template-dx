# Makefile for app-template-dx

.PHONY: help dev build test lint fmt check clean install-deps docker-build docker-run bench docs all

# Helper functions
define check_dx
	@command -v dx >/dev/null 2>&1 || { echo "dioxus-cli not installed. Install with: cargo install dioxus-cli"; exit 1; }
endef

define check_wasm_target
	@echo "Using Nix-managed Rust toolchain with pre-configured WASM target"
endef

# Default target
help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

# Development
dev: styles ## Start development server with hot reload (generates CSS first)
	$(call check_dx)
	$(call check_wasm_target)
	@echo "Starting development server..."
	cd apps/web && dx serve --platform web --hot-reload true

dev-watch: ## Start development server with CSS watch mode
	@echo "Starting development server with CSS watch mode..."
	@echo "This will run both Dioxus dev server and CSS watch mode in parallel"
	@$(MAKE) -j2 dev-server styles-watch

dev-server: ## Start Dioxus dev server only (internal target)
	$(call check_dx)
	$(call check_wasm_target)
	@sleep 2  # Wait for CSS generation
	cd apps/web && dx serve --platform web --hot-reload true

# Building
build: ## Build all workspace crates
	cargo build --workspace

build-release: ## Build all workspace crates in release mode
	cargo build --workspace --release

build-web: ## Build web application for production
	$(call check_dx)
	$(call check_wasm_target)
	cd apps/web && dx build --platform web --release

# Testing
test: ## Run all tests
	cargo test --workspace

test-models: ## Run tests for shared-models crate
	cargo test -p shared-models

test-ui: ## Run tests for shared-ui crate
	cargo test -p shared-ui

test-web: ## Run tests for web app crate
	cargo test -p web

# Code quality
lint: ## Run clippy linter
	cargo clippy --workspace -- -D warnings

fmt: ## Format code
	cargo fmt --all

fmt-check: ## Check code formatting
	cargo fmt --all --check

check: ## Run all quality checks
	$(MAKE) fmt-check
	$(MAKE) lint
	$(MAKE) test

# Security and dependencies
audit: ## Run security audit
	@command -v cargo-audit >/dev/null 2>&1 || { echo "cargo-audit not installed. Install with: cargo install cargo-audit"; exit 1; }
	cargo audit

deny: ## Run cargo-deny checks
	@command -v cargo-deny >/dev/null 2>&1 || { echo "cargo-deny not installed. Install with: cargo install cargo-deny"; exit 1; }
	cargo deny check

outdated: ## Check for outdated dependencies
	@command -v cargo-outdated >/dev/null 2>&1 || { echo "cargo-outdated not installed. Install with: cargo install cargo-outdated"; exit 1; }
	cargo outdated

update: ## Update dependencies (interactive)
	@command -v cargo-edit >/dev/null 2>&1 || { echo "cargo-edit not installed. Install with: cargo install cargo-edit"; exit 1; }
	cargo edit --upgrade

# Performance
bench: ## Run benchmarks
	cargo bench --workspace

bench-models: ## Run benchmarks for shared-models
	cargo bench -p shared-models

# Documentation
docs: ## Generate documentation
	cargo doc --workspace --no-deps --open

docs-build: ## Build documentation without opening
	cargo doc --workspace --no-deps

# Styling
styles: ## Generate CSS from Tailwind and custom styles
	@echo "Generating CSS for web app..."
	@mkdir -p apps/web/assets
	@if command -v tailwindcss >/dev/null 2>&1; then \
		tailwindcss -i ./shared/ui/styles.css -o ./apps/web/assets/generated.css --config ./shared/ui/tailwind.config.js; \
		echo "✅ CSS generated in apps/web/assets/generated.css"; \
	else \
		echo "❌ tailwindcss not found. Enter Nix environment with: nix develop"; \
		exit 1; \
	fi

# Alias for backwards compatibility
tailwind: styles

styles-watch: ## Watch for changes and rebuild CSS
	@echo "Watching for style changes..."
	@if command -v tailwindcss >/dev/null 2>&1; then \
		tailwindcss -i ./shared/ui/styles.css -o ./apps/web/assets/generated.css --config ./shared/ui/tailwind.config.js --watch; \
	else \
		echo "❌ tailwindcss not found. Enter Nix environment with: nix develop"; \
		exit 1; \
	fi

# Alias for backwards compatibility
tailwind-watch: styles-watch

# Cleaning
clean: ## Clean build artifacts
	cargo clean
	rm -rf apps/web/dist/
	rm -f apps/web/assets/generated.css
	rm -rf target/criterion/

# Dependencies (Note: Most tools are available via Nix)
install-deps: ## Install additional development dependencies (fallback)
	rustup target add wasm32-unknown-unknown
	cargo install dioxus-cli
	cargo install cargo-audit
	cargo install cargo-deny
	cargo install cargo-outdated
	cargo install cargo-edit
	cargo install cargo-watch

# Development workflow helpers
watch: ## Watch for changes and run checks
	@command -v cargo-watch >/dev/null 2>&1 || { echo "cargo-watch not installed. Install with: cargo install cargo-watch"; exit 1; }
	cargo watch -x check -x test

watch-web: ## Watch and rebuild web application
	@command -v cargo-watch >/dev/null 2>&1 || { echo "cargo-watch not installed. Install with: cargo install cargo-watch"; exit 1; }
	cd apps/web && cargo watch -x "dx serve --platform web --hot-reload true"

# Pre-commit checks (fallback implementation)
pre-commit: ## Run pre-commit checks manually
	@echo "Running pre-commit checks..."
	@if command -v pre-commit >/dev/null 2>&1; then \
		pre-commit run --all-files; \
	else \
		echo "pre-commit not available, running manual checks:"; \
		$(MAKE) fmt-check; \
		$(MAKE) lint; \
		$(MAKE) test; \
		if command -v cargo-audit >/dev/null 2>&1; then \
			echo "Running security audit..."; \
			cargo audit; \
		else \
			echo "⚠️  cargo-audit not available, skipping security audit"; \
		fi; \
		echo "✅ Manual checks completed"; \
	fi


# Initialization
init: ## Initialize new project from template
	./scripts/init-template.sh

# Coverage
coverage: ## Generate test coverage report
	cargo tarpaulin --workspace --out Html

# Deployment
deploy-build: ## Build for deployment
	$(call check_dx)
	$(call check_wasm_target)
	cd apps/web && dx build --platform web --release
	@echo "Static files ready in apps/web/dist/"
	@echo "Deploy dist/ directory to any static hosting"

# All-in-one targets
all: check build test ## Run check, build, and test

ci: fmt-check lint test audit deny ## Run all CI checks

# Environment
nix-shell: ## Enter Nix development shell
	nix develop

# Project structure
tree: ## Show project structure
	@echo "Project structure:"
	@tree -I 'target|node_modules|.git' -a

# Quick development setup
setup: install-deps ## Setup development environment
	@echo "Development environment setup complete!"
	@echo "Pre-commit hooks are installed automatically via Nix"
	@echo "Run 'make dev' to start development server"

# Release preparation
release-check: ## Run all checks before release
	$(MAKE) clean
	$(MAKE) check
	$(MAKE) build-release
	$(MAKE) bench
	$(MAKE) docs-build
	@echo "Release checks completed successfully!"
