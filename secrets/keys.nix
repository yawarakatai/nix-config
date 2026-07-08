{
  master = {
    yubikey-5 = "age1xnx786rjc69fp65qqruglkqy8tlgjl3x7akvrlke4h3cpprsx9gsm88het";
    yubikey-5c = "age1utpkhvtyhw77cq7zxhx6emtrwlwewasszrfuzncfnrax7us0eduswx8squ";
  };

  # YubiKey SSH keys (for SSH client authentication)
  ssh = {
    yubikey-5 = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKoUC9mEqLf9q8geELb89t8I9P+0JBD2fvm51+jwNuu3AAAABHNzaDo= yubikey-5";
    yubikey-5c = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFwdOpc6zvMiZ0zC/NqC2mzEn0B5hdRz1jD2V76vsclLAAAABHNzaDo= yubikey-5c";
  };

  # Host SSH keys (for agenix-rekey rekeying)
  # Obtain with: cat /etc/ssh/ssh_host_ed25519_key.pub
  hosts = {
    desuwa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEnAhIcZqtU80UNZ7A/2zRQHUzIxQqXcEIZbe1LSiK/S root@desuwa";
    nanodesu = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICxg8hL0i1hQY11LLEih0wXnxcEUOBOYQYvNvb1sp99/ root@nanodesu";
    dane = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVys/U5xxiWVwmI8kZ8g8drk/CSZS1DXtYIgr6zzxET root@dane";
    kamo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINb9pLAskLkP1WXlGwBAUI/ZWip40O5+JicctVf6fs3N root@kamo";
  };
}
