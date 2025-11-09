# Example Module Template
# This template demonstrates best practices for creating new modules
# Copy this file and modify it for your needs

{ config, lib, pkgs, theme, vars, ... }:

# Import shared libraries if needed
let
  # Example: Import terminal colors if this is a terminal-related module
  # termColors = import ../../../lib/terminal-colors.nix { inherit theme; };

  # Example: Import module option helpers
  # opts = import ../../../lib/module-options.nix { inherit lib; };
in

{
  # ============================================================================
  # Module Options (if this module needs to be configurable)
  # ============================================================================
  # Uncomment this section if you want to make this module configurable
  #
  # options.myModule = {
  #   enable = lib.mkOption {
  #     type = lib.types.bool;
  #     default = true;  # or false if it should be opt-in
  #     description = "Enable my awesome module";
  #   };
  #
  #   extraOption = lib.mkOption {
  #     type = lib.types.str;
  #     default = "default-value";
  #     description = "An extra configuration option";
  #   };
  # };

  # ============================================================================
  # Module Configuration
  # ============================================================================
  # Uncomment this if you added options above
  # config = lib.mkIf config.myModule.enable {

  # Program configuration
  programs.myprogram = {
    enable = true;

    settings = {
      # ========================================================================
      # Theme Integration
      # ========================================================================
      # Always use theme values instead of hard-coding colors
      # Good examples:
      background = theme.colorScheme.base00;
      foreground = theme.colorScheme.base05;
      accent = theme.semantic.info;

      # Bad examples (don't do this):
      # background = "#000000";  # Hard-coded!
      # foreground = "#ffffff";  # Hard-coded!

      # ========================================================================
      # Font Configuration
      # ========================================================================
      # Use theme font settings
      font = {
        family = theme.font.name;
        size = theme.font.size;
      };

      # For Japanese support:
      # font.family = theme.font.family;  # Includes CJK fallback

      # ========================================================================
      # Host-Specific Values
      # ========================================================================
      # Use vars for host-specific configuration
      # Examples:
      # username = vars.username;
      # timezone = vars.timezone;
      # monitor = vars.monitors.primary.name;

      # ========================================================================
      # Opacity and Visual Settings
      # ========================================================================
      # Use theme opacity values
      opacity = theme.opacity.terminal;  # or .bar, .launcher, .notification

      # Use theme border settings
      # border.width = theme.border.width;
      # border.color = theme.border.color;

      # ========================================================================
      # Additional Settings
      # ========================================================================
      # Add your program-specific settings here
      # Try to organize them logically with comments
    };
  };

  # If you added options, close the config block:
  # };

  # ============================================================================
  # Additional Packages (if needed)
  # ============================================================================
  # Uncomment if your module needs additional packages
  # home.packages = with pkgs; [
  #   some-package
  #   another-package
  # ];
}

# ============================================================================
# Checklist for New Modules
# ============================================================================
#
# [ ] Use theme.* for all colors (never hard-code)
# [ ] Use theme.font.* for font configuration
# [ ] Use theme.opacity.* for transparency
# [ ] Use vars.* for host-specific values
# [ ] Add descriptive comments explaining settings
# [ ] Group related settings together
# [ ] Consider adding module options if it should be configurable
# [ ] Test with different themes to ensure no hard-coded values
# [ ] Update hosts/desuwa/home.nix to import your module
# [ ] Consider whether this should be enabled by default or opt-in
#
