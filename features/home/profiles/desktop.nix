{ pkgs, ... }:

let
  recordingIndicator = pkgs.writeShellScriptBin "recording-indicator" ''
    PID_FILE="/tmp/gpu-screen-recorder.pid"
    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
      echo '{"text": "\uf04d REC", "class": "recording", "tooltip": "Recording to ~/rec/"}'
    else
      TIME=$(date +%H:%M)
      TODAY=$(date +%-d)
      C1="#f6c177"
      C2="#c4a7e7"
      C3="#eb6f92"
      CAL=$(cal | awk -v t="$TODAY" -v c1="$C1" -v c2="$C2" -v c3="$C3" '
        NR==1 { printf "<span color=%c%s%c><b>%s</b></span>\\n", 39, c1, 39, $0; next }
        NR==2 { printf "<span color=%c%s%c><b>%s</b></span>\\n", 39, c2, 39, $0; next }
        {
          for (i=1; i<=NF; i++) {
            d=$i
            if (d+0 == t+0 && d != "")
              printf " <span color=%c%s%c><b>%2s</b></span>", 39, c3, 39, d
            else
              printf " %2s", d
          }
          printf "\\n"
        }')
      printf '{"text": "%s", "tooltip": "%s"}\n' "$TIME" "$CAL"
    fi
  '';
in
{
  imports = [
    ./default.nix
    ../browser/zen-browser.nix
    ../dev
    ../terminal/alacritty.nix
    ../service/ssh-client.nix
  ];

  home.packages = with pkgs; [
    nautilus
    loupe
    mpv
    pavucontrol
    playerctl
    brightnessctl
    recordingIndicator
  ];

  systemd.user.sessionVariables = {
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULE = "wayland;fcitx";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
      "application/pdf" = "zen-beta.desktop";
      "image/bmp" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
      "image/heif" = "org.gnome.Loupe.desktop";
      "image/avif" = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/jpg" = "org.gnome.Loupe.desktop";
      "image/jxl" = "org.gnome.Loupe.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/svg+xml" = "org.gnome.Loupe.desktop";
      "image/tiff" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "video/mp4" = "mpv.desktop";
      "video/mkv" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/avi" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
    };
  };
}
