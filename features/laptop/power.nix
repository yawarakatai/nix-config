# TLP - Power management for laptops
{ ... }:

{
  services.tlp = {
    enable = true;
    settings = {
      # Battery thresholds (stop charging early to reduce heat)
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;

      # CPU — use schedutil + disable boost on AC to prevent thermal runaway
      CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_BOOST_ON_AC = 0;
      CPU_BOOST_ON_BAT = 0;
      CPU_MAX_PERF_ON_AC = 90;
      CPU_MAX_PERF_ON_BAT = 80;
      CPU_HWP_DYN_BOOST_ON_AC = 0;

      # Platform
      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";
      NMI_WATCHDOG = 0;

      # PCIe — enable powersave on AC too
      PCIE_ASPM_ON_AC = "powersupersave";
      PCIE_ASPM_ON_BAT = "powersupersave";
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";

      # Peripherals
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
      SOUND_POWER_SAVE_ON_AC = 1;
      SOUND_POWER_SAVE_ON_BAT = 1;
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_BTUSB = 1;
      USB_EXCLUDE_PHONE = 1;
      WOL_DISABLE = "Y";

      # ThinkPad
      NATACPI_ENABLE = 1;
      TPACPI_ENABLE = 1;
      TPSMAPI_ENABLE = 1;
    };
  };

  services.power-profiles-daemon.enable = false;
}
