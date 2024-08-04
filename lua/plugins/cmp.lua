-- the code is borrowed from https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/completion/cmp-latex-symbols/init.lua
return {
  "hrsh7th/nvim-cmp",
  optional = true,
  dependencies = { "kdheepak/cmp-latex-symbols" },
  opts = function(_, opts)
    if not opts.sources then opts.sources = {} end
    table.insert(opts.sources, {
      name = "latex_symbols",
      priority = 700,
      option = {
        strategy = 1,
      },
    })
  end,
}
