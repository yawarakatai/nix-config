_:

{
  # Blur is experimental and remains opt-in via ./blur.nix.
  imports = [
    ./binds.nix
    ./clipboard.nix
    ./input.nix
    ./layout.nix
    ./outputs.nix
    ./settings.nix
    ./screenshot.nix
    ./window-rules.nix
  ];
}
