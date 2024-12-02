{ inputs
, config
, pkgs
, lib
, username
, ...
}:

{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../hosts/vm-admin/id_ed25519.pub)
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP9PZDZlYvsGOqmuzIiTxyTuVb0XXBsF+t0iF75BWuQz"
    ];
  };

  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };
}
