{
  config,
  lib,
  pkgs,
  ...
}:

let
  profileDir = "${config.xdg.configHome}/obs-studio/basic/profiles/kamo-4k30";
  profile = pkgs.writeText "obs-kamo-4k30.ini" ''
    [General]
    Name=kamo-4k30

    [Output]
    Mode=Advanced

    [AdvOut]
    RecType=Standard
    RecFormat2=mkv
    RecEncoder=ffmpeg_vaapi
    RecAudioEncoder=ffmpeg_aac
    Track1Bitrate=320

    [Video]
    BaseCX=3840
    BaseCY=2160
    OutputCX=3840
    OutputCY=2160
    FPSType=0
    FPSCommon=30
    ColorFormat=NV12
    ColorSpace=709
    ColorRange=Partial

    [Audio]
    SampleRate=48000
    ChannelSetup=Stereo
  '';
  encoder = pkgs.writeText "obs-kamo-4k30-encoder.json" (
    builtins.toJSON {
      rate_control = "CQP";
      qp = 20;
    }
  );
in
{
  home.packages = [ pkgs.obs-studio ];

  xdg.desktopEntries."com.obsproject.Studio" = {
    name = "OBS Studio";
    genericName = "Streaming/Recording Software";
    exec = "${pkgs.obs-studio}/bin/obs --profile kamo-4k30";
    icon = "com.obsproject.Studio";
    categories = [
      "AudioVideo"
      "Recorder"
    ];
    terminal = false;
  };

  # OBS saves profiles by replacing files, so keep them writable and restore
  # only this dedicated profile when Home Manager activates.
  home.activation.obsRecordingProfile = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    profile_dir=${lib.escapeShellArg profileDir}
    if [ -e "$profile_dir" ] && [ ! -f "$profile_dir/.nix-managed" ]; then
      echo "error: $profile_dir exists and is not managed by Nix" >&2
      exit 1
    fi

    $DRY_RUN_CMD ${pkgs.coreutils}/bin/mkdir -p "$profile_dir"
    $DRY_RUN_CMD ${pkgs.coreutils}/bin/touch "$profile_dir/.nix-managed"
    $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -m 0644 ${profile} "$profile_dir/basic.ini"
    $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -m 0644 ${encoder} "$profile_dir/recordEncoder.json"
  '';
}
