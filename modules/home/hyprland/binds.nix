{zaneyos, ...}: let
  inherit
    (zaneyos)
    barChoice
    browser
    terminal
    ;
  # Each bind is a native record: mods/key are authored as plain strings (mods
  # may contain "$modifier"); the chord is normalized once in Nix at build time
  # (see hyprland.nix). dispatcher "exec" runs args as a command, otherwise
  # dispatcher/args map to hl.dsp.* in lua/keybinds.lua. `args` defaults to "".

  # Noctalia-specific bindings (only included when barChoice == "noctalia")
  noctaliaBind =
    if barChoice == "noctalia"
    then [
      {mods = "$modifier"; key = "SPACE"; description = "Noctalia Launcher"; dispatcher = "exec"; args = "noctalia msg panel-toggle launcher";}
      {mods = "$modifier SHIFT"; key = "Return"; description = "Noctalia Launcher"; dispatcher = "exec"; args = "noctalia msg panel-toggle launcher";}
      {mods = "$modifier"; key = "M"; description = "Noctalia Notifications"; dispatcher = "exec"; args = "noctalia msg panel-toggle control-center notifications";}
      {mods = "$modifier"; key = "V"; description = "Noctalia Clipboard"; dispatcher = "exec"; args = "noctalia msg panel-toggle clipboard";}
      {mods = "$modifier ALT"; key = "P"; description = "Noctalia Settings"; dispatcher = "exec"; args = "noctalia msg settings-toggle";}
      {mods = "$modifier SHIFT"; key = "comma"; description = "Noctalia Settings"; dispatcher = "exec"; args = "noctalia msg settings-toggle";}
      {mods = "$modifier CTRL"; key = "L"; description = "Noctalia Lock Screen"; dispatcher = "exec"; args = "noctalia msg session lock";}
      {mods = "$modifier SHIFT"; key = "W"; description = "Noctalia Wallpaper"; dispatcher = "exec"; args = "noctalia msg panel-toggle wallpaper";}
      {mods = "$modifier"; key = "X"; description = "Noctalia Power Menu"; dispatcher = "exec"; args = "noctalia msg panel-toggle session";}
      {mods = "$modifier"; key = "C"; description = "Noctalia Control Center"; dispatcher = "exec"; args = "noctalia msg panel-toggle control-center";}
      {mods = "$modifier CTRL"; key = "R"; description = "Noctalia Screenshot Region"; dispatcher = "exec"; args = "noctalia msg screenshot-region";}
      {mods = "$modifier SHIFT"; key = "R"; description = "Restart Noctalia shell"; dispatcher = "exec"; args = "restart.noctalia";}
    ]
    else [];
  # Rofi launcher bindings (only included when barChoice != "noctalia")
  rofiBind =
    if barChoice != "noctalia"
    then [
      {mods = "$modifier"; key = "SPACE"; description = "Rofi Launcher"; dispatcher = "exec"; args = "rofi-launcher";}
      {mods = "$modifier SHIFT"; key = "Return"; description = "Rofi Launcher"; dispatcher = "exec"; args = "rofi-launcher";}
    ]
    else [];
  # Rofi clipboard binding (only included when barChoice != "noctalia")
  rofiClipboardBind =
    if barChoice != "noctalia"
    then [
      {mods = "$modifier"; key = "V"; description = "Clipboard History"; dispatcher = "exec"; args = "cliphist list | rofi -dmenu | cliphist decode | wl-copy";}
    ]
    else [];
