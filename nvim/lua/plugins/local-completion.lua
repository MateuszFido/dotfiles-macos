return {
  "milanglacier/minuet-ai.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "InsertEnter",
  opts = function()
    local ai = require "local_ai"
    return {
      provider = "openai_fim_compatible",
      n_completions = 1,
      context_window = 6000, -- characters not tokens
      after_cursor_filter_length = 3,
      debounce = 400,
      throttle = 1000,
      request_timeout = 8,
      notify = "error",
      enable_predicates = {
        function() return require("local_ai").ready and vim.bo.buftype == "" end,
      },
      virtualtext = {
        auto_trigger_ft = {
          "lua",
          "r",
          "rust",
          "svelte",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "python",
          "sh",
          "c",
          "cpp",
          "json",
          "toml",
          "tex",
          "markdown",
        },
        show_on_completion_menu = true,
        keymap = { accept = "<A-a>", accept_line = "<A-l>", dismiss = "<A-e>" },
      },
      provider_options = {
        openai_fim_compatible = {
          name = "Local llama.cpp",
          api_key = function() return "local-only" end,
          end_point = "http://127.0.0.1:" .. require("local_ai").port .. "/v1/completions",
          model = ai.alias,
          stream = true,
          optional = {
            max_tokens = 64,
            temperature = 0.2,
            top_p = 0.9,
            stop = vim.deepcopy(ai.profile.stop),
          },
          template = {
            prompt = function(before, after) return ai.prompt(before, after) end,
            suffix = false,
          },
        },
      },
    }
  end,
  config = function(_, opts)
    require("minuet").setup(opts)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if
        vim.api.nvim_buf_is_loaded(buf) and vim.tbl_contains(opts.virtualtext.auto_trigger_ft, vim.bo[buf].filetype)
      then
        vim.b[buf].minuet_virtual_text_auto_trigger = true
      end
    end
  end,
  specs = {
    {
      "saghen/blink.cmp",
      opts = function(_, opts)
        -- Tab priority to blink
        table.insert(opts.keymap["<Tab>"], 1, function(cmp)
          local virtualtext = package.loaded["minuet.virtualtext"]
          if vim.fn.mode() == "i" and require("local_ai").ready and virtualtext and virtualtext.action.is_visible() then
            cmp.hide()
            virtualtext.action.accept()
            return true
          end
        end)
      end,
    },
  },
  keys = {
    {
      "<C-g>a",
      function() require("minuet.virtualtext").action.accept() end,
      mode = "i",
      desc = "Accept local AI suggestion",
    },
    {
      "<A-y>",
      function()
        if require("local_ai").ready then
          require("minuet.virtualtext").action.next()
        else
          vim.notify("Start local completion with :LocalAIStart", vim.log.levels.INFO)
        end
      end,
      mode = "i",
      desc = "Request local AI suggestion",
    },
  },
}
