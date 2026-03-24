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
            sym (layer-while-held symbols)
          )

          ;; Colemak DH remapping on a QWERTY physical keyboard
          ;; Physical QWERTY -> Colemak DH output
          (deflayer base
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    f    p    b    j    l    u    y    ;    [    ]    \
            @escctl a r  s    t    g    m    n    e    i    o    '    ret
            lsft x    c    d    v    z    k    h    ,    .    /    rsft
            lctl lmet lalt           spc            @sym rmet rctl
          )

          ;; Navigation layer (RAlt held)
          ;; neio positions on Colemak DH = physical hjkl on QWERTY
          ;; So we map physical h/j/k/l to arrow-like functions
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
