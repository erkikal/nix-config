{
  pkgs,
  config,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["v4l2loopback" "i2c-dev"];
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    kernel.sysctl = {"vm.max_map_count" = 2147483642;};
    loader.efi.canTouchEfiVariables = true;
    loader.limine = {
      enable = true;
      efiSupport = true;
      maxGenerations = 4;
    #  extraEntries = ''
    #    /+Windows 11
    #      protocol: efi
    #      path: uuid(80c0ba37-9cf5-4ca2-860c-95aef66b3dae):/EFI/Microsoft/Boot/bootmgfw.efi
    #  '';
    #  extraConfig = ''
    #    # remember_last_entry: yes
    #  '';
    };
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = false;
  };
}
