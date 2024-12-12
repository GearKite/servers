{ ... }: {
  networking.hosts = {
    "fdc6:b53a:280e:095::100" = [ "vm-admin" ];
    "fdc6:b53a:280e:095::101" = [ "vm-public-ingress" ];
    "fdc6:b53a:280e:095::102" = [ "vm-public-media" ];
  };
}
