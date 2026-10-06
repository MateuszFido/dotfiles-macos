return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    opts.features.diagnostics = { virtual_text = false, virtual_lines = false }
    opts.diagnostics.virtual_text = false
    opts.diagnostics.virtual_lines = false
    opts.diagnostics.float = { border = "rounded", source = "if_many", wrap = true }
    opts.options.opt = vim.tbl_extend("force", opts.options.opt, {
      number = true, relativenumber = false, signcolumn = "yes:2",
      tabstop = 4, shiftwidth = 4, softtabstop = -1, expandtab = true,
      wrap = true, linebreak = true, breakindent = true, breakindentopt = "shift:2,min:20",
    })
    local maps = opts.mappings.n
    -- Keep these prefixes for personal tools; use :Lazy and :Mason for plugins.
    for key in pairs(maps) do
      if key:match("^<Leader>p") then maps[key] = false end
    end
    maps["<Leader>o"] = false
    maps["<Leader>q"] = false
    maps["<C-Q>"] = { function() require("snacks").bufdelete() end, desc = "Close buffer (ask before losing edits)" }
    maps.gl = {
      function()
        vim.diagnostic.open_float {
          scope = "line", border = "rounded", source = "if_many", wrap = true,
          max_width = math.max(20, math.min(100, math.floor(vim.o.columns * 0.8))),
        }
      end,
      desc = "Show line diagnostics",
    }
    maps["<Leader>ua"] = { function() require("local_ai").toggle() end, desc = "Toggle local AI completion" }
    opts._map_sections.p = { desc = "Pi" }
    for _, parser in ipairs { "r", "rnoweb", "rust", "svelte", "javascript", "typescript", "tsx", "html", "css", "json", "toml", "latex", "bibtex" } do
      if not vim.tbl_contains(opts.treesitter.ensure_installed, parser) then
        table.insert(opts.treesitter.ensure_installed, parser)
      end
    end
  end,
}
