{...}: {
  # Hyprland environment variables.
  #
  # Authored as native Nix records ({ key; value; }) that are handed to
  # lua/env.lua as a structured table and applied directly with hl.env().
  # Values may contain commas or "=" freely - there is no runtime parsing.
  wayland.windowManager.hyprland.settings.env = [
    {
      key = "NIXOS_OZONE_WL";
      value = "1";
    }
    {
      key = "NIXPKGS_ALLOW_UNFREE";
      value = "1";
    }
    {
      key = "XDG_CURRENT_DESKTOP";
      value = "Hyprland";
    }
    {
      key = "XDG_SESSION_TYPE";
      value = "wayland";
    }
    {
      key = "XDG_SESSION_DESKTOP";
      value = "Hyprland";
    }
    {
      key = "GDK_BACKEND";
      value = "wayland,x11";
    }
    {
      key = "CLUTTER_BACKEND";
      value = "wayland";
    }
    {
      key = "QT_QPA_PLATFORM";
      value = "wayland;xcb";
    }
    {
      key = "QT_WAYLAND_DISABLE_WINDOWDECORATION";
      value = "1";
    }
    {
      key = "QT_AUTO_SCREEN_SCALE_FACTOR";
      value = "1";
    }
    {
      key = "SDL_VIDEODRIVER";
      value = "x11";
    }
    {
      key = "MOZ_ENABLE_WAYLAND";
      value = "1";
    }
    # This is to make electron apps start in wayland
    {
      key = "ELECTRON_OZONE_PLATFORM_HINT";
      value = "wayland";
    }
    # Disabling this by default as it can result in inop cfg
    # Added card2 in case this gets enabled. For better coverage
    # This is mostly needed by Hybrid laptops.
    # but if you have multiple discrete GPUs this will set order
    # { key = "AQ_DRM_DEVICES"; value = "/dev/dri/card0:/dev/dri/card1:/dev/card2"; }
    {
      key = "GDK_SCALE";
      value = "1";
    }
    {
      key = "QT_SCALE_FACTOR";
      value = "1";
    }
    {
      key = "EDITOR";
      value = "nvim";
    }
    # Set terminal and xdg_terminal_emulator to ghostty
    # To provent yazi from starting xterm when run from rofi menu
    # You can set to your preferred terminal if you you like
    # ToDo: Pull default terminal from config
    {
      key = "TERMINAL";
      value = "ghostty";
    }
    {
      key = "XDG_TERMINAL_EMULATOR";
      value = "ghostty";
    }
  ];
}
