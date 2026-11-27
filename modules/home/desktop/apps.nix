{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wlr-randr
    nautilus
    swayimg
    playerctl
    brightnessctl
    unar
    # Helix's `clipboard-provider = "wayland"` runs wl-copy and wl-paste.
    wl-clipboard
  ];

  programs.mpv = {
    enable = true;
    # Pause on the last frame instead of closing the file, so it can still be
    # seeked back from the end.
    config.keep-open = "yes";
    # Shown by `o`, on seeks, and permanently after toggling with `O`.
    # estimated-frame-number is derived from time and fps, so it can be off
    # for variable-frame-rate files.
    config.osd-status-msg = "\${osd-sym-cc} \${time-pos} / \${duration} (\${percent-pos}%)  frame \${estimated-frame-number} / \${estimated-frame-count}";
  };

  # Nautilus' built-in gnome-autoar extractor has no setting for legacy
  # archive filename encodings.  Expose unar in the Scripts context menu.
  home.file.".local/share/nautilus/scripts/Extract with unar" = {
    source = pkgs.writeShellScript "nautilus-extract-with-unar" ''
      set -eu

      for archive do
        unar -o "$(dirname -- "$archive")" "$archive"
      done
    '';
  };
}
