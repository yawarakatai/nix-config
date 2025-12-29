# Helper functions for creating consistent module options
# This provides a standardized way to make modules configurable
{ lib, ... }:

with lib;

{
  # Create a standard enable option for a module
  mkEnableOption =
    name: description:
    mkOption {
      type = types.bool;
      default = false;
      description = "Enable ${description}";
    };

  # Create an option with a default value
  mkDefaultOption =
    type: default: description:
    mkOption {
      inherit type default description;
    };

  # Create a nullable option (can be set to null)
  mkNullableOption =
    type: description:
    mkOption {
      type = types.nullOr type;
      default = null;
      description = description;
    };
}
