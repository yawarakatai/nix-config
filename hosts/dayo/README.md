# dayo

`dayo` is the home router and backup server. Its exposure and secrets are
covered in [docs/security.md](../../docs/security.md#dayo).

## Network

- **Uplink:** IPv6 IPoE with DS-Lite for IPv4; the AFTR address is in
  `system.nix`. Inbound IPv4 cannot reach the home behind the AFTR. Only one
  DS-Lite B4 works per line: testing `dayo` behind another DS-Lite router
  stalls IPv4.
- **LAN IPv6:** none. The line (FLET'S Next without Hikari Denwa) advertises one
  /64 for the WAN and delegates no prefix, so the LAN is IPv4-only and reaches
  the internet through the tunnel. Its RA sets only the other-configuration flag,
  so if the line later delegates a prefix, the WAN needs `DHCPv6Client =
  "always"` to request it.
- **DNS:** `dayo` resolves through Cloudflare's malware-blocking service, then
  Quad9 (which also blocks malware) if Cloudflare fails, over DNS over TLS on
  native IPv6 with DNSSEC validation, so DNS keeps working if the tunnel fails.
  It ignores the NGN's resolvers, which strip DNSSEC signatures and make
  validation fail; only they resolve the AFTR's name, whose address is pinned
  instead. If no upstream answers over TLS, nothing resolves: SSH to
  `192.168.1.1` still works, so roll back from there.
- **Time:** TLS certificate checks need a correct clock, so time sync starts
  from NICT's IPv6 addresses and needs no DNS. The RTC has no backup battery:
  after a power loss the clock reads 2080, and DNS fails until time sync
  corrects it, about 25 seconds after boot.
- **Radio:** the onboard RTL8852BE Wi-Fi has no Japanese radio certification,
  so a devicetree overlay in `hardware.nix` switches its slot off, which also
  removes the module's USB Bluetooth. The UEFI firmware's own devicetree leaves
  the slot on, so systemd-boot loads the kernel's devicetree with the overlay
  instead; the Wi-Fi drivers stay blacklisted in case a boot entry without it
  is chosen.

## Recovery

A hardware watchdog resets a hung system within 30 to 44 seconds (the SoC
rounds systemd's 30-second timeout up to 44), and the kernel is LTS. The
journal in `/var/log` survives reboots, so `journalctl -b -1` shows the boot
before.

### Consoles

A login console runs on the debug UART (`ttyS2`, 1500000 baud, 3.3 V), which
also shows the firmware and the boot menu. Connect GND, cross TX and RX, and
leave VCC unconnected. Plug the adapter into USB before wiring it, and do not
leave it wired but unpowered: noise on RX can stop the boot menu countdown.

```bash
nix shell nixpkgs#picocom -c picocom -b 1500000 /dev/ttyUSB0  # Ctrl-a Ctrl-x exits
```

HDMI with a USB keyboard gives another login console.

### No internet

A working boot shows `wan` with a global IPv6 address, `dslite` with
`192.0.0.2/29`, and `lan` with `192.168.1.1/24` in `ip -br addr`.

- The WAN link is up only while nftables is active (`wan-up.service`). If the
  firewall fails to load, the WAN stays down and the LAN stays up: SSH to
  `192.168.1.1`, fix it, and `sudo systemctl start nftables`, which brings the
  WAN back. `systemctl status wan-up nftables` shows which failed.
- `system.nix` names the NICs `wan` and `lan` by their permanent MAC addresses.
  Other names, such as `enP3p49s0`, mean the match failed, for example after the
  board was replaced, and the router configuration then applies to no
  interface.
- If addresses work but names do not resolve, check the clock (see Time).

### Rolling back

Choose an earlier generation in the boot menu. Entries are named
`nixos-<hash>.conf`, not by generation number, so read `bootctl list` before
passing one to `bootctl set-default` or `set-oneshot`.

Before connecting the previous router to the ONU, unplug `dayo`'s WAN, and the
reverse when switching back, since only one DS-Lite B4 works per line (see
Uplink).

## Storage

`/` is a tmpfs, so everything outside `/nix`, home directories included, is
lost at every reboot. `/nix` on the BC711 holds the store and `/nix/persist`,
which keeps only the state listed in `modules/storage/ephemeral-root.nix`, such
as the SSH host key that agenix decrypts with. A file edited by hand lasts until
the next reboot; declare the change instead. Logins use bash, which needs no
files in the home directory.

## Updates and deployment

There are no unattended upgrades. Periodically run `nix flake update`, review
`git diff flake.lock`, run `nix flake check --all-systems` (which includes the
router VM test), deploy, and roll back to the previous generation if routing
breaks. Keep the previous router available as a fallback.

Build on `dayo` itself, because only `root` is a trusted Nix user, but deploy
from another host, since a checkout on `dayo` is lost at reboot:

```bash
nixos-rebuild switch --flake .#dayo --target-host dayo --build-host dayo --ask-sudo-password
```

Devicetree and interface-name changes take effect only at boot: deploy them
with `nixos-rebuild boot` instead of `switch`, then reboot with a console
attached.

Reinstalling formats every disk in the layout, including the backup disk.

## Backups

Each client has a borg repository under `/srv/backup` on the SN770, limited by
a quota in `system.nix`. The disk mounts with `nofail`, and the monthly
`borgbackup-check` verifies the repositories. Pruning frees space only after
`borg compact` runs on `dayo`.

`modules/services/backup-client.nix` backs up `/home` daily but is not imported
yet. To enable it, import it in `modules/profiles/system/desktop.nix`, then run
`agenix generate` and `agenix rekey`.
