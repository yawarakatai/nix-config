{ username, ... }:
{
  age.secrets.yubikey-5-sk = {
    rekeyFile = ../../secrets/yubikey-5-sk.age;
    owner = username;
    group = "users";
    mode = "600";
  };

  age.secrets.yubikey-5c-sk = {
    rekeyFile = ../../secrets/yubikey-5c-sk.age;
    owner = username;
    group = "users";
    mode = "600";
  };
}
