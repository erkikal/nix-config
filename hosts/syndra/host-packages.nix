{
  configs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    #  Add local pacakaged here
    audacity
    ddcutil
    discord
    ferium
    i2c-tools
    keepassxc
    keymapp
    nodejs
    nohang
    onedrive
    piper
    rustdesk-flutter
    spotify
    telegram-desktop
    vivaldi
  ];
  # Add host specific flatpaks here
  services = {
    flatpak = {
      packages = [
        # "com.core447.StreamController"
        "com.chatterino.chatterino"
        "com.rustdesk.RustDesk"
        "me.amankhanna.opendeck"
        "com.github.tchx84.Flatseal"
      ];
    };

    openxlr.enable = true;

    ratbagd.enable = true;
    auto-cpufreq.enable = false;
    auto-cpufreq.settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };

    # onedrive.enable = true;

    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
      openFirewall = true;
    };
  };
}
