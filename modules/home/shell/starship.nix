{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;

    settings = {
      # Format
      format = "$username$hostname$directory$git_branch$git_status$nix_shell$character";
      right_format = "$cmd_duration$time";

      # Timeout
      command_timeout = 1000;

      # Palette - will be configured by stylix

      # Character
      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
        vimcmd_symbol = "[λ](bold purple)";
      };

      # Username
      username = {
        style_user = "bold cyan";
        style_root = "bold red";
        format = "[$user]($style)";
        show_always = true;
      };

      # Hostname
      hostname = {
        ssh_only = false;
        format = "[@$hostname](bold blue) ";
        disabled = false;
      };

      # Directory
      directory = {
        style = "bold purple";
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[$path]($style) ";
        read_only = " 󰌾";
        read_only_style = "red";
      };

      # Git branch
      git_branch = {
        symbol = " ";
        style = "bold yellow";
        format = "[$symbol$branch]($style) ";
      };

      # Git status
      git_status = {
        style = "bold yellow";
        format = "([$all_status$ahead_behind]($style))";
        conflicted = "=$count ";
        ahead = "⇡$count ";
        behind = "⇣$count ";
        diverged = "⇕⇡$ahead_count⇣$behind_count ";
        untracked = "?$count ";
        stashed = "\$$count ";
        modified = "!$count ";
        staged = "+$count ";
        renamed = "»$count ";
        deleted = "✘$count ";
      };

      # Nix shell
      nix_shell = {
        symbol = " ";
        style = "bold cyan";
        format = "[$symbol$state]($style) ";
        impure_msg = "";
        pure_msg = "(pure)";
      };

      # Command duration
      cmd_duration = {
        min_time = 500;
        style = "bold cyan";
        format = "[$duration]($style) ";
      };

      # Time
      time = {
        disabled = false;
        style = "bold blue";
        format = "[$time]($style)";
        time_format = "%H:%M";
      };

      # Language-specific modules
      rust = {
        symbol = " ";
        style = "bold yellow";
        format = "[$symbol($version)]($style) ";
      };

      python = {
        symbol = " ";
        style = "bold yellow";
        format = "[($virtualenv )$symbol($version)]($style) ";
      };

      nodejs = {
        symbol = " ";
        style = "bold green";
        format = "[$symbol($version)]($style) ";
      };

      c = {
        symbol = " ";
        style = "bold blue";
        format = "[$symbol($version)]($style) ";
      };

      java = {
        symbol = " ";
        style = "bold yellow";
        format = "[$symbol($version)]($style) ";
      };

      haskell = {
        symbol = " ";
        style = "bold purple";
        format = "[$symbol($version)]($style) ";
      };
    };
  };
}
