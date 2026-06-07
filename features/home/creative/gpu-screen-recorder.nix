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
      echo "{\"text\": \"$(date '+%H:%M')\", \"class\": \"\"}"
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
