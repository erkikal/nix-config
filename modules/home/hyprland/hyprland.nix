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
  # Animation presets are authored as hyprlang CSV strings. Parse them into
  # structured records at build time so lua/animations.lua does no parsing and
  # every existing preset (animations-*.nix) keeps working unchanged.
  isNumeric = s: builtins.match "-?[0-9]+(\\.[0-9]+)?" s != null;
  toNum = s: builtins.fromJSON s;
  toBoolean = v: let
    n = lib.toLower (lib.strings.trim v);
  in
    if n == "1" || n == "true" || n == "yes" || n == "on"
    then true
    else if n == "0" || n == "false" || n == "no" || n == "off"
    then false
    else null;
  stripComment = f: let
    m = builtins.match "([^#]*)#.*" f;
  in
    if m == null
    then f
    else builtins.head m;
  splitCsv = entry:
    builtins.filter (s: s != "") (
      map (f: lib.strings.trim (stripComment f)) (lib.splitString "," entry)
    );
  parseCurve = entry: let
    parts = splitCsv entry;
  in
    if builtins.length parts < 5
    then null
    else if !(builtins.all isNumeric (map (i: builtins.elemAt parts i) [1 2 3 4]))
    then null
    else {
      name = builtins.elemAt parts 0;
      points = [
        [(toNum (builtins.elemAt parts 1)) (toNum (builtins.elemAt parts 2))]
        [(toNum (builtins.elemAt parts 3)) (toNum (builtins.elemAt parts 4))]
      ];
    };
  parseAnimation = entry: let
    parts = splitCsv entry;
    len = builtins.length parts;
    enabledRaw = toBoolean (builtins.elemAt parts 1);
    speedStr = builtins.elemAt parts 2;
    style =
      if len > 4
      then lib.strings.trim (lib.concatStringsSep ", " (lib.drop 4 parts))
      else "";
  in
    if len < 4
    then null
    else
      {
        leaf = builtins.elemAt parts 0;
        enabled =
          if enabledRaw == null
          then true
          else enabledRaw;
        speed =
          if isNumeric speedStr
          then toNum speedStr
          else speedStr;
        bezier = builtins.elemAt parts 3;
      }
      // lib.optionalAttrs (style != "") {inherit style;};

  animationSettings = (
    (import zaneyos.animChoice {}).wayland.windowManager.hyprland.settings.animations or {}
  );
  animations = {
    enabled = animationSettings.enabled or true;
    bezier = builtins.filter (c: c != null) (map parseCurve (animationSettings.bezier or []));
    animation = builtins.filter (a: a != null) (map parseAnimation (animationSettings.animation or []));
  };
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
    animation = animations;
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
