{ config
, hostname
, inputs
, lib
, modulesPath
, outputs
, pkgs
, platform
, stateVersion
, username
, isISO
, isInstall
, ...
}:
{
  imports = [
    inputs.agenix.nixosModules.default
    ./${hostname}
    ../modules/cloud-init
    ../modules/disks
    ../modules/users
    ../modules/services/ssh

    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/profiles/minimal.nix")
  ];

  boot = {
    consoleLogLevel = lib.mkDefault 0;
    initrd.verbose = false;
    kernelModules = [ "vhost_vsock" ];
    kernelParams = [ "udev.log_priority=3" "console=ttyS0,115200n8" ];
    kernelPackages = pkgs.linuxPackages;
    loader.grub = lib.mkIf isInstall {
      enable = true;
      useOSProber = true;
      efiSupport = true;
      extraConfig = "
        serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
        terminal_input serial
        terminal_output serial
      ";
    };
  };

  environment = {
    systemPackages =
      with pkgs;
      [
        git
        inputs.agenix.packages.${system}.default
        rsync
      ];
  };

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = "flakes nix-command";
        trusted-users = [
          "root"
          "${username}"
        ];
        # Cachix
        # TODO: DRY (this repeats in flake.nix)
        substituters = [
          "https://gk-arc2.cachix.org"
        ];
        trusted-public-keys = [
          "gk-arc2.cachix.org-1:iJOofh4wNI6QkwKv/Js7QvMPhHrtW6/HyjQw6+uugJM="
        ];
      };
      # Disable channels
      channel.enable = false;
      # Make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  nixpkgs.hostPlatform = lib.mkDefault "${platform}";

  system = {
    nixos.label = "-";
    inherit stateVersion;
  };

  networking.hostName = hostname;

  # VMs don't have passwords, need to auto login to access via tty
  services.getty.autologinUser = lib.mkDefault username;
}
