# Keymap overrides for yazi, written to ~/.config/yazi/keymap.toml by
# home-manager (`programs.yazi.keymap`).
#
# Only overrides live here: yazi merges `prepend_keymap`/`append_keymap` over
# its own preset keymap, so there is no need to restate the defaults.
#
# Section names follow yazi >= 25.5.28: `mgr` (was `manager`) and `cmp` (was
# `completion`). Unknown sections are silently ignored by yazi, which is why
# the old `[manager]`/`[completion]` blocks had no effect.
{
  mgr.prepend_keymap = [
    {
      on = "l";
      run = "plugin smart-enter";
      desc = "Enter the child directory, or open the file";
    }
    {
      on = "<Enter>";
      run = "plugin smart-enter";
      desc = "Enter the child directory, or open the file";
    }
    {
      on = "<C-s>";
      run = ''shell "$SHELL" --block --confirm'';
      desc = "Open shell here";
    }
    {
      on = ["c" "a"];
      run = "plugin compress";
      desc = "Archive selected files";
    }
    {
      on = "<C-u>";
      run = "seek -5";
      desc = "Seek up 5 units in the preview";
    }
    {
      on = "<C-d>";
      run = "seek 5";
      desc = "Seek down 5 units in the preview";
    }
    {
      on = "K";
      run = "arrow -50%";
      desc = "Move cursor up half page";
    }
    {
      on = "J";
      run = "arrow 50%";
      desc = "Move cursor down half page";
    }
    {
      on = "<A-k>";
      run = "arrow -5";
      desc = "Move cursor up 5 units";
    }
    {
      on = "<A-j>";
      run = "arrow 5";
      desc = "Move cursor down 5 units";
    }
    {
      # yafg replaces the unmaintained fg plugin; ripgrep/fzf modes are
      # toggled inside the picker with <A-t> (see initLua).
      on = ["f" "g"];
      run = "plugin yafg";
      desc = "Find file by content (fuzzy/ripgrep)";
    }
    {
      on = ["f" "G"];
      run = "search rg";
      desc = "Search files by content using ripgrep";
    }
    {
      on = ["f" "n"];
      run = "search fd";
      desc = "Search files by name using fd";
    }
    {
      on = ["f" "f"];
      run = "filter --smart";
      desc = "Filter files";
    }
    {
      on = ["f" "F"];
      run = "plugin smart-filter";
      desc = "Smart filter";
    }
    {
      # easyjump replaces the unmaintained searchjump plugin.
      on = "s";
      run = "plugin easyjump";
      desc = "Jump to a visible file by label";
    }
    {
      on = "S";
      run = "search fd";
      desc = "Search files by name using fd";
    }
    {
      # toggle-pane replaces the removed hide-preview plugin.
      on = "T";
      run = "plugin toggle-pane min-preview";
      desc = "Hide or show the preview pane";
    }
    {
      on = "y";
      run = [
        ''shell 'for path in "$@"; do echo "file://$path"; done | wl-copy -t text/uri-list' --confirm''
        "yank"
      ];
      desc = "Yank files and copy to clipboard";
    }
    {
      on = "A";
      run = "create --dir";
      desc = "Create a dir";
    }
    {
      on = ["g" "i"];
      run = "plugin lazygit";
      desc = "Open lazygit here";
    }
  ];

  mgr.append_keymap = [
    {
      on = "e";
      run = "open";
      desc = "Open the selected files";
    }
    {
      on = "E";
      run = "open --interactive";
      desc = "Open the selected files interactively";
    }
    {
      on = ["g" "n"];
      run = "cd ~/.config/nvim/";
      desc = "Go to the nvim directory";
    }
    {
      on = ["g" "v"];
      run = "cd ~/videos/";
      desc = "Go to the videos directory";
    }
    {
      on = ["g" "p"];
      run = "cd ~/pictures/";
      desc = "Go to the pictures directory";
    }
    {
      on = ["g" "s"];
      run = "cd ~/pictures/screenshots/";
      desc = "Go to the screenshots directory";
    }
    {
      on = ["g" "D"];
      run = "cd ~/documents/";
      desc = "Go to the docs directory";
    }
    {
      on = ["g" "o"];
      run = "cd ~/documents/obsidian-vaults";
      desc = "Go to the obsidian directory";
    }
    {
      on = ["g" "e"];
      run = "cd ~/dev/";
      desc = "Go to the dev directory";
    }
  ];

  input.prepend_keymap = [
    {
      on = "<Esc>";
      run = "close";
      desc = "Cancel input";
    }
  ];

  cmp.prepend_keymap = [
    {
      on = "<C-k>";
      run = "arrow -1";
      desc = "Move cursor up";
    }
    {
      on = "<C-j>";
      run = "arrow 1";
      desc = "Move cursor down";
    }
  ];
}
