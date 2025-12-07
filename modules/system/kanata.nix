{ vars, ... }:

{
  # 1. Enable the Kanata service
  services.kanata = {
    enable = true;
    keyboards = {
      internal = {
        # Select the internal keyboard. 
        # CAUTION: Adjust the device path to match your hardware. 
        # You can often use `defcfg` inside the kbd config to handle device detection automatically,
        # or specify devices here explicitly if needed.
        # devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];

        extraDefCfg = "process-unmapped-keys yes";

        # 2. Embed the configuration string directly
        config = ''
          ;; =================================================================
          ;;  Kanata Configuration for NixOS + Niri + Helix
          ;;  Target: Standard US Layout (e.g., ThinkPad)
          ;; =================================================================

          ;; --- Source Definition (Physical Layout) ---
          (defsrc
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl
          )

          ;; --- Aliases & Logic ---
          (defalias
            ;; CapsLock Strategy:
            ;; Tap = Escape (Vital for Helix/Vim)
            ;; Hold = Super (Vital for Niri window management)
            escsuper (tap-hold 150 150 esc lmet)

            ;; Home Row Mods:
            ;; Using tap-hold-release to prevent misfires during fast rolling input.
            ;; G / H are left blank for scrolling/movement ease.
            
            ;; Left Hand
            ;; A = (Optional)
            ;; S = Alt
            ;; D = Ctrl (Placed on middle finger for comfortable Helix C-d/C-u scrolling)
            ;; F = Shift
            s (tap-hold-release 200 200 s lalt)
            d (tap-hold-release 200 200 d lctl)
            f (tap-hold-release 200 200 f lsft)

            ;; Right Hand
            ;; J = Shift
            ;; K = Ctrl
            ;; L = Alt
            ;; ; = (Optional)
            j (tap-hold-release 200 200 j rsft)
            k (tap-hold-release 200 200 k rctl)
            l (tap-hold-release 200 200 l ralt)

            ;; Thumb Layer Toggles
            ;; Left Alt  -> Navigation Layer (Arrow keys)
            ;; Right Alt -> Symbol Layer (Brackets/Parens)
            nav (layer-while-held navigation)
            sym (layer-while-held symbols)
          )

          ;; --- Base Layer ---
          (deflayer base
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            @escsuper a @s   @d   @f   g    h    @j   @k   @l   ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet @nav           spc            @sym rmet rctl
          )

          ;; --- Navigation Layer (Left Alt held) ---
          ;; Right hand acts as arrow keys (Vim style HJKL)
          ;; U/I used for PageUp/PageDown
          (deflayer navigation
            _    f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  del
            _    _    _    _    _    _    pgup home up   end  _    _    _    _
            _    _    _    _    _    _    pgdn left down right _    _    _
            _    _    _    _    _    _    _    _    _    _    _    _
            _    _    _              _              _    _    _
          )

          ;; --- Symbol Layer (Right Alt held) ---
          ;; Optimized for Coding (Rust/Nix).
          ;; Left hand focuses on brackets and comparison operators.
          (deflayer symbols
            _    _    _    _    _    _    _    _    _    _    _    _    _    _
            _    `    S-,  S-.  S-2  S-5  _    _    _    _    _    _    _    _
            _    S-`    S-9  S-0  [    ]    _    _    _    _    _    _    _
            _    _    S-[  S-]    \    S-\    _    _    _    _    _    _
            _    _    _              _              _    _    _
          )
        '';
      };
    };
  };

  # Ensure the user belongs to the necessary groups (uinput is critical for kanata)
  # Replace "yourusername" with your actual user variable if you use one, 
  # or ensure this is set in your main user config.
  users.users.${vars.username}.extraGroups = [ "uinput" "input" ];
}
