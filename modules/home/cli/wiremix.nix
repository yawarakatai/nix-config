_:

{
  xdg.configFile."wiremix/wiremix.toml".text = ''
    # Colemak-DH navigation. Arrow keys remain available as well.
    keybindings = [
      { key = { Char = "n" }, action = { SetRelativeVolume = -0.01 } },
      { key = { Char = "e" }, action = "MoveDown" },
      { key = { Char = "i" }, action = "MoveUp" },
      { key = { Char = "o" }, action = { SetRelativeVolume = 0.01 } },
    ]
  '';
}
