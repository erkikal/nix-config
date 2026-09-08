# Theme for yazi, written to ~/.config/yazi/theme.toml by home-manager
# (`programs.yazi.theme`).
#
# Same approach as the reference dotfiles: the upstream Catppuccin theme is
# parsed with `fromTOML` and fed straight into Nix, so there is no vendored
# `flavors/` directory and no hand-maintained copy of an 800-line theme that
# silently rots when yazi renames a section (which is what happened to the old
# theme.toml and flavor.toml: both still used the pre-25.x `[manager]`,
# `[select]` and `[completion]` names and were ignored by yazi).
#
# Only our own overrides are written by hand below.
{
  lib,
  pkgs,
  palette,
  # tmTheme used for syntax highlighting in the code preview. The upstream
  # theme points at a file it does not ship, so we reuse the Catppuccin
  # tmTheme that bat already pulls in (see modules/home/cli/bat.nix).
  syntectTheme,
}: let
  flavour = "macchiato";
  # One of the accents in themes/${flavour}/ — the accent tints the hovered
  # item, tabs and borders.
  accent = "sapphire";

  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "yazi";
    rev = "d62802be39210ea10e54b3e3b09735c6cb9e57c1";
    hash = "sha256-bwzEO8exoBwa19q+jnYjHkaamGl2mhfukIEhDfUCRGI=";
  };

  upstream = builtins.fromTOML (
    builtins.readFile "${src}/themes/${flavour}/catppuccin-${flavour}-${accent}.toml"
  );
in
  lib.recursiveUpdate upstream {
    mgr.syntect_theme = syntectTheme;

    # Status signs for the git plugin — not part of the upstream theme.
    # https://github.com/yazi-rs/plugins/tree/main/git.yazi
    git = {
      modified.fg = palette.yellow;
      added.fg = palette.green;
      untracked.fg = palette.pink;
      ignored.fg = palette.overlay0;
      deleted.fg = palette.red;
      updated.fg = palette.blue;
      unknown.fg = palette.overlay0;
      clean.fg = palette.overlay0;
    };
  }
