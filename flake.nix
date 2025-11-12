{
  description = "Because what's yet another flake input, right?";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
  } @ inputs: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      # "aarch64-darwin" # no means of testing at this time
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    pkgsFor = system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [self.overlays.default];
      };
      overlay = self.overlays.default pkgs pkgs;
    in
      overlay;
  in {
    inherit (import ./flake.nix) nixConfig;
    packages = forAllSystems pkgsFor;

    overlays.default = import ./overlay.nix;
    nixosModules.default = import ./modules;
    checks = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [self.overlays.default];
        };
      in let
        forAllChecks = (import ./checks {lib = pkgs.lib;}).allChecks;
      in
        forAllChecks (check:
          pkgs.callPackage check {
            self = self;
            pkgs = pkgs;
          })
    );

    formatter = forAllSystems (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
        pkgs.alejandra
    );
  };
}
