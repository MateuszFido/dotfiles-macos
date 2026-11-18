return {
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"
      opts.statusline = {
        hl = { fg = "fg", bg = "bg" },
        status.component.git_diff {
          surround = false,
          added = { hl = { fg = "#9ece6a" } },
          changed = { hl = { fg = "#e0af68" } },
          removed = { hl = { fg = "#f7768e" } },
        },
      }
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      opts.numhl, opts.signcolumn = false, true
      -- Bars mark existing changes; a horizontal mark shows where lines were removed.
      local signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "━", show_count = true },
        topdelete = { text = "━", show_count = true },
        changedelete = { text = "╋", show_count = true },
        untracked = { text = "┆" },
      }
      opts.signs = vim.deepcopy(signs)
      opts.signs_staged = vim.deepcopy(signs)
      local attach = opts.on_attach
      opts.on_attach = function(buf)
        if attach then attach(buf) end
        local gs = require "gitsigns"
        vim.keymap.set("n", "<Leader>gr", "<Cmd>CodeDiff<CR>", { buffer = buf, desc = "Review changes (CodeDiff)" })
        vim.keymap.set("n", "<Leader>gR", "<Cmd>CodeDiff --staged<CR>", { buffer = buf, desc = "Review staged changes (CodeDiff)" })
        pcall(vim.keymap.del, "v", "<Leader>gr", { buffer = buf })
        vim.keymap.set("n", "<Leader>ghr", gs.reset_hunk, { buffer = buf, desc = "Reset Git hunk" })
        vim.keymap.set("x", "<Leader>ghr", function() gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" } end,
          { buffer = buf, desc = "Reset selected Git hunk" })
        vim.keymap.set("n", "<Leader>ghR", gs.reset_buffer, { buffer = buf, desc = "Reset Git buffer" })
      end
    end,
  },
  {
    "AstroNvim/astroui",
    opts = { highlights = { init = {
      GitSignsAdd = { fg = "#9ece6a" }, GitSignsChange = { fg = "#e0af68" },
      GitSignsDelete = { fg = "#f7768e" }, GitSignsChangedelete = { fg = "#e0af68" },
      GitSignsTopdelete = { fg = "#f7768e" }, GitSignsUntracked = { fg = "#9ece6a" },
    } } },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      source_selector = { sources = {
        { source = "filesystem", display_name = "File" },
        { source = "buffers", display_name = "Bufs" },
        { source = "git_status", display_name = "Git" },
      } },
      -- Show dotfiles and gitignored files; Neo-tree dims the gitignored ones.
      filesystem = { filtered_items = { hide_dotfiles = false, hide_gitignored = false, never_show = { ".git" } } },
    },
  },
}
