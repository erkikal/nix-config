{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.sofka.packages.${pkgs.system}.default
  ];
}
