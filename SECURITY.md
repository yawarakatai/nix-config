# Security

This repository is public. Its security rests on keys held on YubiKeys and on
each host, not on hiding the configuration. This page records the decisions and
procedures that the code alone does not explain.

## YubiKeys

- Two YubiKeys (5 and 5C) are interchangeable: every secret and every
  authorization covers both, so carry one and keep the other as a backup.
- Both have a FIDO2 PIN and **Always Require UV** enabled
  (`ykman fido config toggle-always-uv`; check with `ykman fido info`). Every
  FIDO2 operation needs the PIN, including credentials created before the
  setting was enabled. Legacy U2F is disabled as a side effect.
- Eight wrong PIN attempts block FIDO2 until a reset, which destroys every FIDO2
  credential on that key (SSH keys, agenix master, passkeys). Keep the backup
  key's PIN known.

## Secrets (agenix-rekey)

- `secrets/master-key-5.pub` and `secrets/master-key-5c.pub` are
  `age-plugin-fido2-hmac` identities. They contain no secret: decryption needs
  the matching YubiKey, its PIN, and a touch.
- Sources in `secrets/*.age` are encrypted to the post-quantum
  (ML-KEM-768 + X25519) recipients listed in those files, because ciphertexts in
  a public repository can be collected now and decrypted later.
  `modules/security/agenix.nix` selects these recipients, and agenix-rekey's
  rage encrypts to them through `age-plugin-pq` from the `age` package.
- `secrets/rekeyed/<host>/` holds copies encrypted to each host's SSH Ed25519
  key. age has no post-quantum SSH recipient, so treat these as eventually
  decryptable; rotating values bounds the damage.
- Desktops share `user-password`; `dayo` uses `user-password-dayo`, so a
  network-facing host never holds the desktop password hash. Hashes are yescrypt
  (`mkpasswd -m yescrypt`).
- `agenix rekey` skips hosts without
  `hosts/<host>/generated/ssh_host_ed25519_key.pub`; `install-host` creates the
  key and rekeys the host.

### Replace a value

Run `nix develop -c agenix edit secrets/<name>.age`, then
`nix develop -c agenix rekey`. Both need a YubiKey PIN and touch; rekeying may ask
once per secret and host.

`agenix edit -i FILE` refuses to overwrite an existing secret. To replace one
from a file, encrypt it directly, keeping the plaintext on tmpfs
(`$XDG_RUNTIME_DIR`):

```bash
nix shell --inputs-from . nixpkgs#age -c sh -c '
  age -r "$(grep -o "age1pq1[a-z0-9]*" secrets/master-key-5.pub)" \
      -r "$(grep -o "age1pq1[a-z0-9]*" secrets/master-key-5c.pub)" \
      -o "secrets/$1.age" "$2"' _ <name> <plaintext-file>
```

### Replace a master key

Old ciphertexts stay in Git history and still open with the old identity, so
re-encrypting alone protects only future values.

1. Generate a new identity with that YubiKey inserted:
   `age-plugin-fido2-hmac -g > secrets/master-key-<key>.new`. Require a PIN and
   accept a separate identity.
2. Decrypt each source with the old identity and encrypt it to the new
   recipients.
3. Give secrets new values where possible (passwords, tokens), because history
   still holds the old ones.
4. Replace the identity files, run `agenix rekey`, switch every host, and revoke
   the old tokens.

## SSH

- User keys are resident `ed25519-sk` keys, one per YubiKey, created with
  `-O resident -O verify-required -O application=ssh:nix-config`. Their public
  keys are in `secrets/keys.nix`. agenix delivers the key handles to NixOS
  hosts; elsewhere, `ssh-keygen -K` exports them (see `PORTABLE.md`).
- `sshd` accepts public keys only, refuses root, and sets
  `PubkeyAuthOptions verify-required`, so a FIDO key used without a PIN is
  refused. Non-FIDO keys, such as backup clients' host keys, are unaffected.
- Host keys come from `install-host` and survive reinstalls. The SSH client
  pins them in `~/.ssh/known_hosts_managed` with a per-host `HostKeyAlias`, so
  `ssh -o HostKeyAlias=<host> <address>` verifies a host whose DHCP address
  changed. GitHub's key comes from `https://api.github.com/meta`.
