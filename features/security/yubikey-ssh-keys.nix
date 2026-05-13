{ config, ... }:
let
  user = config.my.user.name;
in
{
  age.secrets.yubikey-5-sk = {
    rekeyFile = ../../secrets/yubikey-5-sk.age;
    path = "/home/${user}/.ssh/yubikey_5";
    owner = user;
    group = "users";
    mode = "600";
  };

  age.secrets.yubikey-5c-sk = {
    rekeyFile = ../../secrets/yubikey-5c-sk.age;
    path = "/home/${user}/.ssh/yubikey_5c";
    owner = user;
    group = "users";
    mode = "600";
  };
}
