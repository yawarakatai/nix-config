{ config, pkgs, theme, vars, ... }:

{
  programs.eww = {
    enable = true;
    package = pkgs.eww;
  };

  # Create the eww configuration directory structure
  xdg.configFile = {
    # Main eww configuration file
    "eww/eww.yuck".text = let
      # Helper to create eww variable references
      v = name: "$" + "{" + name + "}";
    in ''
      ;; Variables for system info
      (defpoll time :interval "1s"
        "date '+%H:%M:%S'")

      (defpoll date :interval "10s"
        "date '+%Y-%m-%d %A'")

      (defpoll cpu_usage :interval "2s"
        "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1}'")

      (defpoll memory_usage :interval "2s"
        "free -m | grep Mem | awk '{printf \"%.0f\", ($3/$2) * 100}'")

      (defpoll temperature :interval "2s"
        "sensors | grep 'Package id 0:' | awk '{print $4}' | sed 's/+//;s/°C//' || echo '0'")

      (defpoll wifi_ssid :interval "5s"
        "nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2 || echo 'Disconnected'")

      (defpoll volume :interval "1s"
        "pamixer --get-volume")

      (defpoll volume_muted :interval "1s"
        "pamixer --get-mute")

      ;; Dashboard window
      (defwindow dashboard
        :monitor 0
        :geometry (geometry :x "20px"
                           :y "20px"
                           :width "400px"
                           :height "600px"
                           :anchor "top left")
        :stacking "overlay"
        :exclusive false
        :focusable true
        (dashboard_widget))

      ;; Main dashboard widget
      (defwidget dashboard_widget []
        (box :class "dashboard"
             :orientation "v"
             :space-evenly false
             :spacing 16

          ;; Header with time
          (box :class "header"
               :orientation "v"
               :space-evenly false
               :spacing 4
            (label :class "time" :text time)
            (label :class "date" :text date))

          ;; System info section
          (box :class "section"
               :orientation "v"
               :space-evenly false
               :spacing 12

            (label :class "section-title" :text "System")

            ;; CPU
            (box :class "info-row"
                 :orientation "h"
                 :space-evenly false
                 :spacing 8
              (label :class "info-label" :text "CPU")
              (label :class "info-value" :text "${v "cpu_usage"}%"))

            ;; Memory
            (box :class "info-row"
                 :orientation "h"
                 :space-evenly false
                 :spacing 8
              (label :class "info-label" :text "RAM")
              (label :class "info-value" :text "${v "memory_usage"}%"))

            ;; Temperature
            (box :class "info-row"
                 :orientation "h"
                 :space-evenly false
                 :spacing 8
              (label :class "info-label" :text "TEMP")
              (label :class "info-value" :text "${v "temperature"}°C")))

          ;; Network section
          (box :class "section"
               :orientation "v"
               :space-evenly false
               :spacing 12

            (label :class "section-title" :text "Network")

            (box :class "info-row"
                 :orientation "h"
                 :space-evenly false
                 :spacing 8
              (label :class "info-label" :text "WiFi")
              (label :class "info-value" :text wifi_ssid)))

          ;; Audio section
          (box :class "section"
               :orientation "v"
               :space-evenly false
               :spacing 12

            (label :class "section-title" :text "Audio")

            (box :class "info-row"
                 :orientation "h"
                 :space-evenly false
                 :spacing 8
              (label :class "info-label" :text "Volume")
              (label :class "info-value" :text "${v "volume"}%")))))
    '';

    # SCSS styling
    "eww/eww.scss".text = ''
      * {
        all: unset;
        font-family: "${theme.font.family}";
        font-size: ${toString theme.font.size}px;
      }

      .dashboard {
        background-color: ${theme.colorScheme.base00};
        border: ${toString theme.border.width}px solid ${theme.border.color};
        border-radius: ${toString theme.rounding}px;
        padding: 24px;
        opacity: ${toString theme.opacity.bar};
      }

      .header {
        padding: 16px;
        background-color: ${theme.colorScheme.base01};
        border-radius: ${toString theme.rounding}px;
        margin-bottom: 8px;
      }

      .time {
        font-size: ${toString (theme.font.size * 2)}px;
        font-weight: bold;
        color: ${theme.semantic.keyword};
      }

      .date {
        font-size: ${toString (theme.font.size + 2)}px;
        color: ${theme.colorScheme.base05};
        margin-top: 4px;
      }

      .section {
        padding: 16px;
        background-color: ${theme.colorScheme.base01};
        border-radius: ${toString theme.rounding}px;
      }

      .section-title {
        font-size: ${toString (theme.font.size + 2)}px;
        font-weight: bold;
        color: ${theme.semantic.variable};
        margin-bottom: 8px;
      }

      .info-row {
        padding: 8px 0;
      }

      .info-label {
        color: ${theme.colorScheme.base04};
        min-width: 80px;
      }

      .info-value {
        color: ${theme.semantic.success};
        font-weight: bold;
      }
    '';
  };
}
