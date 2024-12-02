{ inputs
, outputs
, stateVersion
, ...
}:
{
  mkNixos =
    { hostname
    , username
    , platform ? "x86_64-linux"
    ,
    }:
    let
      isISO = builtins.substring 0 3 hostname == "iso";
      isInstall = !isISO;
    in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          hostname
          platform
          username
          stateVersion
          isISO
          isInstall
          ;
      };
      modules = [ ../hosts ];
    };

  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
  ];
}
