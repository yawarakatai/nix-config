{ pkgs, ... }:

let
  inherit (pkgs) godot;

  # Godot 4 tries X11 first. On Wayland the Project Manager opens with its own
  # app-id, which niri's window rule needs, and the editor it starts inherits
  # --display-driver; projects run from the editor do not.
  godotWayland = pkgs.symlinkJoin {
    name = "godot-wayland-${godot.version}";
    paths = [ godot ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    # The desktop entry runs Godot by absolute path, so it is rewritten too.
    postBuild = ''
      for bin in "$out"/bin/*; do
        rm "$bin"
        makeWrapper "${godot}/bin/$(basename "$bin")" "$bin" --add-flags "--display-driver wayland"
      done
      for entry in "$out"/share/applications/*.desktop; do
        rm "$entry"
        sed "s|${godot}/bin/|$out/bin/|g" "${godot}/share/applications/$(basename "$entry")" > "$entry"
      done
    '';
  };
in
{
  home.packages = [ godotWayland ];
}
