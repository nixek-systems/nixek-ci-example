{ nixpkgs, pkgs }:
let
  system = "x86_64-linux";
  machine = import ./machine.nix { inherit pkgs nixpkgs; };
in
{
  jobs = {
    demo-job = { info }: {
      inherit machine;

      steps = [
        {
          name = "Checkout";
          type = "checkout";
        }
        {
          name = "Print the discordian date";
          command = ''
            echo "The discordian date is $(ddate)"
          '';
        }
      ];
    };
  };
}
