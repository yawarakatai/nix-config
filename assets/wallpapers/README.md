# Wallpapers

This directory contains wallpapers for each host, managed declaratively by Nix.

## Structure

```
assets/wallpapers/
├── desuwa/
│   └── bg.png
├── nanodesu/
│   └── bg.png
└── _template/
    └── bg.png
```

## Usage

Each host's `vars.nix` references its wallpaper using a relative path:

```nix
wallpaperPath = ../../assets/wallpapers/HOSTNAME/bg.png;
```

Nix will automatically copy these files to the Nix store and manage them declaratively.

## Adding Wallpapers

1. Place your wallpaper image in the appropriate host directory
2. Name it `bg.png` (or update the reference in `vars.nix`)
3. Commit the changes to git
4. Rebuild your system

## Notes

- Wallpapers are now tracked in git for full reproducibility
- Supported formats: PNG, JPG, or any format supported by `swaybg`
- Placeholder images are provided by default
