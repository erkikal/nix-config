{
  zaneyos,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (zaneyos) extraMonitorSettings;
  keyboardLayout = zaneyos.keyboardLayout;
  keyboardVariant = zaneyos.keyboardVariant;
  toLua = lib.generators.toLua {};

  # Treat only known US-based variants as implying layout = "us".
  usVariants = [
    "dvorak"
    "colemak"
    "workman"
    "intl"
    "us-intl"
    "altgr-intl"
  ];
  normalizeUSVariant = v:
    if v == "us-intl"
    then "intl"
    else v;

  # If layout itself is a US variant (e.g., "dvorak", "us-intl"), normalize it
  layoutFromLayout =
    if builtins.elem keyboardLayout usVariants
    then "us"
    else keyboardLayout;
  variantFromLayout =
    if builtins.elem keyboardLayout usVariants
    then normalizeUSVariant keyboardLayout
    else "";

  # If the provided variant is a US variant, force layout to us; otherwise keep layout
  layoutFromVariant =
    if builtins.elem keyboardVariant usVariants
    then "us"
    else layoutFromLayout;
  variantFinal =
    if builtins.elem keyboardVariant usVariants
    then normalizeUSVariant keyboardVariant
    else if variantFromLayout != ""
    then variantFromLayout
    else keyboardVariant;

  hyprKbLayout = layoutFromVariant;
  hyprKbVariant = variantFinal;

  bindSettings =
    (import ./binds.nix {inherit zaneyos;}).wayland.windowManager.hyprland.settings or {};
  binddEntries = bindSettings.bindd or [];
  bindmEntries = bindSettings.bindm or [];

  envEntries = (import ./env.nix {}).wayland.windowManager.hyprland.settings.env or [];
  execOnceEntries = (
    (import ./exec-once.nix {inherit zaneyos;}).wayland.windowManager.hyprland.settings.exec-once
      or []
  );
  animationSettings = (
    (import zaneyos.animChoice {}).wayland.windowManager.hyprland.settings.animations or {}
  );
  windowRules = (
    (import ./windowrules.nix {}).wayland.windowManager.hyprland.settings.windowRules or []
  );

  # Parse a raw hyprlang "monitor = OUT,MODE,POS,SCALE[,transform,N,...]" line
  # into a structured record at build time so lua/monitors.lua does no parsing.
  # Trailing "keyword,value" pairs (transform, vrr, bitdepth, ...) are folded in;
  # only transform is surfaced today - extend here as hosts need more.
  parseMonitor = raw: let
    afterKw = lib.strings.trim (lib.removePrefix "monitor" (lib.strings.trim raw));
    body = lib.strings.trim (lib.removePrefix "=" afterKw);
    fields = map lib.strings.trim (lib.splitString "," body);
    field = i:
      if builtins.length fields > i
      then builtins.elemAt fields i
      else "";
    extras =
      if builtins.length fields > 4
      then lib.drop 4 fields
      else [];
    pairsToAttrs = acc: xs:
      if builtins.length xs >= 2
      then
        pairsToAttrs (acc // {${builtins.elemAt xs 0} = builtins.elemAt xs 1;})
        (lib.drop 2 xs)
      else acc;
    extraAttrs = pairsToAttrs {} extras;
  in
    {
      output = field 0;
      mode = field 1;
      position = field 2;
      scale = field 3;
    }
    // lib.optionalAttrs (extraAttrs ? transform) {
      transform = lib.toInt extraAttrs.transform;
    };

  monitors =
    [
      # Catch-all default. Kept for parity with the previous config; it carries
      # an empty output and is skipped by monitors.lua, matching prior behavior.
      {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = "auto";
      }
      {
        output = "Virtual-1";
        mode = "1920x1080@60";
        position = "auto";
        scale = "1";
      }
    ]
    ++ map parseMonitor (
      builtins.filter (line: line != "") (
        map lib.strings.trim (lib.splitString "\n" extraMonitorSettings)
      )
    );

  zaneyosLuaConfig = {
    modifier = "SUPER";
    keyboard = {
      layout = hyprKbLayout;
      variant = hyprKbVariant;
    };
    theme = {
      base01 = config.lib.stylix.colors.base01;
      base08 = config.lib.stylix.colors.base08;
      base0C = config.lib.stylix.colors.base0C;
    };
    env = envEntries;
    execOnce = execOnceEntries;
    bindd = binddEntries;
    bindm = bindmEntries;
    monitors = monitors;
    animation = {
      enabled = animationSettings.enabled or true;
      bezier = animationSettings.bezier or [];
      animation = animationSettings.animation or [];
    };
    windowRules = windowRules;
  };
in {
  home.packages = with pkgs; [
    awww
    grim
    slurp
    wl-clipboard
    swappy
    ydotool
    hyprpolkitagent
    hyprshot
    hyprshutdown
    hyprpicker
    #hyprland-qtutils # needed for banners and ANR messages
  ];
  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
  # Place Files Inside Home Directory
  home.file = {
    "Pictures/Wallpapers" = {
      source = ../../../wallpapers;
      recursive = true;
    };
    ".face.icon".source = ./face.jpg;
    ".config/face.jpg".source = ./face.jpg;
  };
  wayland.windowManager.hyprland = {
    configType = "lua";
    enable = true;
    package = pkgs.hyprland;
    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = ["--all"];
    };
    xwayland = {
      enable = true;
    };
    extraConfig = ''
      require("zaneyos.vars")
      require("zaneyos.settings")
      require("zaneyos.monitors")
      require("zaneyos.env")
      require("zaneyos.animations")
      require("zaneyos.window_rules")
      require("zaneyos.startup")
      require("zaneyos.keybinds")
      -- require("zaneyos.workspace_rules")
    '';
    extraLuaFiles = {
      "zaneyos.vars" = {
        autoLoad = false;
        content = ''
          ZANEYOS = ${toLua zaneyosLuaConfig}
        '';
      };
      "zaneyos.settings" = {
        autoLoad = false;
        content = ./lua/settings.lua;
      };
      "zaneyos.monitors" = {
        autoLoad = false;
        content = ./lua/monitors.lua;
      };
      "zaneyos.env" = {
        autoLoad = false;
        content = ./lua/env.lua;
      };
      "zaneyos.animations" = {
        autoLoad = false;
        content = ./lua/animations.lua;
      };
      "zaneyos.window_rules" = {
        autoLoad = false;
        content = ./lua/window_rules.lua;
      };
      "zaneyos.workspace_rules" = {
        autoLoad = false;
        content = ./lua/workspace_rules.lua;
      };
      "zaneyos.startup" = {
        autoLoad = false;
        content = ./lua/startup.lua;
      };
      "zaneyos.keybinds" = {
        autoLoad = false;
        content = ./lua/keybinds.lua;
      };
    };
  };
}
