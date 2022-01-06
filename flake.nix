{
  description = "A CI example project";

  inputs = {
    nixek.url = "github:nixek-systems/pkgs";
  };

  outputs = { self, nixpkgs, nixek }:
  let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [
        nixek.overlay
      ];
    };
  in
  {
    ci = import ./.github/nixek-ci/hello-world.nix { inherit nixpkgs pkgs; };
  };
}
