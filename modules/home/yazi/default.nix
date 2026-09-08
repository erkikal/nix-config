# yazi — terminal file manager.
#
# The whole configuration lives in Nix: home-manager renders
# `programs.yazi.{settings,keymap,theme,initLua}` into
# ~/.config/yazi/{yazi,keymap,theme}.toml and init.lua, so there are no raw
# TOML/Lua files to keep in sync.
#
# Only overrides are declared here — yazi merges these over its own presets.
#
# The stylix yazi target stays disabled (modules/home/stylix.nix); colours come
# from the upstream Catppuccin theme plus palette.nix, which is also what the
# yatline status line reads, so a flavour change is one edit in palette.nix +
# theme.nix.
{
  config,
  lib,
  pkgs,
  ...
}: let
  palette = import ./palette.nix;
in {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    shellWrapperName = "yy";

    # Plugins come from nixpkgs instead of `ya pkg`/vendored copies.
    # Linked to ~/.config/yazi/plugins/<name>.yazi
    #
    # `session`, `zoxide` and the archive/media previewers are bundled with
    # yazi itself and need no entry here.
    plugins = {
      inherit
        (pkgs.yaziPlugins)
        compress # `c a` — archive the selection
        easyjump # `s` — jump to a visible file by label
        full-border # rounded border around the panes
        git # git status signs in the linemode
        lazygit # `g i` — open lazygit in the cwd
        smart-enter # `l`/`<Enter>` — enter dir or open file
        smart-filter # `f F`
        toggle-pane # `T` — hide/show the preview pane
        yafg # `f g` — fuzzy content search
        yatline # header/status line
        yatline-githead # git segment for yatline
        ;
    };

    # Tools the plugins and openers shell out to.
    extraPackages = with pkgs; [
      bat
      fd
      fzf
      lazygit
      p7zip
      ripgrep
      unzip
      zip
    ];

    settings = {
      mgr = {
        ratio = [1 4 3];
        sort_by = "natural";
        sort_dir_first = true;
        show_hidden = true;
        show_symlink = true;
      };

      # Register the git plugin as a fetcher (per its README): one rule for
      # files, one for directories.
      plugin.prepend_fetchers = [
        {
          url = "*";
          run = "git";
          group = "git";
        }
        {
          url = "*/";
          run = "git";
          group = "git";
        }
      ];

      opener = {
        folder = [
          {
            run = ''hyprctl dispatch exec "[float; size 60% 60%; center 1] nemo" %S'';
            orphan = true;
            desc = "nemo";
            for = "linux";
          }
          {
            run = "nvim %s";
            block = true;
            desc = "neovim";
            for = "linux";
          }
          {
            run = "kitty --detach nvim %s";
            orphan = true;
            desc = "neovim (detached)";
            for = "linux";
          }
          {
            run = "lazygit -p %s";
            block = true;
            desc = "lazygit";
            for = "linux";
          }
          {
            run = "codium %S";
            orphan = true;
            desc = "vscodium";
            for = "linux";
          }
          {
            run = "kitty %S";
            orphan = true;
            desc = "kitty";
            for = "linux";
          }
          {
            run = "xdg-open %s1";
            orphan = true;
            desc = "xdg-open";
            for = "linux";
          }
        ];

        text = [
          {
            run = "\${EDITOR:-nvim} %s";
            block = true;
            desc = "$EDITOR";
            for = "linux";
          }
          {
            run = "nvim %s";
            block = true;
            desc = "neovim";
            for = "linux";
          }
          {
            run = "kitty --detach nvim %s";
            orphan = true;
            desc = "neovim (detached)";
            for = "linux";
          }
          {
            run = "codium %S";
            orphan = true;
            desc = "vscodium";
            for = "linux";
          }
          {
            run = "xdg-open %s1";
            orphan = true;
            desc = "xdg-open";
            for = "linux";
          }
        ];

        document = [
          {
            run = "xdg-open %s1";
            orphan = true;
            desc = "xdg-open";
            for = "linux";
          }
          {
            run = "zathura %s1";
            orphan = true;
            desc = "zathura";
            for = "linux";
          }
          {
            run = "libreoffice %s1";
            orphan = true;
            desc = "libreoffice";
            for = "linux";
          }
        ];

        image = [
          {
            run = "xdg-open %s1";
            orphan = true;
            desc = "xdg-open";
            for = "linux";
          }
          {
            run = "qimgv %s1";
            orphan = true;
            desc = "qimgv";
            for = "linux";
          }
          {
            run = "krita %s1";
            orphan = true;
            desc = "krita";
            for = "linux";
          }
          {
            run = "satty --filename %s1";
            orphan = true;
            desc = "satty";
            for = "linux";
          }
        ];

        video = [
          {
            run = "xdg-open %s1";
            orphan = true;
            desc = "xdg-open";
            for = "linux";
          }
          {
            run = "mpv %s1";
            orphan = true;
            desc = "mpv";
            for = "linux";
          }
        ];

        audio = [
          {
            run = "xdg-open %s1";
            orphan = true;
            desc = "xdg-open";
            for = "linux";
          }
          {
            run = "mpv %s1";
            orphan = true;
            desc = "mpv";
            for = "linux";
          }
        ];
      };

      # `prepend_rules` keeps yazi's preset rules (trash, virtual files, the
      # `url = "*"` fallback) in place below ours. Archives use the preset
      # `extract` opener — the old config pointed at an `archive` opener that
      # was never defined, so archives simply did not open.
      open.prepend_rules = [
        {
          mime = "folder/*";
          use = "folder";
        }
        {
          mime = "text/*";
          use = "text";
        }
        {
          mime = "inode/empty";
          use = "text";
        }
        {
          mime = "application/{json,ndjson}";
          use = "text";
        }
        {
          mime = "image/*";
          use = "image";
        }
        {
          mime = "video/*";
          use = "video";
        }
        {
          mime = "application/octet-stream";
          use = "video";
        }
        {
          mime = "audio/*";
          use = "audio";
        }
        {
          mime = "application/{pdf,epub+zip,x-mobipocket-ebook}";
          use = "document";
        }
        {
          mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
          use = ["extract" "reveal"];
        }
      ];
    };

    keymap = import ./keymap.nix;

    initLua = import ./init-lua.nix {inherit palette;};

    theme = import ./theme.nix {
      inherit lib pkgs palette;
      # Reuse the Catppuccin tmTheme that bat already pins, so the code
      # preview and `bat` stay in sync (modules/home/cli/bat.nix).
      syntectTheme = "${config.programs.bat.themes.catppuccin.src}/themes/Catppuccin Macchiato.tmTheme";
    };
  };
}
