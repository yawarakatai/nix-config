let
  readKey = path: builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile path);
in
{
  # YubiKey SSH keys (for SSH client authentication)
  ssh = {
    yubikey-5 = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKo0I6267iVhv4piUE1dvLbz8/j63sUU0nu8fFLdRX40AAAADnNzaDpuaXgtY29uZmln yubikey-5";
    yubikey-5c = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIA4bVQFlkXgArKYPxuQtaXxFA8ZX8rLMk+LexGgbwBJ/AAAADnNzaDpuaXgtY29uZmln yubikey-5c";
  };

  # Host SSH keys (for agenix-rekey rekeying)
  # Obtain with: cat /etc/ssh/ssh_host_ed25519_key.pub
  hosts = {
    desuwa = readKey ../hosts/desuwa/generated/ssh_host_ed25519_key.pub;
    dane = readKey ../hosts/dane/generated/ssh_host_ed25519_key.pub;
    nanodesu = readKey ../hosts/nanodesu/generated/ssh_host_ed25519_key.pub;
    kamo = readKey ../hosts/kamo/generated/ssh_host_ed25519_key.pub;
  };
}
