{
  inputs,
  lib,
  osConfig,
  self,
  ...
}:

{
  imports = [
    self.modules.homeManager.profiles.desktop
    ../../../modules/home/services/ura.nix
  ];

  # Gaming Mode also starts graphical-session.target; keep the desktop shell
  # and other Home Manager Wayland services attached only to Niri.
  wayland.systemd.target = "niri.service";

  # Quick desktop switches count as short sessions; the vendor repair then
  # overlays an old Steam bootstrap onto the self-updated client.
  xdg.configFile."inhibit-short-session-tracker".text = "";

  # Autologin cannot unlock the login keyring with a password.
  programs.noctalia.settings.storage = {
    key_source = "file";
    key_file = osConfig.age.secrets.noctalia-storage-key.path;
  };

  programs.niri = {
    config = lib.mkOptionDefault (
      lib.mkAfter [
        (inputs.niri.lib.kdl.leaf "include" [
          { optional = true; }
          "noctalia.kdl"
        ])
      ]
    );
  };

  # services.swayidle = {
  #   enable = true;
  #   timeouts = [
  #     {
  #       timeout = 300;
  #       command = "${osConfig.programs.niri.package}/bin/niri msg action power-off-monitors";
  #       resumeCommand = "${osConfig.programs.niri.package}/bin/niri msg action power-on-monitors";
  #     }
  #   ];
  # };
}
