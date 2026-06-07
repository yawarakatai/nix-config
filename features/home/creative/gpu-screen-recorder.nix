{ pkgs, ... }:

let
  toggleRecording = pkgs.writeShellScriptBin "toggle-recording" ''
    REC_DIR="$HOME/rec"
    PID_FILE="/tmp/gpu-screen-recorder.pid"

    mkdir -p "$REC_DIR"

    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
      PID=$(cat "$PID_FILE")
      kill -INT "$PID"
      rm -f "$PID_FILE"
      notify-send -u low -t 3000 'Recording' "Saved to $REC_DIR"
    else
      TIMESTAMP=$(date +%Y%m%d-%H%M%S)
      OUTPUT="$REC_DIR/recording-$TIMESTAMP.mkv"
      ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder \
        -w screen \
        -f 60 \
        -k hevc \
        -q very_high \
        -cr full \
        -ffmpeg-video-opts "colorspace=bt709;colorprim=bt709;transfer=bt709" \
        -o "$OUTPUT" >/dev/null 2>&1 &
      disown
      echo $! > "$PID_FILE"
    fi
  '';

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
  home.packages = with pkgs; [
    gpu-screen-recorder
    toggleRecording
    recordingIndicator
  ];
}
