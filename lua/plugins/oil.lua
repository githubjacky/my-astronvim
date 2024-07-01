--- ref:
--- https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/file-explorer/oil-nvim/init.lua
--- https://github.com/Gelio/ubuntu-dotfiles/blob/eee2e9914df726d63870cf1174b80f08f938abc4/universal/neovim/config/nvim/lua/plugins/file-tree.lua#L13 

local dependencies = {}

table.insert(dependencies, {
  "nvim-neo-tree/neo-tree.nvim",
  enabled = false,
})

table.insert(dependencies, {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    opts.mappings.n["<Leader>e"] = { "<Cmd>Oil --float<CR>", desc = "Open folder in Oil" }
    opts.autocmds.oil_settings = {
      {
        event = "FileType",
        desc = "Disable view saving for oil buffers",
        pattern = "oil",
        callback = function(args) vim.b[args.buf].view_activated = false end,
      },
      {
        event = "User",
        pattern = "OilActionsPost",
        desc = "Close buffers when files are deleted in Oil",
        callback = function(args)
          if args.data.err then return end
          for _, action in ipairs(args.data.actions) do
            if action.type == "delete" then
              local _, path = require("oil.util").parse_url(action.url)
              local bufnr = vim.fn.bufnr(path)
              if bufnr ~= -1 then require("astrocore.buffer").wipe(bufnr, true) end
            end
          end
        end,
      },
    }
  end,
})

table.insert(dependencies, {
  "rebelot/heirline.nvim",
  optional = true,
  dependencies = { "AstroNvim/astroui", opts = { status = { winbar = { enabled = { filetype = { "^oil$" } } } } } },
  opts = function(_, opts)
    if opts.winbar then
      local status = require "astroui.status"
      table.insert(opts.winbar, 1, {
        condition = function(self) return status.condition.buffer_matches({ filetype = "^oil$" }, self.bufnr) end,
        status.component.separated_path {
          padding = { left = 2 },
          max_depth = false,
          suffix = false,
          path_func = function() return require("oil").get_current_dir() end,
        },
      })
    end
  end,
})

return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  dependencies = dependencies,
  opts = function()
    local get_icon = require("astroui").get_icon
    local detail = false

    return {
      default_file_explorer = true,
      columns = { { "icon", default_file = get_icon "DefaultFile", directory = get_icon "FolderClosed" } },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _) return vim.startswith(name, "..") end,
      },
      keymaps = {
        ["<C-l>"] = false, -- coflict with key mappings of window navigation
        ["<C-f>"] = "actions.refresh",
        ["<C-o>"] = "actions.preview",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-x>"] = "actions.select_split",
        ["gd"] = {
          desc = "Toggle file detail view",
          callback = function()
            detail = not detail
            if detail then
              require("oil").set_columns { "icon", "permissions", "size", "mtime" }
            else
              require("oil").set_columns { "icon" }
            end
          end,
        },
      },
      win_options = {
				winbar = "%{v:lua.require('oil').get_current_dir()}",
			},

    }
  end,
  lazy = false,
}
