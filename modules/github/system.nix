{ username, ... }:
{
  # Read-only fine-grained PAT for gh; pushes stay on SSH + YubiKey.
  age.secrets.github-token-ro = {
    rekeyFile = ../../secrets/github-token-ro.age;
    owner = username;
    group = "users";
    mode = "400";
  };
}
