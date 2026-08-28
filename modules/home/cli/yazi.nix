_:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    settings = {
      opener.swayimg = [
        {
          run = ''swayimg "$(dirname "$1")"'';
          orphan = true;
          for = "unix";
        }
      ];
      open.prepend_rules = [
        {
          mime = "image/*";
          use = "swayimg";
        }
      ];
    };

    # Keep navigation on the same physical positions as the other Colemak-DH
    # configurations in this repository.
    keymap.mgr.prepend_keymap = [
      {
        on = [ "n" ];
        run = "leave";
      }
      {
        on = [ "e" ];
        run = "arrow next";
      }
      {
        on = [ "i" ];
        run = "arrow prev";
      }
      {
        on = [ "o" ];
        run = "enter";
      }
      # `n` is Yazi's default "next search result" key; keep that action
      # available after assigning `n` to move to the parent directory.
      {
        on = [ "k" ];
        run = "find_arrow";
      }
      {
        on = [ "K" ];
        run = "find_arrow --previous";
      }
    ];
  };
}
