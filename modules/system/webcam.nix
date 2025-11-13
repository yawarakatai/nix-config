{ config, lib, pkgs, ... }:

{
  # Enable webcam support
  boot.kernelModules = [ "uvcvideo" ];

  # Enable firmware for Intel cameras (IPU6 support for 11th gen and newer)
  hardware.enableAllFirmware = true;
  hardware.firmware = with pkgs; [
    linux-firmware  # General firmware including Intel camera firmware
  ];

  # For Intel IPU6 cameras (Tiger Lake, Alder Lake, Raptor Lake)
  # The ivsc (Intel Visual Sensing Controller) firmware is needed
  boot.kernelParams = [
    "intel_ipu6.dyndbg=+p"  # Enable IPU6 debug if needed
  ];

  # Add webcam utilities
  environment.systemPackages = with pkgs; [
    v4l-utils  # Video4Linux utilities for webcam control
    guvcview   # GTK webcam application
  ];

  # Ensure proper permissions for video devices
  users.groups.video = {};

  # Add user to video group (configured per host)
  services.udev.extraRules = ''
    # Webcam permissions
    KERNEL=="video[0-9]*", GROUP="video", MODE="0660"
  '';
}
