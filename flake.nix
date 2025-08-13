{
  description = "Rust workspace development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
          targets = [ "wasm32-unknown-unknown" ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustToolchain
            pkg-config
            openssl
            pre-commit

            # Security and quality tools
            cargo-audit
            cargo-outdated
            cargo-edit
            cargo-watch
            cargo-deny

            # Dioxus and WASM tools
            dioxus-cli
            wasm-bindgen-cli

            # Frontend tooling
            nodejs_22
            tailwindcss
          ];

          shellHook = ''
            echo "🦀 Nix development environment [$(rustc --version)]"

            # Automatically install pre-commit hooks
            if [ -f .pre-commit-config.yaml ] && [ ! -f .git/hooks/pre-commit ]; then
              echo "Installing pre-commit hooks..."
              pre-commit install --install-hooks
              echo "✅ Pre-commit hooks installed"
            fi
          '';
        };
      });
}
