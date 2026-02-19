{
  # YubiKey SSH keys (for SSH client authentication)
  yubikey = {
    yubikey_5 = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKoUC9mEqLf9q8geELb89t8I9P+0JBD2fvm51+jwNuu3AAAABHNzaDo= yubikey_5";
    yubikey_5c = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFwdOpc6zvMiZ0zC/NqC2mzEn0B5hdRz1jD2V76vsclLAAAABHNzaDo= yubikey_5c";
  };

  # Host SSH keys (for agenix-rekey rekeying)
  # Obtain with: cat /etc/ssh/ssh_host_ed25519_key.pub
  hosts = {
    desuwa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEnAhIcZqtU80UNZ7A/2zRQHUzIxQqXcEIZbe1LSiK/S root@desuwa";
    nanodesu = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIsIHhJfA3++zKExnOm3N6QZv5nwZrNTYvm8Ga0DU4Fo root@nanodesu";
    dayo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHfMsVphgO8fB+Yrs4nYf83tf5DwrOdGiBagwfbxHYN root@dayo";
  };

  master = {
    yubikey_5 = "age1xnx786rjc69fp65qqruglkqy8tlgjl3x7akvrlke4h3cpprsx9gsm88het";
    yubikey_5c = "age1utpkhvtyhw77cq7zxhx6emtrwlwewasszrfuzncfnrax7us0eduswx8squ";
  };
}
