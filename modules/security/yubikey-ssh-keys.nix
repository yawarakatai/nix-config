{ username, ... }:
{
  age.secrets.yubikey-5-sk = {
    rekeyFile = ../../secrets/yubikey-5-sk.age;
    path = "/home/${username}/.ssh/yubikey_5";
    owner = username;
    group = "users";
    mode = "600";
  };

  age.secrets.yubikey-5c-sk = {
    rekeyFile = ../../secrets/yubikey-5c-sk.age;
    path = "/home/${username}/.ssh/yubikey_5c";
    owner = username;
    group = "users";
    mode = "600";
  };
}
