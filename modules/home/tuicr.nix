{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.tuicr.packages.${pkgs.system}.default
  ];
}
