{ pkgs, inputs, }:

{
  home.packages = [
    inputs.zen-browser.packages.${pkgs.system}.default
  ];

  programs.zen-browser = {
    enable = true;
  };

  # home.packages = [
  #   inputs.zen-browser.packages.${pkgs.system}.default
  # ];
}
