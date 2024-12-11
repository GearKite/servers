{ config, pkgs, ... }:
{
  fileSystems."/data" = {
    device = "data";
    fsType = "9p";
    options = [ "trans=virtio" ];
  };
}
