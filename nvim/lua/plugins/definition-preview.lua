-- Flaoting window preview of function bodies, variables, references, etc.
local function bind_popup_quit(win)
  if vim.w[win].preview_quit_attached then return end
  vim.w[win].preview_quit_attached = true
  local previous, installed, buf
  local function restore()
    if not installed then return end
    installed = false
    if not vim.api.nvim_buf_is_valid(buf) then return end
    vim.api.nvim_buf_call(buf, function()
      vim.keymap.del("n", "q", { buffer = buf })
      if previous.buffer == 1 then vim.fn.mapset("n", false, previous) end
    end)
  end
  local function install()
    if installed or vim.api.nvim_get_current_win() ~= win then return end
    buf = vim.api.nvim_win_get_buf(win)
    previous = vim.fn.maparg("q", "n", false, true)
    vim.keymap.set(
      "n",
      "q",
      function() require("goto-preview").close_all_win() end,
      { buffer = buf, nowait = true, desc = "Close definition preview" }
    )
    installed = true
  end
  local enter = vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, { callback = install })
  local leave = vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    callback = function()
      if vim.api.nvim_get_current_win() == win then restore() end
    end,
  })
  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(win),
    once = true,
    callback = function()
      restore()
      vim.api.nvim_del_autocmd(enter)
      vim.api.nvim_del_autocmd(leave)
    end,
  })
  install()
end

local function preview(method)
  require("goto-preview")[method] {
    width = math.max(1, math.min(110, math.floor(vim.o.columns * 0.85))),
    height = math.max(1, math.min(22, math.floor(vim.o.lines * 0.6))),
  }
end

return {
  {
    "rmagatti/goto-preview",
    dependencies = { "rmagatti/logger.nvim" },
    opts = {
      default_mappings = false,
      border = "rounded",
      focus_on_open = true,
      same_file_float_preview = true,
      stack_floating_preview_windows = false,
      -- Keep any edits when the popup closes.
      bufhidden = "hide",
      force_close = false,
      vim_ui_input = false,
      references = { provider = "snacks" },
      post_open_hook = function(buf, win)
        bind_popup_quit(win)
        -- The plugin reuses the window but does not refresh its filename title.
        vim.api.nvim_win_set_config(win, {
          title = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":."),
          title_pos = "left",
        })
        vim.wo[win].wrap = true
        vim.wo[win].linebreak = true
        vim.wo[win].breakindent = true
        vim.wo[win].number = true
        vim.wo[win].relativenumber = false
        vim.wo[win].signcolumn = "no"
        vim.wo[win].foldenable = false
        vim.wo[win].scrolloff = 0
        vim.api.nvim_win_call(win, function() vim.cmd "normal! zt" end)
      end,
    },
    keys = {
      {
        "<leader>K",
        function() preview "goto_preview_definition" end,
        desc = "Peek / follow definition",
      },
      { "gpt", function() preview "goto_preview_type_definition" end, desc = "Peek type definition" },
      { "gpi", function() preview "goto_preview_implementation" end, desc = "Peek implementation" },
    },
  },
}
