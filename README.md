# a Nix flake for the server

## Install

### Proxmox

1. Set PVE node IP

   ```sh
   export PROD_IP=xxx
   ```

2. Run initial setup playbook (on each Node)

   ```sh
   ansible-playbook -i ansible/hosts/hosts.ini ansible/playbooks/setup/prod-init.yml
   ```

3. [Accept each node into the ZeroTier network](https://my.zerotier.com/)

4. Set `VXLAN_PEER_IPS` to a comma-separated list of all PVE node ZeroTier IPs:

   ```sh
   export VXLAN_PEER_IPS=xxx,xxx,xxx
   ```

5. Run cluster configuration playbook (on any 1 node)

   ```sh
   ansible-playbook -i ansible/hosts/hosts.ini ansible/playbooks/setup/prod-config.yml
   ```

### VMs

1. Install admin VM

    1. Generate a NixOS ISO

        ```sh
        nixos-generate -f iso --flake .#iso -o output_dir
        ```

    2. Boot the ISO (with cloud-init)

    3. Decrypt the admin VM host key in a temp directory

        ```sh
        agenix -d hosts/vm-admin/ssh_host_ed25519_key.age > "$temp/etc/ssh/ssh_host_ed25519_key"
        ```

    4. Do the install with the host key.

        ```sh
        nixos-anywhere --extra-files "$temp" --flake '.#vm-admin' user@host
        ```

2. Deploy the rest of the VMs

    ...

    ```sh
    deploy
    ```
