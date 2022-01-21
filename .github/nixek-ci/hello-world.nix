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
          name = "Print the discordian date";
          command = ''
            echo "The discordian date is $(ddate)"
          '';
        }
        {
          name = "print hello world";
          # TODO: can we mark commands as pure and do some clever stuff here?
          # TBD, this is just here as a reminder for me.
          # pure = true;
          command = ''echo "hello world"'';
        }
      ];
    };
  };
}
