# Lua init for yazi, written to ~/.config/yazi/init.lua by home-manager
# (`programs.yazi.initLua`).
#
# The colours are interpolated from palette.nix instead of being duplicated as
# a hardcoded Lua table, so the status line always matches theme.toml.
{palette}: ''
  -- Managed by home-manager (modules/home/yazi/init-lua.nix); do not edit.

  local palette = {
  	base = "${palette.base}",
  	surface0 = "${palette.surface0}",
  	text = "${palette.text}",
  	blue = "${palette.blue}",
  	green = "${palette.green}",
  	lavender = "${palette.lavender}",
  	mauve = "${palette.mauve}",
  	pink = "${palette.pink}",
  	red = "${palette.red}",
  	sky = "${palette.sky}",
  	teal = "${palette.teal}",
  	yellow = "${palette.yellow}",
  }

  -- Plugins
  require("full-border"):setup({
  	type = ui.Border.ROUNDED,
  })

  -- Bundled with yazi (no plugin install needed).
  require("zoxide"):setup({
  	update_db = true,
  })

  require("session"):setup({
  	sync_yanked = true,
  })

  -- Git status signs in the linemode; the fetchers are registered in
  -- `programs.yazi.settings.plugin.prepend_fetchers`.
  require("git"):setup({
  	order = 1500,
  })

  -- Fuzzy content search (replaces the unmaintained fg plugin).
  require("yafg"):setup({
  	toggle_mode_key = "alt-t",
  	editor = "nvim",
  })

  require("yatline"):setup({
  	section_separator = { open = "", close = "" },
  	inverse_separator = { open = "", close = "" },
  	part_separator = { open = "", close = "" },

  	style_a = {
  		fg = palette.base,
  		bg_mode = {
  			normal = palette.blue,
  			select = palette.mauve,
  			un_set = palette.red,
  		},
  	},
  	style_b = { bg = palette.surface0, fg = palette.text },
  	style_c = { bg = palette.base, fg = palette.text },

  	permissions_t_fg = palette.green,
  	permissions_r_fg = palette.yellow,
  	permissions_w_fg = palette.red,
  	permissions_x_fg = palette.sky,
  	permissions_s_fg = palette.lavender,

  	selected = { icon = "󰻭", fg = palette.yellow },
  	copied = { icon = "", fg = palette.green },
  	cut = { icon = "", fg = palette.red },

  	total = { icon = "", fg = palette.yellow },
  	succ = { icon = "", fg = palette.green },
  	fail = { icon = "", fg = palette.red },
  	found = { icon = "", fg = palette.blue },
  	processed = { icon = "", fg = palette.green },

  	tab_width = 20,
  	tab_use_inverse = true,

  	show_background = false,

  	display_header_line = true,
  	display_status_line = true,

  	header_line = {
  		left = {
  			section_a = {
  				{ type = "line", custom = false, name = "tabs", params = { "left" } },
  			},
  			section_b = {
  				{ type = "coloreds", custom = false, name = "githead" },
  			},
  			section_c = {},
  		},
  		right = {
  			section_a = {
  				{ type = "string", custom = false, name = "tab_path" },
  			},
  			section_b = {
  				{ type = "coloreds", custom = false, name = "task_workload" },
  			},
  			section_c = {
  				{ type = "coloreds", custom = false, name = "task_states" },
  			},
  		},
  	},

  	status_line = {
  		left = {
  			section_a = {
  				{ type = "string", custom = false, name = "tab_mode" },
  			},
  			section_b = {
  				{ type = "string", custom = false, name = "hovered_size" },
  			},
  			section_c = {
  				{ type = "string", custom = false, name = "hovered_name" },
  				{ type = "coloreds", custom = false, name = "count" },
  			},
  		},
  		right = {
  			section_a = {
  				{ type = "string", custom = false, name = "cursor_position" },
  			},
  			section_b = {
  				{ type = "string", custom = false, name = "cursor_percentage" },
  			},
  			section_c = {
  				{ type = "string", custom = false, name = "hovered_file_extension", params = { true } },
  				{ type = "coloreds", custom = false, name = "permissions" },
  			},
  		},
  	},
  })

  require("yatline-githead"):setup({
  	show_branch = true,
  	branch_prefix = "",
  	branch_symbol = "",
  	branch_borders = "",

  	commit_symbol = " ",

  	show_stashes = true,
  	stashes_symbol = " ",

  	show_state = true,
  	show_state_prefix = true,
  	state_symbol = "󱅉",

  	show_staged = true,
  	staged_symbol = " ",

  	show_unstaged = true,
  	unstaged_symbol = " ",

  	show_untracked = true,
  	untracked_symbol = " ",

  	prefix_color = palette.pink,
  	branch_color = palette.pink,
  	commit_color = palette.mauve,
  	stashes_color = palette.teal,
  	state_color = palette.lavender,
  	staged_color = palette.green,
  	unstaged_color = palette.yellow,
  	untracked_color = palette.pink,
  })
''
