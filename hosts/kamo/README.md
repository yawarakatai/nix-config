# kamo

`kamo` automatically logs into Jovian Gaming Mode for Steam Remote Play.

- Steam's **Switch to Desktop** opens Niri; logging out (`Mod+Escape`) returns
  to Gaming Mode.
- Both sessions prefer the internal `eDP-1` display; external displays remain
  available. Niri places the external display above the internal panel.
- The external `DP-2` runs a custom 3840x2160@120 mode at the default bit
  depth. Its `max-bpc 10` was dropped in November 2026 because niri has no
  `max-bpc` in any release up to v26.04 (verified: `niri validate` 26.04
  rejects it); add it back to `my.display.outputs` once a release supports it
  and 10-bit is wanted again.
- Set the charging limit in Steam's UI; no boot/resume service forces it to 80%.
- Steam's vendor short-session auto-repair is inhibited: quick desktop switches
  can trigger it and overwrite the self-updated client with an old bootstrap.
  NixOS generation rollback does not roll back Steam's files in the home directory.

Both modes share the same account and files. Autologin bypasses login-password
entry. Keep long-running agents in tmux or on another host to survive logout.
