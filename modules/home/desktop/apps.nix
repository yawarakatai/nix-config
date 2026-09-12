{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wlr-randr
    nautilus
    swayimg
    mpv
    playerctl
    brightnessctl
    unar
  ];

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
