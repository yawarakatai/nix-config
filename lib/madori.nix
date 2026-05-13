{
  mkMonitor = connector: scale: {
    matchBy.connector = connector;
    inherit scale;
  };

  only = name: {
    match = [ name ];
    layout.${name}.position = "0,0";
  };

  disableExternal = builtin: external: {
    match = [
      builtin
      external
    ];
    layout = {
      ${builtin}.position = "0,0";
      ${external} = {
        position = "0,0";
        enabled = false;
      };
    };
  };

  mirrorExternal = builtin: {
    match = [
      builtin
      "_"
    ];
    layout = {
      ${builtin}.position = "0,0";
      "$1".mirror = builtin;
    };
  };

  virtual = width: height: refresh: {
    match = [ "*" ];
    virtual = {
      inherit width height;
      refresh = refresh;
    };
  };
}
