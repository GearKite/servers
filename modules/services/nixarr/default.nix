{ inputs, ... }:
{
  imports = [
    inputs.nixarr.nixosModules.default
  ];
}