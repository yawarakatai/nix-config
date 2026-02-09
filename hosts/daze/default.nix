{
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ../../lib/options.nix
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  # === Boot ===
  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };
  boot.kernelParams = lib.mkForce [ ];

  # === Hardware ===
  hardware.raspberry-pi."4".fkms-3d.enable = false;

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # === Locale ===
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # === User ===
  my.user.name = "yawarakatai";

  users.mutableUsers = false;
  users.users.yawarakatai = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.bash;
    hashedPassword = "$6$/JCsg6Ab3cxB4wWV$4xFaUJGPbaxFw2inJ1Z6KJ.9w5aHg3JnRTHoGUeH62Rbmjja5shQvY6mGG0K5yjMBz1ejnu9QHr5i3MtC.Qr30";
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKoUC9mEqLf9q8geELb89t8I9P+0JBD2fvm51+jwNuu3AAAABHNzaDo= yubikey_5"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFwdOpc6zvMiZ0zC/NqC2mzEn0B5hdRz1jD2V76vsclLAAAABHNzaDo= yubikey_5c"
    ];
  };
  users.users.root.hashedPassword = "!";

  # === SSH ===
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # === Tailscale ===
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both"; # exit node + subnet router
  };

  # IP forwarding（for exit node）
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # === Docker ===
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # === Containers ===
  virtualisation.oci-containers = {
    backend = "docker";

    containers = {
      vaultwarden = {
        image = "vaultwarden/server:latest";
        ports = [ "8080:80" ];
        volumes = [ "/var/lib/vaultwarden:/data" ];
        environment = {
          SIGNUPS_ALLOWED = "true";
        };
      };

      uptime-kuma = {
        image = "louislam/uptime-kuma:1";
        ports = [ "3001:3001" ];
        volumes = [ "/var/lib/uptime-kuma:/app/data" ];
      };

      adguard = {
        image = "adguard/adguardhome:latest";
        ports = [
          "3000:3000" # setup ui
          "8053:80" # dashboard
          "53:53/tcp" # DNS
          "53:53/udp" # DNS
        ];
        volumes = [
          "/var/lib/adguard/work:/opt/adguardhome/work"
          "/var/lib/adguard/conf:/opt/adguardhome/conf"
        ];
      };

      homeassistant = {
        image = "ghcr.io/home-assistant/home-assistant:stable";
        volumes = [
          "/var/lib/homeassistant:/config"
          "/run/dbus:/run/dbus:ro" # Bluetooth
        ];
        extraOptions = [
          "--network=host" # mDNS, searching devices
          "--privileged" # USB, Bluetooth access
        ];
        environment = {
          TZ = "Asia/Tokyo";
        };
      };
    };
  };

  # === Tailscale Serve ===
  systemd.services.tailscale-serve = {
    description = "Tailscale Serve configuration";
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    path = [
      pkgs.tailscale
      pkgs.jq
    ];

    script = ''
      until tailscale status --json 2>/dev/null | jq -e '.Self.Online' > /dev/null 2>&1; do
        sleep 2
      done
      tailscale serve reset || true
      tailscale serve --bg --https 443 8080
      tailscale serve --bg --https 3001 3001
      tailscale serve --bg --https 3000 3000
      tailscale serve --bg --https 8123 8123
    '';
  };

  # === systemd-resolved dns port collision avoidance ===
  # because AdGuard Home uses port 53
  services.resolved = {
    enable = true;

    settings = {
      Resolve = {
        DNSSEC = "allow-downgrade";
        DNSStubListener = "no";
        FallbackDNS = [
          "9.9.9.9"
          "149.112.112.112"
        ];
      };
    };
  };

  # === Firewall ===
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ 53 ]; # AdGuard DNS
    allowedTCPPorts = [ 53 ];
  };

  # === Packages ===
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    htop
    lm_sensors
  ];

  system.stateVersion = "25.05";
}
