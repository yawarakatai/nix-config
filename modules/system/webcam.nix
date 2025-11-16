{ config, lib, pkgs, ... }:

{
  # Enable webcam support - load multiple kernel modules for different camera types
  boot.kernelModules = [
    "uvcvideo" # USB Video Class (UVC) cameras
    "videobuf2-core" # Video buffer support
    "videobuf2-v4l2" # V4L2 video buffer
    "videobuf2-memops" # Memory operations for video buffers
  ];

  # Enable all firmware including Intel camera firmware
  hardware.enableAllFirmware = true;
  hardware.firmware = with pkgs; [
    linux-firmware # General firmware including Intel camera firmware
  ];

  # Kernel parameters for Intel IPU6 cameras (11th gen and newer Intel CPUs)
  # These cameras need special drivers and firmware
  boot.kernelParams = [
    # Enable media controller API for complex camera pipelines
    "intel_ipu6.dyndbg=+p"
  ];

  # Extra kernel modules for Intel IPU6 support
  boot.extraModulePackages = with config.boot.kernelPackages; [
    # Add IPU6 drivers if available in kernel
  ];

  # Load camera-related modules early
  boot.initrd.kernelModules = [ ];

  # Webcam utilities and debugging tools
  environment.systemPackages = with pkgs; [
    v4l-utils # Video4Linux utilities (v4l2-ctl, v4l2-compliance)
    # guvcview # GTK webcam application for testing
    libcamera # Modern camera stack (better for complex cameras)
    ffmpeg # For camera testing and recording
    # gstreamer      # Media framework with camera support
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good # Includes v4l2 plugin
  ];

  # Ensure proper permissions for video devices
  users.groups.video = { };

  # Comprehensive udev rules for camera devices
  services.udev.extraRules = ''
    # Standard webcam permissions
    KERNEL=="video[0-9]*", GROUP="video", MODE="0660"

    # Intel IPU6 devices
    SUBSYSTEM=="intel-ipu6", GROUP="video", MODE="0660"

    # Media devices (for complex camera pipelines)
    KERNEL=="media[0-9]*", GROUP="video", MODE="0660"

    # V4L subdevices
    KERNEL=="v4l-subdev[0-9]*", GROUP="video", MODE="0660"
  '';

  # Enable libcamera service if needed
  # services.pipewire.enable includes camera support through libcamera
}
