# a Nix flake for the server

## Install

### Prerequisites

- Hypervisor (Proxmox)
- cloud-init with networking to give IPs

### Process

1. Install admin VM

    1. Generate a NixOS ISO

        ```sh
        $ nixos-generate -f iso --flake .#iso -o output_dir
        ```

    2. Boot the ISO (with cloud-init)

    3. Decrypt the admin VM host key in a temp directory

        ```sh
        $ agenix -d hosts/vm-admin/ssh_host_ed25519_key.age > "$temp/etc/ssh/ssh_host_ed25519_key"
        ```

    4. Do the install with the host key.
    
        ```sh
        $ nixos-anywhere --extra-files "$temp" --flake '.#vm-admin' user@host
        ```

2. Deploy the rest of the VMs

    ...

    ```sh
    $ deploy
    ```