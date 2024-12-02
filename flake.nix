{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, deploy-rs, ... }@inputs:
    let
      inherit (self) outputs;
      stateVersion = "24.11";
      helper = import ./lib { inherit inputs outputs stateVersion; };
      vmUsername = "coil";
    in
    {
      nixosConfigurations = {
        vm-admin = helper.mkNixos {
          hostname = "vm-admin";
          username = vmUsername;
        };
        vm-minimal = helper.mkNixos {
          hostname = "vm-minimal";
          username = vmUsername;
        };
        iso = helper.mkNixos {
          hostname = "iso";
          username = vmUsername;
        };
      };

      deploy.nodes = {
        vm-admin = {
          hostname = "192.168.233.32";
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vm-admin;
          profiles.system.user = "root";
          profiles.system.sshUser = vmUsername;
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
