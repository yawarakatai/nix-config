{ config, pkgs, theme, ... }:

{
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
    
    settings = {
      manager = {
        show_hidden = true;
        show_symlink = true;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
      };
      
      preview = {
        max_width = 1000;
        max_height = 1000;
        image_filter = "lanczos3";
        image_quality = 90;
      };
    };
    
    theme = {
      # Manager
      manager = {
        cwd = { fg = theme.semantic.keyword; };
        hovered = { fg = theme.colorScheme.base00; bg = theme.semantic.variable; };
        preview_hovered = { underline = true; };
        find_keyword = { fg = theme.semantic.warning; italic = true; };
        find_position = { fg = theme.semantic.info; bg = "reset"; italic = true; };
        marker_selected = { fg = theme.semantic.success; bg = theme.semantic.success; };
        marker_copied = { fg = theme.semantic.warning; bg = theme.semantic.warning; };
        marker_cut = { fg = theme.semantic.error; bg = theme.semantic.error; };
        tab_active = { fg = theme.colorScheme.base00; bg = theme.semantic.function; };
        tab_inactive = { fg = theme.colorScheme.base05; bg = theme.colorScheme.base01; };
        border_symbol = "│";
        border_style = { fg = theme.colorScheme.base03; };
      };
      
      # Status line
      status = {
        separator_open = "";
        separator_close = "";
        separator_style = { fg = theme.colorScheme.base03; bg = theme.colorScheme.base03; };
        mode_normal = { fg = theme.colorScheme.base00; bg = theme.semantic.function; bold = true; };
        mode_select = { fg = theme.colorScheme.base00; bg = theme.semantic.success; bold = true; };
        mode_unset = { fg = theme.colorScheme.base00; bg = theme.semantic.warning; bold = true; };
        progress_label = { fg = theme.colorScheme.base05; bold = true; };
        progress_normal = { fg = theme.semantic.function; bg = theme.colorScheme.base01; };
        progress_error = { fg = theme.semantic.error; bg = theme.colorScheme.base01; };
        permissions_t = { fg = theme.semantic.success; };
        permissions_r = { fg = theme.semantic.warning; };
        permissions_w = { fg = theme.semantic.error; };
        permissions_x = { fg = theme.semantic.info; };
        permissions_s = { fg = theme.semantic.keyword; };
      };
      
      # File types
      filetype = {
        rules = [
          { mime = "image/*"; fg = theme.semantic.info; }
          { mime = "video/*"; fg = theme.semantic.warning; }
          { mime = "audio/*"; fg = theme.semantic.keyword; }
          { mime = "application/zip"; fg = theme.semantic.error; }
          { mime = "application/gzip"; fg = theme.semantic.error; }
          { mime = "application/x-tar"; fg = theme.semantic.error; }
          { mime = "application/x-bzip"; fg = theme.semantic.error; }
          { mime = "application/x-7z-compressed"; fg = theme.semantic.error; }
          { mime = "application/x-rar"; fg = theme.semantic.error; }
          { name = "*"; fg = theme.colorScheme.base05; }
          { name = "*/"; fg = theme.semantic.function; }
        ];
      };
    };
    
    keymap = {
      manager.prepend_keymap = [
        { on = [ "<Esc>" ]; exec = "escape"; desc = "Exit visual mode, clear selected, or cancel search"; }
        { on = [ "q" ]; exec = "quit"; desc = "Exit the process"; }
        { on = [ "<C-q>" ]; exec = "quit --no-cwd-file"; desc = "Exit without writing cwd-file"; }
      ];
    };
  };
}
