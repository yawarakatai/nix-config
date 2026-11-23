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
- Not yet verified as `steamhost`: the stream, Steam Frame VR and its adapter,
  controller input, audio, and `steamhost-gui`. The
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

Steam needs one interactive login (and again whenever its session expires).
Only one Steam can run per user, so stop the headless one meanwhile:

```sh
sudo systemctl --user -M steamhost@ stop steam-headless
steamhost-gui steam # log in, then quit Steam from its menu
sudo systemctl --user -M steamhost@ start steam-headless
```

## BSManager

```sh
steamhost-gui bs-manager
```

The headless Steam may keep running. Add maps from BSManager's own map browser:
BeatSaver's OneClick links open in the desktop user's browser and cannot reach
`steamhost`'s BSManager.

