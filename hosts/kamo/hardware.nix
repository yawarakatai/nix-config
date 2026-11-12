{
  config,
  inputs,
  pkgs,
  ...
}:

{
  # Also enables Jovian's backlight access rule for the Steam brightness slider.
  jovian.hardware.has.amd.gpu = true;

  # The unused IMU keeps InputPlumber polling over I2C even at idle.
  boot.blacklistedKernelModules = [ "bmi323_i2c" ];

  # LB/RB are broken on this unit, so M1/M2 take over their role system-wide.
  # A later-sorted map with the same id replaces upstream's `aly1`.
  environment.etc."inputplumber/capability_maps.d/zz-ally_type1-bumpers.yaml".source =
    pkgs.runCommand "ally-type1-bumpers.yaml" { }
      ''
        substitute ${config.services.inputplumber.package.src}/rootfs/usr/share/inputplumber/capability_maps/ally_type1.yaml $out \
          --replace-fail "button: LeftPaddle1" "button: LeftBumper" \
          --replace-fail "button: RightPaddle1" "button: RightBumper"
      '';

  imports = [
    inputs.nixos-hardware.nixosModules.asus-ally-rc71l
    ../../modules/input/mouse/logiops.nix
    ../../modules/input/keyboard/lofree.nix
  ];
}
