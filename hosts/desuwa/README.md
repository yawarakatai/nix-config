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
  controller input, audio, `steamhost-gui`, and the restore steps below. The
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

BSManager keeps everything worth keeping in `~/.local/share/BSManager`:
`BSInstances/<version>/` (the modded game), `SharedContent/SharedMaps/` (custom
maps), and `SharedContent/compatdata/` (the Proton prefix with scores and
settings under `AppData/LocalLow/Hyperbolic Magnetism/Beat Saber/`). Its
settings are `~/.config/bs-manager/config.json`; the rest of that directory is
Electron cache.

## Back up before reinstalling

Copy these to storage that survives the reinstall; `rsync -a` keeps symlinks:

- `~/.local/share/BSManager` and `~/.config/bs-manager/config.json`
- Steam's `~/.local/share/Steam`, or at least its `userdata/` and `config/`
  (settings and non-Steam shortcuts); games can be downloaded again

## Move or restore Steam and BSManager into steamhost

`old` is the home the data came from, and `src` is where it is now (the same
home for a move, the backup for a restore). Within `/home` a move is a rename.
Symlinks, `config.json`, and `libraryfolders.vdf` hold absolute paths into the
old home, so the steps rewrite them:

```sh
old=/home/yawarakatai src=$old new=/home/steamhost
sudo systemctl --user -M steamhost@ stop steam-headless
sudo mkdir -p $new/.local/share $new/.config/bs-manager
sudo rm -rf $new/.local/share/Steam # the fresh bootstrap, if any
sudo mv $src/.local/share/Steam $src/.local/share/BSManager $new/.local/share/
sudo mv $src/.config/bs-manager/config.json $new/.config/bs-manager/
sudo sed -i "s|$old/|$new/|g" $new/.config/bs-manager/config.json \
  $new/.local/share/Steam/steamapps/libraryfolders.vdf
sudo find $new/.local/share/BSManager -type l -lname "$old/*" -exec sh -c \
  'ln -sfn "$(readlink "$1" | sed "s|^$2/|$3/|")" "$1"' _ {} $old $new \;
sudo chown -hR steamhost:steamhost $new/.local $new/.config
rm -rf $old/.steam # only symlinks into the old Steam location
sudo systemctl --user -M steamhost@ start steam-headless
```

For a restore, use `cp -a` instead of `mv` if the backup should stay. Then
recreate the Beat Saber shortcut in Steam from BSManager, since the old one
points into the old home.
