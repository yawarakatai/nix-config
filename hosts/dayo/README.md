# dayo

`dayo` is the home router and backup server. Its exposure and secrets are
covered in [docs/security.md](../../docs/security.md#dayo).

## Network

- **Uplink:** IPv6 IPoE with DS-Lite for IPv4; the AFTR address is in
  `system.nix`. Inbound IPv4 cannot reach the home behind the AFTR. Only one
  DS-Lite B4 works per line: testing `dayo` behind another DS-Lite router
  stalls IPv4.
- **DNS:** `dayo` resolves through Cloudflare's malware-blocking service, then
  Quad9 (which also blocks malware) if Cloudflare fails, over DNS over TLS on
  native IPv6 with DNSSEC validation, so DNS keeps working if the tunnel fails. It ignores the NGN's resolvers, which strip DNSSEC
  signatures and make validation fail; only they resolve the AFTR's name, whose
  address is pinned instead. If no upstream answers over TLS, nothing resolves:
  SSH to `192.168.1.1` still works, so roll back from there.
- **Ad blocking:** LAN clients query blocky on `192.168.1.1`, which answers
  NXDOMAIN for domains on HaGeZi's Pro list, their subdomains, and names whose
  CNAMEs lead to them, and passes everything else to resolved. The list is the
  `hagezi-pro` flake input, so it changes with `nix flake update`. To unblock a
  domain, set `blocking.allowlists.ads = [ "example.com\n" ];` in
  `modules/services/router.nix`; without a newline, blocky reads the string as a
  file path.
  DNS-level blocking cannot remove ads served from the same domain as the
  content, as on YouTube.
- **Time:** TLS certificate checks need a correct clock, so time sync starts
  from NICT's IPv6 addresses and needs no DNS.
- **Radio:** the onboard RTL8852BE Wi-Fi has no Japanese radio certification,
  so its drivers are blacklisted.

## Recovery

A hardware watchdog reboots a hung system after 30 seconds, the kernel is LTS,
and a login console runs on the debug UART (`ttyS2`, 1500000 baud, 3.3 V). Do
not leave a USB serial adapter wired but unpowered: noise on RX can stop the
boot menu countdown.

The WAN link is up only while nftables is active (`wan-up.service`). If the
firewall fails to load, the WAN stays down and the LAN stays up: SSH to
`192.168.1.1`, fix it, and `sudo systemctl start nftables`, which brings the
WAN back.

## Storage

`/` is a tmpfs, so everything outside `/nix`, home directories included, is
lost at every reboot. `/nix` on the BC711 holds the store and `/nix/persist`,
which keeps only the state listed in `modules/storage/ephemeral-root.nix`, such
as the SSH host key that agenix decrypts with. A file edited by hand lasts until
the next reboot; declare the change instead.

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

Reinstalling formats every disk in the layout, including the backup disk.

## Backups

Each client has a borg repository under `/srv/backup` on the SN770, limited by
a quota in `system.nix`. The disk mounts with `nofail`, and the monthly
`borgbackup-check` verifies the repositories. Pruning frees space only after
`borg compact` runs on `dayo`.

`modules/services/backup-client.nix` backs up `/home` daily but is not imported
yet. To enable it, import it in `modules/profiles/system/desktop.nix`, then run
`agenix generate` and `agenix rekey`.
