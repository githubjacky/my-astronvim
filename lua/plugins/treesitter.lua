---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "csv",
      "json",
      "r",
      "yaml",
      "toml",
      "dockerfile",
    },
  },
}
