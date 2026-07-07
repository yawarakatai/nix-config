_:

{
  xdg.configFile = {
    "television/cable/files-sorted.toml".text = ''
      [metadata]
      name = "files-sorted"
      description = "Files sorted alphabetically, substring matching"
      requirements = ["fd", "bat"]

      [source]
      command = [
        { name = "Sorted", run = 'fd -t f . -E .cache -E .local -E .git -E target -E node_modules 2>/dev/null | sort' },
      ]

      [preview]
      command = 'bat -n --color=always "{}"'
    '';

    "television/cable/dirs-sorted.toml".text = ''
      [metadata]
      name = "dirs-sorted"
      description = "Directories sorted alphabetically, substring matching"
      requirements = ["fd"]

      [source]
      command = [
        { name = "Sorted", run = 'fd -t d . -E .cache -E .local -E .git -E target -E node_modules 2>/dev/null | sort' },
      ]

      [preview]
      command = 'eza --tree --color=always "{}"'
    '';
  };
}