- To rotate user keys: create new keys on both YubiKeys with the options above,
  store the handles in `secrets/yubikey-5-sk.age` and `secrets/yubikey-5c-sk.age`
  as in "Replace a value", update `secrets/keys.nix`, add the public keys to
  GitHub, switch every host, then remove the old keys from GitHub and delete the
  old resident credentials (`ykman fido credentials list`, then
  `ykman fido credentials delete <credential-id-prefix>`).

## Nix daemon

- Only `root` is a trusted user (enforced by the `nix-trust` check). Trusted
  users can import unsigned store paths and add substituters, which amounts to
  root without the sudo password.
- A warning that the flake's `trusted-public-keys` setting is ignored is
  expected: the same caches are configured system-wide.
- Deploy `dayo` by building on `dayo`, either with `nh os switch` there or from
  another host:
  `nixos-rebuild switch --flake .#dayo --target-host dayo --build-host dayo --ask-sudo-password`.

## dayo

`dayo` is the home router and backup server.

- **Uplink:** IPv6 IPoE with DS-Lite for IPv4; the AFTR address is in
  `hosts/dayo/system.nix`. Inbound IPv4 cannot reach the home behind the AFTR,
  and new inbound IPv6 connections to the LAN are dropped. Only one DS-Lite B4
  works per line: testing `dayo` behind another DS-Lite router stalls IPv4.
- **DNS:** `dayo` resolves through Cloudflare, then Quad9 if Cloudflare fails,
  over native IPv6 with DNSSEC validation, so DNS keeps working if the tunnel fails. It ignores the
  NGN's resolvers, which strip DNSSEC signatures and make validation fail;
  only they resolve the AFTR's name, whose address is pinned instead.
- **Exposure:** no port opens globally; the firewall admits SSH, DNS, and DHCP
  on the LAN interface only. The `dayo-router-firewall` check enforces this, and the
  `dayo-router` VM test scans every router address from a simulated WAN and
  probes the LAN.
- **Radio:** the onboard RTL8852BE Wi-Fi has no Japanese radio certification,
  so its drivers are blacklisted.
- **Recovery:** a hardware watchdog reboots a hung system after 30 seconds, the
  kernel is LTS, and a login console runs on the debug UART (`ttyS2`, 1500000
  baud, 3.3 V). Do not leave a USB serial adapter wired but unpowered: noise on
  RX can stop the boot menu countdown.
- **Updates:** no unattended upgrades. Periodically run `nix flake update`,
  review `git diff flake.lock`, run `just check` (which includes the VM test),
  deploy, and roll back to the previous generation if routing breaks. Keep the
  previous router available as a fallback.
- **Backups:** each client has an append-only borg repository under
  `/srv/backup` on the SN770, reached through the existing SSH server,
  authenticated by the client's host key, and limited by a quota in
  `hosts/dayo/system.nix`. The disk mounts with `nofail`, and the monthly
  `borgbackup-check` verifies the repositories. Pruning frees space only after
  `borg compact` runs on `dayo`, which also applies deletions a compromised
  client requested, so check the archive list from a client first.
- **Backup clients:** `modules/services/backup-client.nix` backs up `/home`
  daily with `repokey-blake2` encryption, so `dayo` never holds a passphrase.
  Noctalia's clipboard history is excluded, and it is wiped whenever Noctalia
  starts, so copied passwords do not persist across sessions.
  Each host's passphrase is generated by `agenix generate` and encrypted to the
  masters, so a YubiKey recovers it from Git if the client is lost. The module
  pins `dayo`'s host key, so enable it only after `dayo` is installed: import it
  in `modules/profiles/system/desktop.nix`, then run `agenix generate` and
  `agenix rekey`.
- **Reinstalling:** disko formats every disk in the layout, including the backup
  disk.
- **Disk encryption:** none. An unattended router cannot unlock a disk at boot
  and the board has no TPM. Physical theft exposes `dayo`'s host key and
  therefore only `dayo`'s own secrets.
