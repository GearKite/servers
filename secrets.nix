let
  gk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP9PZDZlYvsGOqmuzIiTxyTuVb0XXBsF+t0iF75BWuQz";

  admins = [ gk ];

  vm-admin = (builtins.readFile ./hosts/vm-admin/ssh_host_ed25519_key.pub);

  systems = [ vm-admin ];
  everyone = systems ++ admins;
in
{
  "hosts/vm-admin/id_ed25519.age".publicKeys = [ vm-admin ] ++ admins;
  "hosts/vm-admin/ssh_host_ed25519_key.age".publicKeys = [ vm-admin ] ++ admins;
}
