{ config, ... }:

{
  services.kanata = {
    enable = true;
    keyboards = {
      internal = {
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          ;; =================================================================
          ;;  Kanata Configuration — Colemak DH + Home Row Mods
          ;;
          ;;  Base: QWERTY physical -> Colemak DH output
          ;;  Home row mods (GACS/SCAG): Meta, Alt, Ctrl, Shift
          ;;  CapsLock: Esc
          ;;  Space: Space (plain)
          ;;  Backspace: Tap for Bspc, Hold for layer toggle
          ;; =================================================================

          (defvar
            tap-timeout   200
            hold-timeout  200
          )

          (defsrc
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl
          )

          (defalias
            ;; --- home row mods (tap-hold-release for rollover tolerance) ---
            a_met (tap-hold-release $tap-timeout $hold-timeout a lmet)
            r_alt (tap-hold-release $tap-timeout $hold-timeout r lalt)
            s_ctl (tap-hold-release $tap-timeout $hold-timeout s lctl)
            t_sft (tap-hold-release $tap-timeout $hold-timeout t lsft)
            n_sft (tap-hold-release $tap-timeout $hold-timeout n rsft)
            e_ctl (tap-hold-release $tap-timeout $hold-timeout e rctl)
            i_alt (tap-hold-release $tap-timeout $hold-timeout i ralt)
            o_met (tap-hold-release $tap-timeout $hold-timeout o rmet)

            ;; --- thumb keys ---
            bspcly (tap-hold-release $tt-fast $hold-timeout bspc (layer-toggle layer))
          )

          (deflayer base
            grv     1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab     q    w    f    p    b    j    l    u    y    ;    [    ]    \
            esc     @a_met @r_alt @s_ctl @t_sft g  m  @n_sft @e_ctl @i_alt @o_met '  ret
            z       x    c    d    v    j    k    h    ,    .    /    del
            _       lmet lalt           spc            @bspcly   _    _
          )

          (deflayer layer
            _     _     _     _     _     _     _     _     _     _     _     _     _     _
            _     _     7     8     9     _     _     _     _     _     _     _     _     _
            _     _     4     5     6     _     _     left  down  up    right _     _
            _     _     1     2     3     _     _     _     _     _     _     _
            _     _     _              0              _     _     _
          )
        '';
      };
    };
  };

  users.users.${config.my.user.name}.extraGroups = [
    "uinput"
    "input"
  ];
}
