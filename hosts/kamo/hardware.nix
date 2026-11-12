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

  # LB/RB switches are broken on this unit, so M2/M1 take over their role.
  # With mainline hid-asus, InputPlumber cannot program the MCU, which then
  # reports both back buttons as the same key. Program them as F17/F18 the way
  # Handheld Daemon does; the trailing commands make the MCU apply the mapping.
  systemd.services.ally-back-buttons = {
    description = "Program ROG Ally M1/M2 as F18/F17";
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.writers.writePython3 "ally-back-buttons" { } ''
        import glob
        import os
        import sys


        def buf(x):
            return bytes(x) + bytes(64 - len(x))


        def key(k):
            return [0x02, 0x00, k] + [0] * 8


        EMPTY = [0] * 11
        CMDS = [
            # Back button pair: M2 (left) -> F17, M1 (right) -> F18.
            buf([0x5A, 0xD1, 0x02, 0x08, 0x2C]
                + key(0x28) + EMPTY + key(0x30) + EMPTY),
            buf([0x5A, 0xD1, 0x0F, 0x20]),
            buf([0x5A, 0xD1, 0x06, 0x02, 0x64, 0x64]),
            buf([0x5A, 0xD1, 0x04, 0x04, 0x00, 0x40, 0x00, 0x40]),
            buf([0x5A, 0xD1, 0x05, 0x04, 0x00, 0x40, 0x00, 0x40]),
        ]

        for d in glob.glob("/sys/class/hidraw/hidraw*/device"):
            # The MCU config endpoint is USB interface 2.
            if not os.path.dirname(os.path.realpath(d)).endswith(":1.2"):
                continue
            with open(f"{d}/uevent") as f:
                if "00000B05:00001ABE" not in f.read().upper():
                    continue
            with open("/dev/" + d.split("/")[4], "wb", buffering=0) as f:
                for cmd in CMDS:
                    f.write(cmd)
            sys.exit(0)

        sys.exit("ROG Ally MCU hidraw device not found")
      ''}
    '';
  };
  # Rerun whenever the controller (re)appears, e.g. after resume.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0b05", ATTRS{idProduct}=="1abe", TAG+="systemd", ENV{SYSTEMD_WANTS}+="ally-back-buttons.service"
  '';

  # A later-sorted map with the same id replaces upstream's `aly1`. F17 is
  # upstream's Armory Crate long press, which M2 takes over.
  environment.etc."inputplumber/capability_maps.d/zz-ally_type1-bumpers.yaml".source =
    pkgs.runCommand "ally-type1-bumpers.yaml" { }
      ''
        substitute ${config.services.inputplumber.package.src}/rootfs/usr/share/inputplumber/capability_maps/ally_type1.yaml $out \
          --replace-fail "button: QuickAccess2" "button: LeftBumper" \
          --replace-fail "keyboard: KeyF15" "keyboard: KeyF18" \
          --replace-fail "button: RightPaddle1" "button: RightBumper"
      '';

  imports = [
    inputs.nixos-hardware.nixosModules.asus-ally-rc71l
    ../../modules/input/mouse/logiops.nix
    ../../modules/input/keyboard/lofree.nix
  ];
}
