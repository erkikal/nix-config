{pkgs, ...}: {
  programs.obs-studio = {
    # Disabled: obs-move-transition 3.2.1 fails to build against OBS 32.2.2 (deprecated
    # API + -Werror). Re-enable once the plugin is updated for the new OBS release.
    enable = false;
    #enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-vkcapture
      obs-source-clone
      obs-move-transition
      obs-composite-blur
      obs-backgroundremoval
    ];
  };
}
