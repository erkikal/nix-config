{...}: {
  imports = [
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    # Both files below are real home-manager modules. Under configType = "lua",
    # home-manager emits each settings.<key> element as a hl.<key>(...) call, so
    # the key MUST match a real Hyprland lua function:
    #   workspaces.nix  -> settings.workspace_rule -> hl.workspace_rule(...)  (monitor bindings)
    #   windowrules.nix -> settings.window_rule    -> hl.window_rule(...)     (window rules)
    ./workspaces.nix
    ./windowrules.nix
  ];
}
