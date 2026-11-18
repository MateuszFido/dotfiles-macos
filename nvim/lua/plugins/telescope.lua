-- Normal searches include dotfiles but respect .gitignore; the "all" variants add gitignored files.
local all_files = { no_ignore = true }
local all_text = { additional_args = { "--no-ignore" } }

-- Search the directory under the cursor in Neo-tree.
local function search_tree_dir(builtin, args)
  return function(state)
    local node = state.tree:get_node()
    local dir = node.type == "file" and node:get_parent_id() or node:get_id()
    require("telescope.builtin")[builtin](vim.tbl_extend("force", args or {}, { cwd = dir }))
  end
end

return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
  },
  init = function()
    -- Load Telescope on the first menu (code actions etc.); its ui-select extension then takes over.
    local select = vim.ui.select
    vim.ui.select = function(...)
      vim.ui.select = select
      require("lazy").load { plugins = { "telescope.nvim" } }
      return vim.ui.select(...)
    end
  end,
  opts = function()
    return {
      defaults = {
        -- Telescope's default plus dotfiles; .git itself stays out.
        vimgrep_arguments = {
          "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case",
          "--hidden", "--glob=!.git/",
        },
      },
      pickers = {
        find_files = { find_command = { "rg", "--files", "--color=never", "--hidden", "--glob=!.git/" } },
      },
      extensions = { ["ui-select"] = require("telescope.themes").get_dropdown() },
    }
  end,
  config = function(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension "fzf"
    require("telescope").load_extension "ui-select"
  end,
  specs = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings.n
        maps["<Leader>f"] = opts._map_sections.f
        -- Each entry is { builtin, description, options }.
        local pickers = {
          ff = { "find_files", "Find files" },
          fF = { "find_files", "Find all files", all_files },
          fw = { "live_grep", "Find text in project" },
          fW = { "live_grep", "Find text in all files", all_text },
          fc = { "grep_string", "Find word under cursor" },
          fb = { "buffers", "Find open buffers" },
          fo = { "oldfiles", "Find recent files" },
          fO = { "oldfiles", "Find recent files in project", { cwd_only = true } },
          fl = { "current_buffer_fuzzy_find", "Find lines in current file" },
          ["f<CR>"] = { "resume", "Resume previous search" },
          ["f'"] = { "marks", "Find marks" },
          fa = { "find_files", "Find Neovim config files", { cwd = vim.fn.stdpath "config" } },
          fC = { "commands", "Find commands" },
          fh = { "help_tags", "Find help" },
          fk = { "keymaps", "Find keymaps" },
          fm = { "man_pages", "Find man pages" },
          fr = { "registers", "Find registers" },
          ft = { "colorscheme", "Find themes", { enable_preview = true } },
          fg = { "git_files", "Find Git files" },
          gb = { "git_branches", "Git branches" },
          gc = { "git_commits", "Git commits (repository)" },
          gC = { "git_bcommits", "Git commits (current file)" },
          gt = { "git_status", "Git status" },
          gT = { "git_stash", "Git stash" },
          lD = { "diagnostics", "Search diagnostics" },
        }
        for key, picker in pairs(pickers) do
          local builtin, desc, args = unpack(picker)
          maps["<Leader>" .. key] = {
            -- Telescope writes bufnr/winnr into the options it gets, so each call needs a fresh copy.
            function() require("telescope.builtin")[builtin](vim.deepcopy(args or {})) end,
            desc = desc .. " (Telescope)",
          }
        end
        maps["<Leader>ls"] = {
          function() require("telescope").extensions.aerial.aerial() end,
          desc = "Search symbols (Telescope)",
        }
        -- Telescope has no builtin for these two.
        maps["<Leader>fu"] = {
          function()
            vim.cmd.packadd "nvim.undotree"
            require("undotree").open()
          end,
          desc = "Show undo history",
        }
        maps["<Leader>fn"] = { function() require("snacks").notifier.show_history() end, desc = "Show notifications" }
      end,
    },
    -- Telescope replaces the Snacks picker, so AstroNvim skips its Snacks picker keys.
    { "folke/snacks.nvim", opts = { picker = { enabled = false } } },
    {
      "nvim-neo-tree/neo-tree.nvim",
      optional = true,
      -- ff/fF/fw/fW inside the tree.
      opts = { commands = {
        find_files_in_dir = search_tree_dir "find_files",
        find_all_files_in_dir = search_tree_dir("find_files", all_files),
        find_words_in_dir = search_tree_dir "live_grep",
        find_all_words_in_dir = search_tree_dir("live_grep", all_text),
      } },
    },
  },
}
