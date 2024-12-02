{ ... }:
{
  # Enable cloud-init networking for VMs to get IP addresses
  services.cloud-init.enable = true;
  services.cloud-init.network.enable = true;
  networking.useDHCP = false;
}
