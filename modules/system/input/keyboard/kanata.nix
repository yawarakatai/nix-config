{ config, ... }:

{
  services.kanata = {
    enable = true;
    keyboards = {
      internal = {
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          ;; =================================================================
          ;;  Kanata Configuration — Colemak DH
          ;;
          ;;  Base: QWERTY physical -> Colemak DH output
          ;;  CapsLock: Tap for Esc, Hold for Ctrl
          ;;  Space:    Tap for Space, Hold for Shift
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
            spcsft (tap-hold 200 200 spc lsft)
            bspcly (tap-hold 200 200 bspc (layer-toggle layer))
            super  (tap-hold 200 200 M-tab lmet)
          )

          (deflayer base
            grv     1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab     q    w    f    p    b    j    l    u    y    ;    [    ]    \
            @escctl a    r    s    t    g    m    n    e    i    o    '    ret
            z       x    c    d    v    j    k    h    ,    .    /    del
            _       @super lalt         @spcsft        @bspcly   _    _
          )

          (deflayer layer
            _     _     _     _     _     _     _     _     _     _     _     _     _     _ 
            _     _     7     8     9     _     _     _     _     _     _     _     _     _ 
            _     _     4     5     6     _     _     left  down  up    right _     _ 
            _     _     1     2     3     _     _     _     _     _     _     _ 
            _     _     _              0     _     _     _     
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
