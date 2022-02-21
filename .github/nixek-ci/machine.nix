{ nixpkgs, pkgs }:
let
  lib = pkgs.lib;
  evalConfig = import "${nixpkgs}/nixos/lib/eval-config.nix";
  sharedConfig = config: {
    environment.systemPackages = with pkgs; [
      git
      ddate
    ];

    users.users.nixek = {
      description = "nixek ci user";
      isNormalUser = true;
      createHome = true;
      home = "/home/nixek";
      group = "nixek";
      extraGroups = [ "wheel" ];
      uid = 1000;
      useDefaultShell = true;
    };

    security.sudo.extraConfig = ''
        %wheel	ALL=(ALL) NOPASSWD: ALL
    '';

    # TODO: the overlay should just define a nixos service for this
    systemd.services.nixekd = {
      description = "Run nixekcid";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.nixekcid} run-job --user nixek";
      };
    };
  };
  amazonImage = ((import "${nixpkgs}/nixos/release.nix") {
    configuration = { config, ... }: {
      amazonImage = {
        format = "raw";
        sizeMB = 16 * 1024;
      };
      modules = [ (sharedConfig { inherit config; }) ];
    };
  }).amazonImage.x86_64-linux;

  qemuImage = ((import "${nixpkgs}/nixos/lib/make-disk-image.nix") {
    inherit pkgs lib;

    diskSize = 40 * 1024;

    config = (evalConfig {
      system = "x86_64-linux";
      modules = [
        ({
          imports = [
            "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
            "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
          ];
        })
        sharedConfig
      ];
    }).config;
  });
in
  {
    aws = amazonImage;
    qemu = qemuImage;
  }
