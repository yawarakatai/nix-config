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
  controller input, and audio. The `input`, `uinput`, `networkmanager` groups
  and the Valve USB rule are there because seat ACLs never reach this user.
- Undecided: Beat Saber through BSManager. Its instances and shortcuts point
  into the desktop user's home, which `steamhost` cannot read.

Trade-off: the `input` group lets Steam and its games read every input device,
including the desktop keyboard; the desktop Steam had the same access.

## Operate

```sh
sudo systemctl --user -M steamhost@ status steam-headless
sudo journalctl _SYSTEMD_USER_UNIT=steam-headless.service -b
```

Exiting Steam from a client restarts it after 5 seconds.

## Log in to Steam

Steam needs one interactive login (and again whenever its session expires).
Show its window on the desktop session for that:

```sh
sudo systemctl --user -M steamhost@ stop steam-headless
nix shell nixpkgs#xhost -c xhost +SI:localuser:steamhost
sudo machinectl shell steamhost@ /run/current-system/sw/bin/env DISPLAY=:0 /run/current-system/sw/bin/steam
# Log in, then quit Steam from its menu.
nix shell nixpkgs#xhost -c xhost -SI:localuser:steamhost
sudo systemctl --user -M steamhost@ start steam-headless
```

## Move an existing Steam library to steamhost

`/home` is one filesystem, so the move is a rename. Run it with Steam stopped
in both users:

```sh
sudo systemctl --user -M steamhost@ stop steam-headless
sudo mkdir -p /home/steamhost/.local/share
sudo rm -rf /home/steamhost/.local/share/Steam # the fresh bootstrap, if any
sudo mv ~/.local/share/Steam /home/steamhost/.local/share/
sudo sed -i "s|$HOME/.local/share/Steam|/home/steamhost/.local/share/Steam|" \
  /home/steamhost/.local/share/Steam/steamapps/libraryfolders.vdf
sudo chown -R steamhost:steamhost /home/steamhost/.local
rm -rf ~/.steam # only symlinks into the old location
sudo systemctl --user -M steamhost@ start steam-headless
```
