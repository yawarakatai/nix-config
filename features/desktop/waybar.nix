{ ... }:

{
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "right";
      width = 140;
      margin-top = 4;
      margin-right = 4;
      margin-bottom = 4;

      modules-right = [
        "network"
        "battery"
        "clock"
      ];

      clock = {
        format = "{:%H:%M}";
        tooltip-format = "{:%A, %B %d}";
      };

      battery = {
        format = "{icon} {capacity}%";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
      };

      network = {
        format-wifi = "";
        format-ethernet = "";
        format-disconnected = "";
        tooltip-format = "{ifname}: {ipaddr}";
      };

      style = ''
        * {
          font-size: 12pt;
          font-family: "JetBrainsMono NL Nerd Font";
        }
        window#waybar {
          background: transparent;
          color: @base05;
        }
        .modules-right {
          background: alpha(@base00, 0.6);
          border-radius: 8px;
          padding: 2px 8px;
          margin: 2px;
        }
      '';
    };
  };
}
