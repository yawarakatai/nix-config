{ config, pkgs, vars, ... }:

{
  # TLP - Advanced power management for Linux laptops
  # Provides battery optimization, charge thresholds, and power profiles

  services.tlp = {
    enable = true;

    settings = {
      # Battery charge thresholds (helps extend battery lifespan)
      # Stop charging at 80% when on AC, start charging below 75%
      START_CHARGE_THRESH_BAT0 = 80;
      STOP_CHARGE_THRESH_BAT0 = 95;

      # CPU scaling governor
      # On AC: performance, On battery: powersave
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # CPU energy/performance policy (Intel)
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # CPU boost
      # Allow turbo boost on AC, disable on battery to save power
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;

      CPU_MAX_PERF_ON_AC = 100;
      CPU_MAX_PERF_ON_BAT = 80;

      # Platform profile (for modern Intel/AMD laptops)
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # Kernel laptop mode
      NMI_WATCHDOG = 0;

      # PCIe Active State Power Management (ASPM)
      PCIE_ASPM_ON_AC = "performance";
      PCIE_ASPM_ON_BAT = "powersupersave";

      # Runtime Power Management for PCI(e) devices
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";

      # WiFi power saving
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # Sound card power management
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;

      # Enable USB autosuspend (but exclude input devices)
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_BTUSB = 1;
      USB_EXCLUDE_PHONE = 1;

      # Disable wake on LAN
      WOL_DISABLE = "Y";

      # Battery feature drivers (ThinkPad specific)
      NATACPI_ENABLE = 1;
      TPACPI_ENABLE = 1;
      TPSMAPI_ENABLE = 1;
    };
  };

  # Ensure TLP doesn't conflict with other power management services
  services.power-profiles-daemon.enable = false;
}
