{ config, pkgs, vars, ... }:

{
  # Kernel module configuration for keyboards
  # Primarily for Lofree Flow keyboard to fix Fn key behavior on Linux

  boot.extraModprobeConfig = ''
    # Lofree Flow keyboard Fn mode fix
    # fnmode=2 means Fn lock is on by default:
    #   - F1-F12 keys work as standard function keys (F1, F2, etc.)
    #   - Media controls require pressing Fn + F-key
    # fnmode=1 would make media controls default instead
    options hid_apple fnmode=2

    # ISO layout fix (uncomment if your keyboard has ISO layout but is detected as ANSI)
    # This fixes keys like the less-than key being swapped
    # options hid_apple iso_layout=1
  '';

  # Note: After applying this configuration:
  # 1. Run: sudo nixos-rebuild switch
  # 2. Reboot your system for the changes to take effect
  # 3. For Lofree Flow: Ensure keyboard is in MacOS/iOS mode (Fn + M)
  # 4. You can switch back to Windows/Android mode with Fn + N if needed
}
