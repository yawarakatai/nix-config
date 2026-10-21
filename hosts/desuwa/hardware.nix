{ config, pkgs, ... }:

let
  # Work around the packaged nvidia-smi's read-only mapping of PT_DYNAMIC:
  # glibc writes DT_DEBUG there during startup. Remove when fixed upstream.
  nvidiaSmi =
    pkgs.runCommand "nvidia-smi-writable-dynamic" { nativeBuildInputs = [ pkgs.python3 ]; }
      ''
        mkdir -p "$out/bin"
        python3 - "${config.hardware.nvidia.package.bin}/bin/nvidia-smi" "$out/bin/nvidia-smi" <<'PY'
        import struct
        import sys
        from pathlib import Path

        data = bytearray(Path(sys.argv[1]).read_bytes())
        if data[:6] != b"\x7fELF\x02\x01":
            raise SystemExit("Expected a little-endian ELF64 nvidia-smi")
        offset = struct.unpack_from("<Q", data, 32)[0]
        size, count = struct.unpack_from("<HH", data, 54)
        headers = [
            (offset + i * size, struct.unpack_from("<IIQQQQQQ", data, offset + i * size))
            for i in range(count)
        ]
        dynamic = next(header[3] for _, header in headers if header[0] == 2)
        for position, header in headers:
            if header[0] == 1 and header[3] <= dynamic < header[3] + header[6]:
                struct.pack_into("<I", data, position + 4, header[1] | 2)
        Path(sys.argv[2]).write_bytes(data)
        PY
        chmod +x "$out/bin/nvidia-smi"
      '';
in
{
  imports = [
    ../../modules/hardware/gpu/nvidia.nix
    ../../modules/input/mouse/logiops.nix
    ../../modules/input/keyboard/lofree.nix
  ];

  # Keep the factory-overclocked RTX 3080 near its best gaming efficiency point.
  systemd.services.nvidia-power-limit = {
    description = "Set NVIDIA GPU power limit";
    # A driver upgrade cannot work with the already loaded kernel module until reboot.
    restartIfChanged = false;
    after = [ "systemd-modules-load.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${nvidiaSmi}/bin/nvidia-smi --id=0 --power-limit=320";
      RemainAfterExit = true;
    };
  };
}
