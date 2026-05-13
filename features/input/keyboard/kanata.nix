{ config, ... }:

{
  services.kanata = {
    enable = true;
    keyboards = {
      internal = {
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defvar
            tap-timeout   150
            hold-timeout  250
          )

          (defsrc
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl
          )

          (defalias
            esctl (tap-hold-release $tap-timeout $hold-timeout esc  lctl)
            bsnav (tap-hold-release $tap-timeout $hold-timeout bspc (layer-toggle nav))
            spsft (tap-hold-release $tap-timeout $hold-timeout spc  lsft)
            rtalt (tap-hold-release $tap-timeout $hold-timeout ret  lalt)

            colqw (layer-switch qwerty)
            qwcol (layer-switch colemak-dh)
          )

          (deflayer colemak-dh
            grv    1      2      3      4      5      6      7      8      9      0      -      =      bspc
            tab    q      w      f      p      b      j      l      u      y      ;      [      ]      \
            @esctl a      r      s      t      g      m      n      e      i      o      '      ret
            lsft   x      c      d      v      z      k      h      ,      .      /      rsft
            @colqw lmet   @rtalt               @spsft               @bsnav rmet   rctl
          )

          (deflayer nav
            _      _      _      _      _      _      _      _      _      _      _      _      _      _
            _      _      _      _      _      _      _      home   pgdn   pgup   end    _      _      _
            _      lmet   lalt   lctl   lsft   _      _      left   down   up     right  _      _
            _      _      _      _      _      _      _      _      _      _      _      _
            _      _      _                    _                    _      _      _ 
          )

          (deflayer qwerty
            grv    1      2      3      4      5      6      7      8      9      0      -      =      bspc
            tab    q      w      e      r      t      y      u      i      o      p      [      ]      \
            lctl   a      s      d      f      g      h      j      k      l      ;      '      ret
            lsft   z      x      c      v      b      n      m      ,      .      /      rsft
            @qwcol lmet   lalt                 spc                  ralt   rmet   rctl
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
