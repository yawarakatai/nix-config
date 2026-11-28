# desuwa

`desuwa` hosts Steam Remote Play from boot for `kamo` and the Steam Frame. Steam
runs only as the `steamhost` user, in a headless gamescope
(`modules/gaming/headless-host.nix`): nobody logs in, no display or dummy plug
is needed, and nothing appears on the desktop. Games cannot be played on the
local monitor.

## Status

- Verified (manually, as the desktop user, before `steamhost` existed): a
  headless gamescope stream to `kamo` ran at 60 FPS with NVENC H.264, about
  2 ms ping and 3 ms encode, once `kamo` opened its Remote Play ports.
- Verified: `steamhost-gui steam` shows Steam on the desktop, and the steps of
  `steamhost-login` (run as a standalone script) quit the login Steam and leave
  only the headless one running.
- Not yet verified as `steamhost`: the stream, Steam Frame VR and its adapter,
  controller input, and audio. The
  `input`, `uinput`, `networkmanager` groups and the Valve USB rule are there
  because seat ACLs never reach this user.
- Decided: Beat Saber mods and maps are managed with BSManager running as
  `steamhost` on the desktop (`steamhost-gui bs-manager`); Beat Saber itself is
  launched through the headless Steam.

Trade-off: the `input` group lets Steam and its games read every input device,
including the desktop keyboard; the desktop Steam had the same access.

## Operate

```sh
sudo systemctl --user -M steamhost@ status steam-headless
sudo journalctl _SYSTEMD_USER_UNIT=steam-headless.service -b
```

Exiting Steam from a client restarts it after 5 seconds.

`steamhost-gui <program>` shows a `steamhost` program on the desktop session
(it allows `steamhost` on the X display only while the program runs).

## Log in to Steam

Steam needs one interactive login (and again whenever its session expires):

```sh
steamhost-login
```

It stops the headless Steam, shows a login Steam on the desktop, and after
Enter in the terminal quits it and starts the headless one again. Closing the
Steam window does not quit Steam, so do not run `steamhost-gui steam`.

## BSManager

```sh
steamhost-gui bs-manager
```

The headless Steam may keep running. Add maps from BSManager's own map browser:
BeatSaver's OneClick links open in the desktop user's browser and cannot reach
`steamhost`'s BSManager.

