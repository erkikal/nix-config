{
  profile,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./zshrc-personal.nix
  ];

  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = ["main" "brackets" "pattern" "regexp" "root" "line"];
    };
    historySubstringSearch.enable = true;

    history = {
      ignoreDups = true;
      save = 10000;
      size = 10000;
    };

    # oh-my-zsh = {
    #   enable = true;
    # };

    # plugins = [
    #   {
    #     name = "powerlevel10k";
    #     src = pkgs.zsh-powerlevel10k;
    #     file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    #   }
    #   {
    #     name = "powerlevel10k-config";
    #     src = lib.cleanSource ./p10k-config;
    #     file = "p10k.zsh";
    #   }
    # ];

    initContent = ''
      bindkey "\eh" backward-word
      bindkey "\ej" down-line-or-history
      bindkey "\ek" up-line-or-history
      bindkey "\el" forward-word

      bindkey " " magic-space

      fastfetch -c examples/8

      # Keep history writes safe across concurrent shells and abrupt shutdowns.
      setopt APPEND_HISTORY
      setopt INC_APPEND_HISTORY
      setopt EXTENDED_HISTORY
      setopt HIST_SAVE_BY_COPY
      unsetopt SHARE_HISTORY
      if [ -f $HOME/.zshrc-personal ]; then
        source $HOME/.zshrc-personal
      fi
    '';

    shellAliases = {
      nix-fmt-all = "nix fmt ./";
      sv = "sudo nvim";
      v = "nvim";
      c = "clear";
      fr = "nh os switch --hostname ${profile}";
      fu = "nh os switch --hostname ${profile} --update";
      zu = "sh <(curl -L https://gitlab.com/Zaney/zaneyos/-/releases/latest/download/install-zaneyos.sh)";
      ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      cat = "bat";
      man = "batman";

      hist = "history 1 | less";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";

      # Indent clipboard with space, so if pasted to shell (bash/zsh), it doesn't get saved in history file
      # Need to change for NixOS
      repaste = "pbpaste | sed -e \"s/^/ /\" | pbcopy";

      cls = "clear && fastfetch -c examples/8";

      hdmi2pc = "sudo ddcutil setvcp 60 0x12 --display 1";
    };

    shellGlobalAliases = {
      NE = "2>/dev/null";
      NO = ">/dev/null";
      NUL = ">/dev/null 2>&1";

      # Fix for NixOS
      # C = "| pbcopy";
    };

    siteFunctions = {
      # mkdir and cd into it
      "mkcd" = ''
        mkdir -p -- "$1" && cd -P -- "$1"
      '';
    };
  };
}
