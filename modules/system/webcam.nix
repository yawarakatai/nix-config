{ config, lib, pkgs, ... }:

{
  # Enable webcam support
  boot.kernelModules = [ "uvcvideo" ];

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
