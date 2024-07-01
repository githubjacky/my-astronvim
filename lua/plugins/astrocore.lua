---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = true, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
        colorcolumn = "90",
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- NOTE: customized key mappings
        ["<Tab>"] = { "$", desc = "move to the end of the current line" },
        ["<S-Tab>"] = { "^", desc = "move to the end of the current line" },
        [">"] = { "a<C-t><Esc>", desc = "make indent" },
        ["<"] = { "a<C-d><Esc>", desc = "make indent" },
        ["<S-h>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "next buffer" },
        ["<S-l>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "previous buffer" },
        ["<C-S-Up>"] = { "<Cmd>resize -2<CR>", desc = "Resize split up" },
        ["<C-S-Down>"] = { "<Cmd>resize +2<CR>", desc = "Resize split down" },
        ["<C-S-Left>"] = { "<Cmd>vertical resize -2<CR>", desc = "Resize split left" },
        ["<C-S-Right>"] = { "<Cmd>vertical resize +2<CR>", desc = "Resize split right" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
      x = {
        ["<Tab>"] = { "$", desc = "move to the end of the current line" },
        ["<S-Tab>"] = { "^", desc = "move to the end of the current line" },
        [">"] = { ">gv", desc = "make indent" },
        ["<"] = { "<gv", desc = "make indent" },
      },
    },
    autocmds = {
      auto_colorcolumn = {
        {
          event = "User",
          pattern = "AstroBufsUpdated",
          desc = "Highlight the colorcolumn",
          group = "autocolorcolumn",
          callback = function()
            vim.cmd [[
            highlight ColorColumn guibg=#414868
          ]]
          end,
        },
      },
    },
  },
}
