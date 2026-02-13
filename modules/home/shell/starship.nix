{ ... }:

{
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;

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
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
        vimcmd_symbol = "[λ](bold purple)";
      };

      # Directory
      directory = {
        style = "bold purple";
        truncation_length = 3;
        truncate_to_repo = true;
        read_only = " 🔒";
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };

      # Direnv
      direnv = {
        disabled = false;
        symbol = "󰌪 ";
        style = "bold yellow";
        format = "[$symbol]($style)";

        allowed_msg = "";
        not_allowed_msg = " (not allowed)";
        denied_msg = " (denied)";
      };

      # Git Branch
      git_branch = {
        symbol = " ";
        style = "bold yellow";
        format = "[$symbol$branch]($style) ";
      };

      # Git Status
      git_status = {
        style = "bold yellow";
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
        ssh_only = true;
        format = "[@$hostname](bold blue) ";
      };

      # -----------------------------------------------------------------------
      #  Language Modules (Icons added)
      # -----------------------------------------------------------------------

      c = {
        symbol = " ";
        style = "blue";
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
