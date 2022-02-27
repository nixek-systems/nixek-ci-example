{
  description = "A CI example project";

  inputs = {
    nixekcid.url = "path:/home/esk/dev/nixek-ci/monorepo";
  };

  outputs = { self, nixpkgs, nixekcid }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (final: prev: {
          nixekcid = nixekcid.packages."${system}".nixekcid;
        })
      ];
    };
  in
  {
    ci = import ./.github/nixek-ci/hello-world.nix { inherit nixpkgs pkgs; };
  };
}
