# yazi file manager configuration
{ ... }:

{
  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
    enableNushellIntegration = false;
    enableZshIntegration = true;

    settings = {
      mgr = {
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

    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "<Esc>" ];
          run = "escape";
          desc = "Exit visual mode, clear selected, or cancel search";
        }
        {
          on = [ "q" ];
          run = "quit";
          desc = "Exit the process";
        }
        {
          on = [ "<C-q>" ];
          run = "quit --no-cwd-file";
          desc = "Exit without writing cwd-file";
        }
      ];
    };
  };
}
