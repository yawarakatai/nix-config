let
  keys = import ./keys.nix;
  masterKey = "age1xnx786rjc69fp65qqruglkqy8tlgjl3x7akvrlke4h3cpprsx9gsm88het";
  allKeys = (builtins.attrValues keys.yubikey) ++ (builtins.attrValues keys.hosts) ++ [ masterKey ];
in
{
  "user-password.age".publicKeys = allKeys;
}