in {
  wayland.windowManager.hyprland.settings = {
    bindd =
      noctaliaBind
      ++ rofiBind
      ++ rofiClipboardBind
      ++ [
        # ============= WORKSPACE OVERVIEW =============
        {mods = "$modifier CTRL"; key = "D"; description = "Toggle Dock"; dispatcher = "exec"; args = "dock";}
        {mods = "$modifier"; key = "TAB"; description = "QS Overview"; dispatcher = "exec"; args = "qs ipc -c overview call overview toggle";}
        # ============= TERMINALS =============
        {mods = "$modifier"; key = "Return"; description = "Terminal"; dispatcher = "exec"; args = "${terminal}";}
        # ============= APPLICATION LAUNCHERS =============
        {mods = "$modifier CTRL"; key = "C"; description = "Cheatsheets Viewer"; dispatcher = "exec"; args = "qs-cheatsheets";}
        {mods = "$modifier SHIFT"; key = "K"; description = "Keybinds Search Tool"; dispatcher = "exec"; args = "qs-keybinds";}
        {mods = "$modifier SHIFT"; key = "D"; description = "Discord"; dispatcher = "exec"; args = "discord";}
        {mods = "$modifier ALT"; key = "W"; description = "Web Search"; dispatcher = "exec"; args = "web-search";}
        {mods = "$modifier SHIFT"; key = "W"; description = "QS Wallpaper Setter"; dispatcher = "exec"; args = "qs-wallpapers-apply";}
        {mods = "$modifier SHIFT"; key = "N"; description = "Notification Reset"; dispatcher = "exec"; args = "swaync-client -rs";}
        {mods = "$modifier"; key = "W"; description = "Web Browser"; dispatcher = "exec"; args = "${browser}";}
        {mods = "$modifier"; key = "Y"; description = "File Manager"; dispatcher = "exec"; args = "${terminal} -e yazi";}
        {mods = "$modifier"; key = "E"; description = "Emoji Picker"; dispatcher = "exec"; args = "emopicker9000";}
        {mods = "$modifier"; key = "S"; description = "Screenshot"; dispatcher = "exec"; args = "screenshootin";}
        # ============= SCREENSHOTS =============
        {mods = "$modifier CTRL"; key = "S"; description = "Screenshot Output"; dispatcher = "exec"; args = "hyprshot -m output -o $HOME/Pictures/ScreenShots";}
        {mods = "$modifier SHIFT"; key = "S"; description = "Screenshot Window"; dispatcher = "exec"; args = "hyprshot -m window -o $HOME/Pictures/ScreenShots";}
        {mods = "$modifier ALT"; key = "S"; description = "Screenshot Region"; dispatcher = "exec"; args = "hyprshot -m region -o $HOME/Pictures/ScreenShots";}
        {mods = "$modifier"; key = "O"; description = "OBS Studio"; dispatcher = "exec"; args = "obs";}
        {mods = "$modifier ALT"; key = "C"; description = "Color Picker"; dispatcher = "exec"; args = "hyprpicker -a";}
        {mods = "$modifier"; key = "G"; description = "GIMP"; dispatcher = "exec"; args = "gimp";}
        {mods = "$modifier SHIFT"; key = "T"; description = "Dropdown Terminal"; dispatcher = "exec"; args = "sh -lc 'DropTerminal'";}
        {mods = "$modifier"; key = "T"; description = "Thunar"; dispatcher = "exec"; args = "thunar";}
        {mods = "$modifier ALT"; key = "M"; description = "Audio Control"; dispatcher = "exec"; args = "pavucontrol";}
        # ============= WINDOW MANAGEMENT =============
        {mods = "$modifier"; key = "Q"; description = "Kill Active Window"; dispatcher = "killactive";}
        {mods = "$modifier"; key = "P"; description = "Pseudo Tile"; dispatcher = "pseudo";}
        {mods = "$modifier SHIFT"; key = "I"; description = "Toggle Split"; dispatcher = "layoutmsg"; args = "togglesplit";}
        {mods = "$modifier"; key = "F"; description = "Maximize"; dispatcher = "fullscreen";}
        {mods = "$modifier SHIFT"; key = "F"; description = "Toggle Floating"; dispatcher = "togglefloating";}
        {mods = "$modifier ALT"; key = "F"; description = "Float All Windows"; dispatcher = "exec"; args = "hyprland-float-all";}
        # ============= LAYOUTS =============
        {mods = "$modifier ALT"; key = "L"; description = "Toggle Layouts"; dispatcher = "exec"; args = "hyprland-change-layout toggle";}
        {mods = "$modifier ALT"; key = "1"; description = "Layout Dwindle"; dispatcher = "exec"; args = "hyprland-change-layout dwindle";}
        {mods = "$modifier ALT"; key = "2"; description = "Layout Master"; dispatcher = "exec"; args = "hyprland-change-layout master";}
        {mods = "$modifier ALT"; key = "3"; description = "Layout Scrolling"; dispatcher = "exec"; args = "hyprland-change-layout scrolling";}
        {mods = "$modifier ALT"; key = "4"; description = "Layout Monocle"; dispatcher = "exec"; args = "hyprland-change-layout monocle";}
        {mods = "$modifier SHIFT"; key = "C"; description = "Exit/Logout of Hyprland"; dispatcher = "exit";}
        # ============= WINDOW MOVEMENT (ARROW KEYS) =============
        {mods = "$modifier SHIFT"; key = "left"; description = "Move Left"; dispatcher = "movewindow"; args = "l";}
        {mods = "$modifier SHIFT"; key = "right"; description = "Move Right"; dispatcher = "movewindow"; args = "r";}
        {mods = "$modifier SHIFT"; key = "up"; description = "Move Up"; dispatcher = "movewindow"; args = "u";}
        {mods = "$modifier SHIFT"; key = "down"; description = "Move Down"; dispatcher = "movewindow"; args = "d";}
        # ============= WINDOW MOVEMENT (VI STYLE) =============
        {mods = "$modifier SHIFT"; key = "h"; description = "Move Left (VI)"; dispatcher = "movewindow"; args = "l";}
        {mods = "$modifier SHIFT"; key = "l"; description = "Move Right (VI)"; dispatcher = "movewindow"; args = "r";}
        {mods = "$modifier SHIFT"; key = "k"; description = "Move Up (VI)"; dispatcher = "movewindow"; args = "u";}
        {mods = "$modifier SHIFT"; key = "j"; description = "Move Down (VI)"; dispatcher = "movewindow"; args = "d";}
        # ============= WINDOW SWAPPING (ARROW KEYS) =============
        {mods = "$modifier ALT"; key = "left"; description = "Swap Left"; dispatcher = "swapwindow"; args = "l";}
        {mods = "$modifier ALT"; key = "right"; description = "Swap Right"; dispatcher = "swapwindow"; args = "r";}
        {mods = "$modifier ALT"; key = "up"; description = "Swap Up"; dispatcher = "swapwindow"; args = "u";}
        {mods = "$modifier ALT"; key = "down"; description = "Swap Down"; dispatcher = "swapwindow"; args = "d";}
        # ============= WINDOW SWAPPING (VI KEYCODES) =============
        {mods = "$modifier ALT"; key = "43"; description = "Swap Left (VI)"; dispatcher = "swapwindow"; args = "l";}
        {mods = "$modifier ALT"; key = "46"; description = "Swap Right (VI)"; dispatcher = "swapwindow"; args = "r";}
        {mods = "$modifier ALT"; key = "45"; description = "Swap Up (VI)"; dispatcher = "swapwindow"; args = "u";}
        {mods = "$modifier ALT"; key = "44"; description = "Swap Down (VI)"; dispatcher = "swapwindow"; args = "d";}
        # ============= FOCUS MOVEMENT (ARROW KEYS) =============
        {mods = "$modifier"; key = "left"; description = "Focus Left"; dispatcher = "movefocus"; args = "l";}
        {mods = "$modifier"; key = "right"; description = "Focus Right"; dispatcher = "movefocus"; args = "r";}
        {mods = "$modifier"; key = "up"; description = "Focus Up"; dispatcher = "movefocus"; args = "u";}
        {mods = "$modifier"; key = "down"; description = "Focus Down"; dispatcher = "movefocus"; args = "d";}
        # ============= FOCUS MOVEMENT (VI STYLE) =============
        {mods = "$modifier"; key = "h"; description = "Focus Left (VI)"; dispatcher = "movefocus"; args = "l";}
        {mods = "$modifier"; key = "l"; description = "Focus Right (VI)"; dispatcher = "movefocus"; args = "r";}
        {mods = "$modifier"; key = "k"; description = "Focus Up (VI)"; dispatcher = "movefocus"; args = "u";}
        {mods = "$modifier"; key = "j"; description = "Focus Down (VI)"; dispatcher = "movefocus"; args = "d";}
        # ============= WORKSPACE SWITCHING (1-10) =============
        {mods = "$modifier"; key = "1"; description = "Workspace 1"; dispatcher = "workspace"; args = "1";}
        {mods = "$modifier"; key = "2"; description = "Workspace 2"; dispatcher = "workspace"; args = "2";}
        {mods = "$modifier"; key = "3"; description = "Workspace 3"; dispatcher = "workspace"; args = "3";}
        {mods = "$modifier"; key = "4"; description = "Workspace 4"; dispatcher = "workspace"; args = "4";}
        {mods = "$modifier"; key = "5"; description = "Workspace 5"; dispatcher = "workspace"; args = "5";}
        {mods = "$modifier"; key = "6"; description = "Workspace 6"; dispatcher = "workspace"; args = "6";}
        {mods = "$modifier"; key = "7"; description = "Workspace 7"; dispatcher = "workspace"; args = "7";}
        {mods = "$modifier"; key = "8"; description = "Workspace 8"; dispatcher = "workspace"; args = "8";}
        {mods = "$modifier"; key = "9"; description = "Workspace 9"; dispatcher = "workspace"; args = "9";}
        {mods = "$modifier"; key = "0"; description = "Workspace 10"; dispatcher = "workspace"; args = "10";}
        # ============= MOVE WINDOW TO WORKSPACE (1-10) =============
        {mods = "$modifier CTRL SHIFT"; key = "SPACE"; description = "Move to Special"; dispatcher = "movetoworkspace"; args = "special";}
        {mods = "$modifier SHIFT"; key = "SPACE"; description = "Toggle Special"; dispatcher = "togglespecialworkspace";}
        {mods = "$modifier SHIFT"; key = "1"; description = "Move to Workspace 1"; dispatcher = "movetoworkspace"; args = "1";}
        {mods = "$modifier SHIFT"; key = "2"; description = "Move to Workspace 2"; dispatcher = "movetoworkspace"; args = "2";}
        {mods = "$modifier SHIFT"; key = "3"; description = "Move to Workspace 3"; dispatcher = "movetoworkspace"; args = "3";}
        {mods = "$modifier SHIFT"; key = "4"; description = "Move to Workspace 4"; dispatcher = "movetoworkspace"; args = "4";}
        {mods = "$modifier SHIFT"; key = "5"; description = "Move to Workspace 5"; dispatcher = "movetoworkspace"; args = "5";}
        {mods = "$modifier SHIFT"; key = "6"; description = "Move to Workspace 6"; dispatcher = "movetoworkspace"; args = "6";}
        {mods = "$modifier SHIFT"; key = "7"; description = "Move to Workspace 7"; dispatcher = "movetoworkspace"; args = "7";}
        {mods = "$modifier SHIFT"; key = "8"; description = "Move to Workspace 8"; dispatcher = "movetoworkspace"; args = "8";}
        {mods = "$modifier SHIFT"; key = "9"; description = "Move to Workspace 9"; dispatcher = "movetoworkspace"; args = "9";}
        {mods = "$modifier SHIFT"; key = "0"; description = "Move to Workspace 10"; dispatcher = "movetoworkspace"; args = "10";}
        # ============= WORKSPACE NAVIGATION =============
        {mods = "$modifier CONTROL"; key = "right"; description = "Next Workspace"; dispatcher = "workspace"; args = "e+1";}
        {mods = "$modifier CONTROL"; key = "left"; description = "Previous Workspace"; dispatcher = "workspace"; args = "e-1";}
        {mods = "$modifier CONTROL"; key = "l"; description = "Next Workspace"; dispatcher = "workspace"; args = "e+1";}
        {mods = "$modifier CONTROL"; key = "h"; description = "Previous Workspace"; dispatcher = "workspace"; args = "e-1";}
        {mods = "$modifier"; key = "mouse_down"; description = "Next Workspace Mouse"; dispatcher = "workspace"; args = "e+1";}
        {mods = "$modifier"; key = "mouse_up"; description = "Previous Workspace Mouse"; dispatcher = "workspace"; args = "e-1";}
        {mods = "$modifier SHIFT CONTROL"; key = "l"; description = "Workspace to Next"; dispatcher = "movecurrentworkspacetomonitor"; args = "+1";}
        {mods = "$modifier SHIFT CONTROL"; key = "h"; description = "Workspace to Previous"; dispatcher = "movecurrentworkspacetomonitor"; args = "-1";}
        # ============= WINDOW CYCLING =============
        {mods = "ALT"; key = "Tab"; description = "Cycle Next Window"; dispatcher = "cyclenext";}
        {mods = "ALT"; key = "Tab"; description = "Bring Active To Top"; dispatcher = "bringactivetotop";}
        # ============= MEDIA & HARDWARE CONTROLS =============
        {mods = ""; key = "XF86AudioRaiseVolume"; description = "Volume Up"; dispatcher = "exec"; args = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";}
        {mods = ""; key = "XF86AudioLowerVolume"; description = "Volume Down"; dispatcher = "exec"; args = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";}
        {mods = ""; key = "XF86AudioMute"; description = "Mute Toggle"; dispatcher = "exec"; args = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";}
        {mods = ""; key = "XF86AudioPlay"; description = "Play Pause"; dispatcher = "exec"; args = "playerctl play-pause";}
        {mods = ""; key = "XF86AudioPause"; description = "Play Pause"; dispatcher = "exec"; args = "playerctl play-pause";}
        {mods = ""; key = "XF86AudioNext"; description = "Next Track"; dispatcher = "exec"; args = "playerctl next";}
        {mods = ""; key = "XF86AudioPrev"; description = "Previous Track"; dispatcher = "exec"; args = "playerctl previous";}
        {mods = ""; key = "XF86MonBrightnessDown"; description = "Brightness Down"; dispatcher = "exec"; args = "brightnessctl set 5%-";}
        {mods = ""; key = "XF86MonBrightnessUp"; description = "Brightness Up"; dispatcher = "exec"; args = "brightnessctl set +5%";}
      ];

    bindm = [
      {mods = "$modifier"; key = "mouse:272"; dispatcher = "movewindow";}
      {mods = "$modifier"; key = "mouse:273"; dispatcher = "resizewindow";}
    ];
  };
}
