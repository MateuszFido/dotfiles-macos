return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  opts = {},
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension "fzf"
  end,
  specs = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        -- Override these Astro search keys in one place; keep other pickers available.
        local pickers = {
          ff = { "find_files", "Find files" },
          fw = { "live_grep", "Find text in project" },
          fc = { "grep_string", "Find word under cursor" },
          fb = { "buffers", "Find open buffers" },
          fo = { "oldfiles", "Find recent files" },
          fl = { "current_buffer_fuzzy_find", "Find lines in current file" },
          ["f<CR>"] = { "resume", "Resume previous search" },
          fh = { "help_tags", "Find help" },
          fk = { "keymaps", "Find keymaps" },
          fg = { "git_files", "Find Git files" },
        }
        for key, picker in pairs(pickers) do
          local builtin = picker[1]
          opts.mappings.n["<Leader>" .. key] = {
            function() require("telescope.builtin")[builtin]() end,
            desc = picker[2] .. " (Telescope)",
          }
        end
      end,
    },
  },
}
