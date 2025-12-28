{ ... }:

{
  # Touchpad configuration for laptops
  # Note: For Wayland compositors like niri, touchpad gestures
  # are typically configured in the compositor itself

  # Enable libinput for touchpad support
  services.libinput = {
    enable = true;

    touchpad = {
      # Natural scrolling (reversed)
      naturalScrolling = true;

      # Tap to click
      tapping = true;

      # Disable while typing
      disableWhileTyping = true;

      # Scrolling method
      scrollMethod = "twofinger";

      # Acceleration
      accelProfile = "adaptive";
      accelSpeed = "0.5";

      # Middle button emulation (click both buttons)
      middleEmulation = true;
    };
  };
}
