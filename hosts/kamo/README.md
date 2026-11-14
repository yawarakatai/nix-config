# kamo

`kamo` automatically logs into Jovian Gaming Mode for Steam Remote Play.

- Steam's **Switch to Desktop** opens Niri; logging out (`Mod+Escape`) returns
  to Gaming Mode.
- Both sessions prefer the internal `eDP-1` display; external displays remain
  available. Niri places the external display to the right of the internal panel.
- Set the charging limit in Steam's UI; no boot/resume service forces it to 80%.
- Steam's vendor short-session auto-repair is inhibited: quick desktop switches
  can trigger it and overwrite the self-updated client with an old bootstrap.
  NixOS generation rollback does not roll back Steam's files in the home directory.
- Noctalia uses an agenix storage key because autologin cannot unlock the login
  keyring. Changing this key does not migrate existing encrypted history.

Both modes share the same account and files. Autologin bypasses login-password
entry. Keep long-running agents in tmux or on another host to survive logout.
