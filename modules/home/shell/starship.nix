{ ... }:

{
  programs.starship = {
    enable = true;
    enableNushellIntegration = false;
    enableZshIntegration = true;

    settings = {
      # -----------------------------------------------------------------------
      #  Format & Layout
      # -----------------------------------------------------------------------
      format = "$username$hostname$directory$git_branch$git_status$nix_shell$direnv$c$rust$python$haskell$nodejs$line_break$character";

      command_timeout = 1000;
      add_newline = true;

      # -----------------------------------------------------------------------
      #  Core Modules
      # -----------------------------------------------------------------------

      # Character
      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
        vimcmd_symbol = "[>](bold purple)";
      };

      # Directory
      directory = {
        style = "bold yellow";
        truncation_length = 3;
        truncate_to_repo = true;
        read_only = " 🔒";
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };

      # Git Branch
      git_branch = {
        symbol = " ";
        style = "bold orange";
        format = "[$symbol$branch]($style) ";
      };

      # Git Status
      git_status = {
        style = "bold red";
        format = "([$all_status$ahead_behind]($style) )";
        conflicted = " \${count} ";
        ahead = "⇡\${count} ";
        behind = "⇣\${count} ";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count} ";
        untracked = "?\${count} ";
        stashed = " \${count} ";
        modified = "!\${count} ";
        staged = "+\${count} ";
        renamed = "»\${count} ";
        deleted = "✘\${count} ";
      };

      # Nix Shell
      nix_shell = {
        symbol = " ";
        style = "bold blue";
        format = "[$symbol$state]($style) ";
        impure_msg = "";
        pure_msg = "(pure)";
      };

      # Direnv
      direnv = {
        disabled = false;
        symbol = "󰌪 ";
        style = "bold green";
        format = "[$symbol]($style) ";

        allowed_msg = "";
        not_allowed_msg = " (not allowed)";
        denied_msg = " (denied)";
      };

      # Username
      username = {
        disabled = false;
        style_user = "bold cyan";
        style_root = "bold red";
        format = "[ $user]($style) ";
        show_always = false;
      };

      # Hostname
      hostname = {
        disabled = false;
        style = "bold blue";
        format = "[@$hostname]($style) ";
        ssh_only = true;
      };

      # -----------------------------------------------------------------------
      #  Language Modules (Icons added)
      # -----------------------------------------------------------------------

      c = {
        symbol = " ";
        style = "bold blue";
        format = "[$symbol($version )]($style)";
      };

      rust = {
        symbol = " "; # or 🦀
        style = "bold red";
        format = "[$symbol($version )]($style)";
      };

      python = {
        symbol = " "; # or 🐍
        style = "bold yellow";
        format = "[($virtualenv )]($style)[$symbol($version )]($style)";
      };

      haskell = {
        symbol = " ";
        style = "bold purple";
        format = "[$symbol($version )]($style)";
      };

      nodejs = {
        symbol = " ";
        style = "bold green";
        format = "[$symbol($version )]($style)";
      };
    };
  };
}
