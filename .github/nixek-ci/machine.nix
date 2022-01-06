{ nixpkgs, pkgs }:
  ((import "${nixpkgs}/nixos/release.nix") {
    configuration = { config, ... }: {
      amazonImage = {
        format = "raw";
        sizeMB = 16 * 1024;
      };

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
  }).amazonImage.x86_64-linux
