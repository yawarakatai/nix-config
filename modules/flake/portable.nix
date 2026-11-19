{ inputs, self, ... }:

{
  perSystem =
    { lib, system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        # Claude Code is unfree.
        config.allowUnfree = true;
      };

      # Home Manager only renders the files; nothing is activated, so the account is a
      # placeholder and the user's home is never written.
      home =
        (inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs self; };
          modules = [
            ../profiles/home/portable.nix
            (
              { config, ... }:
              {
                home = {
                  username = "portable";
                  homeDirectory = "/homeless-shelter";
                  stateVersion = "25.05";
                  enableNixpkgsReleaseCheck = false;
                };

                # Keep the placeholder home out of the files the shell uses.
                programs.zsh.history.path = "$HOME/.zsh_history";
                programs.ssh.settings."*".userKnownHostsFile = lib.mkForce "~/.ssh/known_hosts ${
                  config.home.file.".ssh/known_hosts_managed".source
                }";

                # television writes a default config.toml when it is missing, which fails in the store.
                xdg.configFile."television/config.toml".text = "";
              }
            )
          ];
        }).config;

      files = home.home-files;
      bin = "${home.home.path}/bin";

      zdotdir = pkgs.linkFarm "portable-zdotdir" {
        ".zshrc" = "${files}/.config/.zshrc";
        # Set here rather than by the launcher because /etc/zshenv may reset PATH (NixOS
        # does); the rendered .zshrc adds completions only from $NIX_PROFILES.
        ".zshenv" = pkgs.writeText "zshenv" ''
          typeset -U path
          path=(${lib.concatMapStringsSep " " (w: "${w}/bin") wrappers} ${bin} $path)
          fpath+=(${home.home.path}/share/zsh/site-functions)
        '';
      };

      # Point each tool at its rendered configuration instead of ~/.config.
      vars = home.home.sessionVariables // {
        GIT_CONFIG_GLOBAL = "${files}/.config/git/config";
        LG_CONFIG_FILE = "${files}/.config/lazygit/config.yml";
        STARSHIP_CONFIG = "${files}/.config/starship.toml";
        YAZI_CONFIG_HOME = "${files}/.config/yazi";
        TELEVISION_CONFIG = "${files}/.config/television";
        DIRENV_CONFIG = "${files}/.config/direnv";
        ZDOTDIR = "${zdotdir}";
      };

      wrappers = [
        # Helix finds its configuration only under $XDG_CONFIG_HOME, so only Helix gets it.
        (pkgs.writeShellScriptBin "hx" ''
          XDG_CONFIG_HOME=${files}/.config exec ${bin}/hx "$@"
        '')
        (pkgs.writeShellScriptBin "ssh" ''
          exec ${lib.getExe pkgs.openssh} -F ${files}/.ssh/config "$@"
        '')
      ];
    in
    {
      # A shell with the usual tools and their configuration that leaves the
      # user's dotfiles alone (see docs/portable.md).
      packages.portable =
        assert lib.assertMsg (lib.all (value: !lib.hasInfix home.home.homeDirectory (toString value)) (
          lib.attrValues vars
        )) "portable: a session variable points into the placeholder home";
        pkgs.writeShellApplication {
          name = "portable";
          text = ''
            ${lib.concatLines (
              lib.mapAttrsToList (name: value: "export ${name}=${lib.escapeShellArg value}") vars
            )}
            exec ${lib.getExe home.programs.zsh.package} "$@"
          '';
        };
    };
}
