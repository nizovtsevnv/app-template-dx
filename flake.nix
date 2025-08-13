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
            rustup
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
          ];

          shellHook = ''
            echo "🦀 Nix development environment [$(rustc --version)]"

            # Ensure WASM target is installed
            if ! rustup target list --installed | grep -q wasm32-unknown-unknown; then
              echo "Installing WASM target..."
              rustup target add wasm32-unknown-unknown
              echo "✅ WASM target installed"
            else
              echo "WASM target: wasm32-unknown-unknown (already installed)"
            fi

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
