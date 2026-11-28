{ pkgs, ... }:

{
  # karukan merges this over its embedded defaults, so only overrides go here.
  xdg.configFile."karukan-im/config.toml".source = (pkgs.formats.toml { }).generate "karukan-config" {
    # Keeps learned live-conversion sentences out of the top candidates; see README.md.
    learning.max_surface_chars = 8;
  };
}
