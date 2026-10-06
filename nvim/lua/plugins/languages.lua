return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = { ensure_installed = {
      "lua-language-server", "r-languageserver", "svelte-language-server", "vtsls", "json-lsp", "taplo", "stylua",
      { "rust-analyzer", condition = function() return vim.fn.executable "rust-analyzer" == 0 end },
    } },
  },
  {
    "AstroNvim/astrolsp",
    opts = {
      servers = vim.fn.executable "rust-analyzer" == 1 and { "rust_analyzer" } or {},
      config = {
        lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } } } } },
        r_language_server = { root_markers = { "DESCRIPTION", "NAMESPACE", ".Rbuildignore", ".git" } },
        jsonls = {
          on_new_config = function(config) config.settings.json.schemas = require("schemastore").json.schemas() end,
          settings = { json = { validate = { enable = true } } },
        },
        vtsls = { settings = { vtsls = {
          autoUseWorkspaceTsdk = true,
          tsserver = { globalPlugins = { {
            name = "typescript-svelte-plugin",
            location = vim.fn.stdpath("data") .. "/mason/packages/svelte-language-server/node_modules/typescript-svelte-plugin",
            enableForWorkspaceTypeScriptVersions = true,
          } } },
        } } },
      },
    },
  },
  { "b0o/SchemaStore.nvim", lazy = true },
  {
    "R-nvim/R.nvim",
    lazy = false,
    opts = {
      R_args = { "--quiet", "--no-save" }, pdfviewer = "",
      hook = { on_filetype = function()
        vim.keymap.set("n", "<Enter>", "<Plug>RDSendLine", { buffer = true })
        vim.keymap.set("x", "<Enter>", "<Plug>RSendSelection", { buffer = true })
      end },
    },
    config = function(_, opts)
      vim.g.rout_follow_colorscheme = true
      require("r").setup(opts)
      require("r.pdf.generic").open = vim.ui.open
    end,
  },
}
