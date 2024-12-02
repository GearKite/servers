{ inputs
, config
, pkgs
, lib
, username
, ...
}:

{
  environment.systemPackages = with pkgs; [
    nixos-anywhere
    nixos-generators
    deploy-rs
    git
  ];

  systemd.services.clone-repo = {
    description = "Clone Git Repository";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      #!/usr/bin/env bash
      echo Cloning repo...
      ${pkgs.git}/bin/git clone https://github.com/gearkite/servers.git /home/${username}/servers ||
      echo Pulling already cloned repo...
      cd /home/${username}/servers && ${pkgs.git}/bin/git pull
    '';
  };
}
