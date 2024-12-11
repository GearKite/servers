{ inputs
, config
, pkgs
, lib
, ...
}:

{
  imports = [
    ../../modules/services/nixarr
    ../../modules/disks/share.nix
  ];
}
