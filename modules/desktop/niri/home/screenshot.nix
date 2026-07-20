{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "screenshot-copy" ''
      set -eu

      region="$(${pkgs.slurp}/bin/slurp)" || exit 0
      image="$(${pkgs.coreutils}/bin/mktemp --suffix=.png)"
      trap '${pkgs.coreutils}/bin/rm -f "$image"' EXIT

      ${pkgs.grim}/bin/grim -g "$region" "$image"

      qr="$(
        ${pkgs.zbar}/bin/zbarimg \
          --quiet \
          --raw \
          "$image" 2>/dev/null || true
      )"

      if [ -n "$qr" ]; then
        printf '%s' "$qr" |
          ${pkgs.wl-clipboard}/bin/wl-copy \
            --type 'text/plain;charset=utf-8'

        ${pkgs.libnotify}/bin/notify-send \
          -u low \
          "QR code" \
          "Text copied to clipboard"
      else
        ${pkgs.wl-clipboard}/bin/wl-copy \
          --type image/png < "$image"

        ${pkgs.libnotify}/bin/notify-send \
          -u low \
          "Screenshot" \
          "Image copied to clipboard"
      fi
    '')
  ];
}
