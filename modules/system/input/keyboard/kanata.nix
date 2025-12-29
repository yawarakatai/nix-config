{ vars, ... }:

{
  services.kanata = {
    enable = true;
    keyboards = {
      internal = {
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          ;; =================================================================
          ;;  Kanata Configuration
          ;;  Action: CapsLock -> Tap for Esc, Hold for Ctrl (escctl)
          ;;  Layers: Alt -> Navigation / Symbols
          ;; =================================================================

          (defsrc
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl
          )

          (defalias
            escctl (tap-hold 150 150 esc lctl)

            ;; nav (layer-while-held navigation)
            sym (layer-while-held symbols)
          )

          (deflayer base
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            @escctl a s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            @sym rmet rctl
          )

          (deflayer navigation
            _    f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12  del
            _    _    _    _    _    _    pgup home up   end  _    _    _    _
            _    _    _    _    _    _    pgdn left down right _    _    _
            _    _    _    _    _    _    _    _    _    _    _    _
            _    _    _              _              _    _    _
          )

          (deflayer symbols
            _    _    _    _    _    _    _    _    _    _    _    _    _    _
            _    grv  S-,  S-.  S-2  S-5  _    _    _    _    _    _    _    _
            _    S-grv S-9  S-0  [    ]    _    _    _    _    _    _    _
            _    _    S-[  S-]  S-\  S-\  _    _    _    _    _    _
            _    _    _              _              _    _    _
          )
        '';
      };
    };
  };

  users.users.${vars.username}.extraGroups = [
    "uinput"
    "input"
  ];
}
