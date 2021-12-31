let
  sources = import ./nix/sources.nix;
  nixpkgs = sources.nixpkgs;
  pkgs = import nixpkgs {};
in
{
  inherit nixpkgs;
  machine = { cfg, ...}: {
    nixek-ci = {
      type = "aws";

      awsConf = {
        rootVolumeSizeGiB = 40;
        instanceType = "t3.small";
      };
    };
    environment.systemPackages = with pkgs; [
      ddate
    ];
  };
  ci = { info }: {
    demo.steps = [
      {
        name = "Checkout";
        type = "checkout";
      }
      {
        name = "Print the discordian date";
        command = "The discordian date is $(ddate)";
      }
    ];
  };
}
