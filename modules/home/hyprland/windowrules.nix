_: {
  # Hyprland window rules.
  #
  # This is a real home-manager module (imported in default.nix). Under
  # configType = "lua", home-manager emits every element of settings.window_rule
  # as its own hl.window_rule(<table>) call, in list order - so the records here
  # map 1:1 onto the table hl.window_rule() expects: `match` holds the matchers,
  # every other key is a rule property. No runtime parsing and no custom lua
  # consumer. Conventions carried over from the previous hyprlang form:
  #   on/off  -> true/false
  #   "60% 70%" is the hyprlang "60% = 70%" (two-value props: size/opacity/move)
  #
  # `name` is a UNIQUE KEY: hl.window_rule() merges rules that share a name
  # (matchers and effects accumulate onto one rule). Keep every name distinct.
  wayland.windowManager.hyprland.settings.window_rule = [
    # Dialog boxes / modals
    {
      match = {modal = true;};
      float = true;
    }
    {
      match = {modal = true;};
      center = true;
    }

    {
      name = "Resolve";
      match = {
        class = "^(\\bresolve\\b)$";
        xwayland = true;
      };
      no_blur = true;
    }

    # ============= TAGGING: FILE MANAGERS / TERMINALS =============
    {
      name = "Thunar";
      match = {class = "^([Tt]hunar|org.gnome.Nautilus|[Pp]cmanfm-qt)$";};
      tag = "+file-manager";
    }
    {
      name = "Terminals";
      match = {class = "^(com.mitchellh.ghostty|org.wezfurlong.wezterm|Alacritty|kitty|kitty-dropterm|dropterminal)$";};
      tag = "+terminal";
    }

    # ============= TAGGING: BROWSERS =============
    {
      name = "Brave-browser";
      match = {class = "^(Brave-browser(-beta|-dev|-unstable)?)$";};
      tag = "+browser";
    }
    {
      name = "Firefox";
      match = {class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$";};
      tag = "+browser";
    }
    {
      name = "Google-chrome";
      match = {class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$";};
      tag = "+browser";
    }
    {
      name = "Vivaldi";
      match = {class = "^([Vv]ivaldi(-beta|-dev|-unstable)?)$";};
      tag = "+browser";
    }
    {
      name = "Thorium-browser";
      match = {class = "^([Tt]horium-browser|[Cc]achy-browser)$";};
      tag = "+browser";
    }

    # ============= TAGGING: PROJECTS =============
    {
      name = "vscodium";
      match = {class = "^(codium|codium-url-handler|VSCodium)$";};
      tag = "+projects";
    }
    {
      name = "vscode";
      match = {class = "^(VSCode|code-url-handler)$";};
      tag = "+projects";
    }

    # ============= TAGGING: INSTANT MESSAGING =============
    {
      name = "Discord";
      match = {class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$";};
      tag = "+im";
    }
    {
      name = "Ferdium";
      match = {class = "^([Ff]erdium)$";};
      center = true;
      float = true;
      size = "60% 70%";
      tag = "+im";
    }
    {
      name = "Whatsapp";
      match = {class = "^([Ww]hatsapp-for-linux)$";};
      tag = "+im";
    }
    {
      name = "Telegram-desktop";
      match = {class = "^(org.telegram.desktop|io.github.tdesktop_x64.TDesktop)$";};
      tag = "+im";
    }
    {
      name = "teams-for-linux";
      match = {class = "^(teams-for-linux)$";};
      tag = "+im";
    }
    {
      name = "Chatterino";
      match = {class = "^([Cc]hatterino)";};
      tag = "+chat";
    }

    # ============= TAGGING: GAMES =============
    {
      name = "gamescope";
      match = {class = "^(gamescope)$";};
      tag = "+games";
    }
    {
      name = "steam-app";
      match = {class = "^(steam_app\\d+)$";};
      tag = "+games";
    }
    {
      name = "Steam";
      match = {class = "^([Ss]team)$";};
      tag = "+gamestore";
      workspace = 8;
    }
    {
      name = "Lutris";
      match = {title = "^([Ll]utris)$";};
      tag = "+gamestore";
    }
    {
      name = "heroicgameslauncher";
      match = {class = "^(com.heroicgameslauncher.hgl)$";};
      tag = "+gamestore";
    }

    # ============= MEDIA / DEVICE CONTROL =============
    # Class regexes here are deliberately permissive: neither OpenXLR (Avalonia/.NET,
    # its packaging/openxlr.desktop declares no StartupWMClass) nor OpenDeck (Tauri,
    # run under Flatpak) advertises its Wayland app_id, so both the product name and
    # the reverse-DNS id are matched. Confirm with `hyprctl clients -j` and tighten.
    {
      name = "OpenXLR";
      match = {class = "^([Oo]pen[Xx][Ll][Rr].*|com\\.emaspa\\.openxlr)$";};
      workspace = 5;
    }
    {
      name = "OpenDeck";
      match = {class = "^([Oo]pen[Dd]eck|me\\.amankhanna\\.opendeck)$";};
      workspace = 5;
    }
    {
      name = "Spotify";
      match = {class = "^([Ss]potify)$";};
      workspace = 7;
    }

    # ============= TAGGING: SETTINGS =============
    {
      name = "gnome-disks";
      match = {class = "^(gnome-disks|wihotspot(-gui)?)$";};
      tag = "+settings";
    }
    {
      name = "rofi";
      match = {class = "^([Rr]ofi)$";};
      tag = "+settings";
      no_blur = false;
    }
    {
      name = "FileRoller";
      match = {class = "^(file-roller|org.gnome.FileRoller)$";};
      tag = "+settings";
    }
    {
      name = "NetworkManger";
      match = {class = "^(nm-applet|nm-connection-editor|blueman-manager)$";};
      tag = "+settings";
    }
    {
      name = "PlusAudio";
      match = {class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$";};
      center = true;
      tag = "+settings";
      no_blur = false;
    }
    {
      name = "nwg-look";
      match = {class = "^(nwg-look|qt5ct|qt6ct|[Yy]ad)$";};
      tag = "+settings";
    }
    {
      name = "xdg-desktop-portal-gtk";
      match = {class = "(xdg-desktop-portal-gtk)";};
      tag = "+settings";
    }
    {
      name = "blueman";
      match = {class = "(.blueman-manager-wrapped)";};
      tag = "+settings";
    }
    {
      name = "nwg-displays";
      match = {class = "(nwg-displays)";};
      tag = "+settings";
    }

    # ============= FLOATING / POSITIONING =============
    {
      name = "Picture-in-Picture";
      match = {title = "^(Picture-in-Picture)$";};
      float = true;
      move = "72% 7%";
      opacity = "0.95 0.75";
      pin = false;
      keep_aspect_ratio = true;
    }
    {
      name = "ThunarFileMgr";
      match = {
        class = "([Tt]hunar)";
        title = "negative:(.*[Tt]hunar.*)";
      };
      center = true;
      float = true;
    }
    {
      name = "Authentication-Required";
      match = {title = "^(Authentication Required)$";};
      center = true;
      float = true;
    }

    # ============= IDLE INHIBIT =============
    {
      name = "IdleInhibit-fullscreen-1";
      match = {class = ".*";};
      idle_inhibit = "fullscreen";
    }
    {
      name = "IdleInhibit-fullscreen-2";
      match = {title = ".*";};
      idle_inhibit = "fullscreen";
    }
    {
      name = "IdleInhibit-fullscreen-3";
      match = {fullscreen = true;};
      idle_inhibit = "fullscreen";
    }

    # ============= TAG-DRIVEN RULES =============
    {
      name = "Settings-Tag";
      match = {tag = "settings*";};
      float = true;
      opacity = "0.8 0.7";
      size = "70% 70%";
      no_blur = false;
    }
    {
      name = "WayPaper";
      match = {class = "^([Ww]aypaper)$";};
      float = true;
      no_blur = false;
    }
    {
      name = "mpv-or-clapper";
      match = {class = "^(mpv|com.github.rafostar.Clapper)$";};
      float = true;
    }
    {
      name = "codium-url-handler";
      match = {
        class = "(codium|codium-url-handler|VSCodium)";
        title = "negative:(.*codium.*|.*VSCodium.*)";
      };
      float = true;
    }
    {
      name = "heroicgameslauncher-1";
      match = {
        class = "^(com.heroicgameslauncher.hgl)$";
        title = "negative:(Heroic Games Launcher)";
      };
      float = true;
    }
    {
      # Distinct name from the "Steam" workspace rule above: hl.window_rule() treats
      # `name` as a unique key and MERGES rules that share one. Reusing "Steam" here
      # would fold this title-negative matcher into the workspace rule, so the main
      # Steam window (title "Steam") would no longer match -> workspace 8 never applied.
      name = "Steam-dialogs";
      match = {
        class = "^([Ss]team)$";
        title = "negative:^([Ss]team)$";
      };
      float = true;
    }
    {
      name = "Add-Folder";
      match = {initial_title = "(Add Folder to Workspace)";};
      float = true;
      size = "70% 60%";
    }
    {
      name = "Open-File";
      match = {initial_title = "(Open Files)";};
      float = true;
      size = "70% 60%";
    }
    {
      name = "Wants-to-Save";
      match = {initial_title = "(wants to save)";};
      float = true;
    }
    {
      name = "Browsers";
      match = {tag = "browser*";};
      opacity = "1.0 1.0";
    }
    {
      name = "Projects";
      match = {tag = "projects*";};
      opacity = "0.9 0.8";
    }
    {
      name = "Instant-Messaging";
      match = {tag = "im*";};
      opacity = "0.94 0.86";
      workspace = 6;
    }
    {
      # Distinct name from the "Chatterino" tagging rule above (see the Steam note):
      # sharing "Chatterino" merged the two into a rule requiring class=chatterino AND
      # tag=chat* before applying tag +chat - a chicken-and-egg that never fired, so
      # workspace 7 never applied.
      name = "Chatterino-workspace";
      match = {tag = "chat*";};
      opacity = "0.94 0.86";
      workspace = 7;
    }
    {
      name = "File-Managers";
      match = {tag = "file-manager*";};
      opacity = "0.9 0.8";
    }
    {
      name = "Terminals-opacity";
      match = {tag = "terminal*";};
      opacity = "0.8 0.7";
      no_blur = false;
    }
    {
      name = "windowrule-77";
      match = {class = "^(gedit|org.gnome.TextEditor|mousepad)$";};
      opacity = "0.8 0.7";
    }
    {
      name = "windowrule-78";
      match = {class = "^(seahorse)$";};
      opacity = "0.9 0.8";
    }
    {
      name = "windowrule-79";
      match = {tag = "games*";};
      no_blur = true;
    }
    {
      name = "windowrule-80";
      match = {tag = "games*";};
      fullscreen = true;
      workspace = 9;
    }

    # ============= QUICKSHELL VIEWERS =============
    {
      name = "qs-keybinds";
      match = {title = "^(Hyprland Keybinds|Emacs Leader Keybinds|Kitty Configuration|WezTerm Configuration|Ghostty Configuration|Yazi Configuration)$";};
      float = true;
      center = true;
      size = "55% 66%";
    }
    {
      name = "qs-cheatsheets";
      match = {title = "^(Cheatsheets Viewer)$";};
      float = true;
      center = true;
      size = "65% 60%";
    }
    {
      name = "qs-extended-viewers";
      match = {title = "^(Hyprland Keybinds|Niri Keybinds|BSPWM Keybinds|i3 Keybinds|Sway Keybinds|DWM Keybinds|Emacs Leader Keybinds|Kitty Configuration|WezTerm Configuration|Ghostty Configuration|Yazi Configuration|Cheatsheets Viewer|Documentation Viewer)$";};
      float = true;
      center = true;
      size = "55% 66%";
    }
    {
      name = "QS-Wallpapers";
      match = {
        class = "^(org\\.qt-project\\.qml)$";
        title = "^(Wallpapers)$";
      };
      border_size = 0;
      float = true;
      no_blur = true;
      no_shadow = true;
      rounding = 12;
    }
    {
      name = "QA-Video-Wallpapers";
      match = {
        class = "^(org\\.qt-project\\.qml)$";
        title = "^(Video Wallpapers)$";
      };
      border_size = 0;
      center = true;
      float = true;
      no_blur = true;
      no_shadow = true;
      rounding = 12;
    }
    {
      name = "QS-wlogout";
      match = {
        class = "^(org\\.qt-project\\.qml)$";
        title = "^(qs-wlogout)$";
      };
      border_size = 0;
      center = true;
      float = true;
      opacity = "1.0 1.0";
      rounding = 20;
    }
    {
      name = "QA-Panels";
      match = {
        class = "^(org\\.qt-project\\.qml)$";
        title = "^(Panels)$";
      };
      center = true;
      float = true;
      no_blur = true;
      no_shadow = true;
      rounding = 12;
    }
    {
      name = "QS-Cheatsheets";
      match = {
        class = "^(org\\.qt-project\\.qml)$";
        title = "^(Cheatsheets Viewer)$";
      };
      border_size = 0;
      center = true;
      float = true;
      no_shadow = true;
      rounding = 12;
    }
    {
      name = "QS-Documentation-Viewer";
      match = {
        class = "^(org\\.qt-project\\.qml)$";
        title = "^(Documentation Viewer)$";
      };
      border_size = 0;
      center = true;
      float = true;
      no_shadow = true;
      rounding = 12;
    }
  ];
}
