{
  imports = [];

  nixpkgs.overlays = [
    (import ../overlay.nix)
  ];
}
