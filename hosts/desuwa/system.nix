{
  config,
  pkgs,
  username,
  ...
}:

{
  # Steam Frame's 6 GHz adapter needs the local regulatory domain.
  hardware.wirelessRegulatoryDatabase = true;
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom=JP
  '';
  environment.systemPackages = [ pkgs.iw ];

  # NetworkManager remembers a disabled radio across reboots; enable it at boot.
  systemd.services.steam-frame-wifi = {
    description = "Enable Wi-Fi for the Steam Frame adapter";
    requires = [ "NetworkManager.service" ];
    after = [ "NetworkManager.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.networkmanager}/bin/nmcli radio wifi on";
    };
  };

  services.samba = {
    enable = true;
    settings = {
      global = {
        "server min protocol" = "SMB2_02";
        "map to guest" = "Never";
        "hosts allow" = "127.0.0.1 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16";
        "hosts deny" = "ALL";
      };
      video = {
        path = "${config.users.users.${username}.home}/video";
        "read only" = "yes";
        "guest ok" = "no";
        "valid users" = username;
      };
    };
  };

  # Direct SMB connections do not need the legacy NetBIOS ports.
  networking.firewall.allowedTCPPorts = [ 445 ];
  systemd.tmpfiles.rules = [
    "d ${config.users.users.${username}.home}/video 0700 ${username} users -"
  ];

  services.kanata.keyboards.internal.devices = [
    "/dev/input/by-id/usb-CX_2.4G_Wireless_Receiver-event-kbd"
  ];

  my = {
    display.outputs = {
      "DP-3" = {
        primary = true;
        width = 3840;
        height = 2160;
        refresh = 144.000;
        scale = 1.0;
        vrr = true;
      };
    };
    wallpaper.image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/d8/wallhaven-d8633m.jpg";
      hash = "sha256-hL++++skqVRIPq9Sa4D2RjCaeuHgzB/Oqdg+3AkA/TA=";
    };
    ui.scale = 2.0;
  };
}
