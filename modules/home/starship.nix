{
  pkgs,
  lib,
  ...
}: {
  programs.starship = {
    enable = true;
    package = pkgs.starship;
    settings = {
      # Use Catppuccin theme (Mocha variant)
      palette = lib.mkForce "catppuccin_mocha";

      # Theme color definitions
      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };

      add_newline = false;

      format = "$os$username$hostname$kubernetes$directory$git_branch$git_status$line_break$character";

      right_format = "$python $terraform $aws $time";

      # Modern symbol styling
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
        vimcmd_symbol = "[](bold fg:color_green)";
        vimcmd_replace_one_symbol = "[](bold fg:color_purple)";
        vimcmd_replace_symbol = "[](bold fg:color_purple)";
        vimcmd_visual_symbol = "[](bold fg:color_yellow)";
      };

      os = {
        disabled = false;
        format = "[$symbol](bold white) ";
        symbols = {
          Windows = " ";
          Arch = "󰣇";
          Ubuntu = "";
          Macos = "󰀵";
          Debian = "";
          NixOS = "";
        };
      };

      username = {
        style_user = "white bold";
        style_root = "black bold";
        format = "[$user]($style)";
        disabled = false;
        show_always = true;
      };

      hostname = {
        ssh_only = true;
        format = "@[$hostname](bold yellow)";
        disabled = false;
      };

      kubernetes = {
        format = "[󱃾 $context($namespace)](bold purple) ";
        disabled = false;
      };

      aws = {
        format = "[$symbol($profile)($duration)]($style) ";
        disabled = false;
        style = "bold green";
      };

      # Disable some modules that might slow down the prompt
      gcloud.disabled = true;

      # Directory configuration
      directory = {
        truncation_length = 3;
        truncation_symbol = "…/";
        truncate_to_repo = false;
        home_symbol = "󰋜 ~";
        read_only_style = "197";
        read_only = "  ";
        format = " at [$path]($style)[$read_only]($read_only_style) ";
      };

      # Git configuration
      git_branch = {
        symbol = " ";
        # truncation_length = 20;
        format = "[$symbol$branch]($style)";
        truncation_symbol = "…/";
        style = "bold green";
      };

      git_status = {
        format = "[$all_status$ahead_behind]($style)";
        conflicted = "🏳";
        ahead = "⇡";
        diverged = "⇕⇡|⇣";
        behind = "⇣";
        up_to_date = "✓";
        untracked = " ";
        stashed = "📦";
        modified = "📝";
        staged = "[++\\($count\\)](green)";
        renamed = "👅";
        deleted = "🗑";
      };

      # Nix shell configuration
      nix_shell = {
        symbol = "❄️ ";
        format = "via [$symbol$state( \($name\))]($style) ";
      };
    };
  };
}
