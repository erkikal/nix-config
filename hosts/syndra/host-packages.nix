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
        # "com.rustdesk.RustDesk"
        "me.amankhanna.opendeck"
        "com.github.tchx84.Flatseal"
      ];
    };
  };

  services.openxlr.enable = true;

  services.ratbagd.enable = true;
  services.auto-cpufreq.enable = false;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  # services.onedrive.enable = true;

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
  };
}
