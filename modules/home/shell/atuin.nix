{ ... }:

{
  programs.atuin = {
    enable = true;
    enableNushellIntegration = false;
    enableZshIntegration = true;

    settings = {
      # Sync settings (optional, requires atuin server)
      # auto_sync = true;
      # sync_address = "https://api.atuin.sh";

      # Search settings
      search_mode = "fuzzy";
      filter_mode = "global";
      style = "compact";
      inline_height = 20;
      show_preview = true;

      # Key bindings
      keymap_mode = "emacs";

      # History settings
      update_check = false;

      # UI
      show_help = true;
    };
  };
}
