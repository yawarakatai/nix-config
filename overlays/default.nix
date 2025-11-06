final: prev: {
  niri-unstable = prev.niri-unstable.overrideAttrs (oldAttrs: {
    doCheck = false;
    checkPhase = ''
      runHook preCheck
      echo "Skipping niri tests in build environment"
      runHook postCheck
    '';
  });
}
