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
          ;;  Space: Space / Shift
          ;;  Backspace: Bspc / Num
          ;;  Return: Ret / Nav
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
            rtnav (tap-hold-release $tap-timeout $hold-timeout ret  (layer-toggle nav))
            bsnum (tap-hold-release $tap-timeout $hold-timeout bspc (layer-toggle num))
            spsft (tap-hold-release $tap-timeout $hold-timeout spc  lsft)
          )

          (deflayer base
            grv    1      2      3      4      5      6      7      8      9      0      -      =      _
            tab    q      w      f      p      b      j      l      u      y      ;      [      ]      \
            esc    @a_met @r_alt @s_ctl @t_sft g      m      @n_sft @e_ctl @i_alt @o_met '      _
            z      x      c      d      v      z      k      h      ,      .      /      _
            _      _      @rtnav               @spsft               @bsnum _      _
          )

          (deflayer num
            _      _      _      _      _      _      _      _      _      _      _      _      _      _
            _      _      7      8      9      _      _      _      _      _      _      _      _      _
            _      _      4      5      6      _      _      _      _      _      _      _      _
            _      _      1      2      3      _      _      _      _      _      _      _
            _      _      .                    0                    _      _      _ 
          )

          (deflayer nav
            _      _      _      _      _      _      _      _      _      _      _      _      _      _
            _      _      _      _      _      _      _      home   pgdn   pgup   end    _      _      _
            _      lmet   lalt   lctl   lsft   _      _      left   down   up     right  _      _
            _      _      _      _      _      _      _      _      _      _      _      _
            _      _      _                    _                    _      _      _ 
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
