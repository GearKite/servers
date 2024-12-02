#!/usr/bin/env bash
# https://nix-community.github.io/nixos-anywhere/howtos/secrets.html

# Create a temporary directory
temp=$(mktemp -d)

# Function to cleanup temporary directory on exit
cleanup() {
  rm -rf "$temp"
}
trap cleanup EXIT

# Create the directory where sshd expects to find the host keys
install -d -m755 "$temp/etc/ssh"

# Decrypt your private key from the password store and copy it to the temporary directory
sudo agenix --identity /etc/ssh/ssh_host_ed25519_key -d hosts/vm-admin/ssh_host_ed25519_key.age > "$temp/etc/ssh/ssh_host_ed25519_key"

# Set the correct permissions so sshd will accept the key
chmod 600 "$temp/etc/ssh/ssh_host_ed25519_key"

# Install NixOS to the host system with our secrets
nixos-anywhere --extra-files "$temp" --flake '.#your-host' root@yourip