{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    flakelight = {
      url = "github:nix-community/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mill-scale = {
      url = "github:icewind1991/mill-scale";
      inputs.flakelight.follows = "flakelight";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    demostf-mover = {
      url = "github:/demostf/mover";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    demostf-backup = {
      url = "github:/demostf/backup-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    demostf-migrate = {
      url = "github:/demostf/migrate-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flakelight.follows = "flakelight";
      inputs.mill-scale.follows = "mill-scale";
    };
    demo-inspector = {
      url = "github:demostf/inspector";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.utils.follows = "flake-utils";
    };
    demo-buttons = {
      url = "git+ssh://git@git.icewind.me/demostf/buttons.git";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.utils.follows = "flake-utils";
    };
    map-boundaries = {
      url = "github:icewind1991/mapboundaries";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
    vbsp-to-gltf = {
      url = "github:icewind1991/vbsp-to-gltf";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flakelight.follows = "flakelight";
      inputs.mill-scale.follows = "mill-scale";
    };
    demostf-api = {
      url = "github:demostf/api";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flakelight.follows = "flakelight";
    };
    demostf-frontend = {
      url = "github:demostf/frontend";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flakelight.follows = "flakelight";
      inputs.mill-scale.follows = "mill-scale";
    };
    demostf-sync = {
      url = "github:demostf/sync-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flakelight.follows = "flakelight";
      inputs.mill-scale.follows = "mill-scale";
    };
  };

  outputs = inputs: {
    overlays.default = final: prev:
      prev.lib.composeManyExtensions (with inputs; [
        vbsp-to-gltf.overlays.default
        demo-buttons.overlays.default
        demo-inspector.overlays.default
        demostf-frontend.overlays.default
        demostf-api.overlays.default
        (final: prev: {
          demostf-frontend-toolchain = final.rust-bin.fromRustupToolchainFile (demostf-frontend + "/rust-toolchain.toml");
        })
        demostf-sync.overlays.default
        map-boundaries.overlays.default
      ])
      final
      prev;
    nixosModules.default = {
      imports = with inputs; [
        demostf-mover.nixosModules.default
        demostf-backup.nixosModules.default
        demostf-migrate.nixosModules.default
        ./modules/api.nix
      ];
    };
  };
}
