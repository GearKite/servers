{ inputs
, config
, pkgs
, lib
, ...
}:

{ 
  imports = [
    ../../modules/services/nixarr
  ];
}
