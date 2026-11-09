{pkgs, ...}: {
  programs.uv = {
    enable = true;
    tool = {
      packages = [
        "cyberdrop-dl-patched"
      ];
    };
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
