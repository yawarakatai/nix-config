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
          ;;  Enter:    Tap for Enter, Hold for Ctrl
          ;;  Space:    Tap for Space, Hold for Shift
          ;;  RAlt: Symbols layer
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
            entctl (tap-hold 200 200 ret lctl)
            spcsft (tap-hold 150 150 spc lsft)
            sym    (layer-while-held symbols)
          )

          (deflayer base
            grv     1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab     q    w    f    p    b    j    l    u    y    ;    [    ]    \
            @escctl a    r    s    t    g    m    n    e    i    o    '    @entctl
            lsft    z    x    c    d    v    k    h    ,    .    /    rsft
            lctl    lmet lalt           @spcsft        @sym rmet rctl
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

  users.users.${config.my.user.name}.extraGroups = [
    "uinput"
    "input"
  ];
}
