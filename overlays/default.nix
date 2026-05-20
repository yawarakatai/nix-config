[
  (final: prev: {
    gtksourceview5 = prev.gtksourceview5.overrideAttrs (_: {
      doCheck = false;
    });
    "handheld-daemon" = prev."handheld-daemon".overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace src/hhd/device/rog_ally/base.py \
          --replace-fail '"extra_l1"' '"lb"' \
          --replace-fail '"extra_r1"' '"rb"'
      '';
    });
  })
]
