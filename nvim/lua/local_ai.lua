-- Start one local model on request --
local M = { ready = false, port = tonumber(vim.env.NVIM_AI_PORT) or 8012 }
local job, starting, generation = nil, false, 0
local log = vim.fn.stdpath "state" .. "/local-ai.log"
local model_dir = (vim.env.XDG_DATA_HOME or (vim.uv.os_homedir() .. "/.local/share")) .. "/nvim-local-ai/models/"
local profiles = {
  mellum = {
    name = "Mellum 2 Base",
    file = "Mellum2-12B-A2.5B-Base.Q5_K_M.gguf",
    alias = "mellum2-base-local",
    prefix = "<fim_prefix>",
    suffix = "<fim_suffix>",
    middle = "<fim_middle>",
    stop = {
      "<|endoftext|>",
      "<fim_prefix>",
      "<fim_suffix>",
      "<fim_middle>",
      "<fim_pad>",
      "<filename>",
      "<reponame>",
      "\n\n",
    },
  },
  qwen = {
    name = "Qwen2.5-Coder 3B",
    file = "Qwen2.5-Coder-3B-Q4_K_M.gguf",
    alias = "qwen2.5-coder-3b-local",
    prefix = "<|fim_prefix|>",
    suffix = "<|fim_suffix|>",
    middle = "<|fim_middle|>",
    stop = { "<|endoftext|>", "<|fim_prefix|>", "<|fim_suffix|>", "<|fim_middle|>", "<|file_sep|>", "\n\n" },
  },
}
local model
local function notify(message, level) vim.notify(message, level or vim.log.levels.INFO, { title = "Local completion" }) end
local function select_profile(key, custom_model)
  if not profiles[key] then
    notify("Unknown model preset: " .. key .. ". Choose mellum or qwen.", vim.log.levels.ERROR)
    return false
  end
  M.preset, M.profile = key, profiles[key]
  model = custom_model or (model_dir .. M.profile.file)
  M.model, M.alias = model, M.profile.alias
  if custom_model then M.alias = M.alias .. "-" .. vim.fn.sha256(model):sub(1, 8) end
  -- Minuet can already be loaded when a different preset is selected
  if package.loaded.minuet then
    local options = require("minuet").config.provider_options.openai_fim_compatible
    options.model, options.optional.stop = M.alias, vim.deepcopy(M.profile.stop)
  end
  return true
end
function M.prompt(before, after) return M.profile.prefix .. before .. M.profile.suffix .. after .. M.profile.middle end
local initial = vim.env.NVIM_AI_PRESET
  or (vim.env.NVIM_AI_MODEL and vim.env.NVIM_AI_MODEL:lower():find("qwen", 1, true) and "qwen")
  or "mellum"
if not select_profile(initial, vim.env.NVIM_AI_MODEL) then select_profile "mellum" end
local function probe(callback)
  vim.system(
    { "curl", "--silent", "--fail", "--max-time", "2", "http://127.0.0.1:" .. M.port .. "/v1/models" },
    { text = true },
    function(result)
      vim.schedule(function()
        local ok, data = pcall(vim.json.decode, result.stdout or "")
        local matches = ok and type(data) == "table" and data.data and data.data[1] and data.data[1].id == M.alias
        callback(result.code == 0 and matches, result.code == 0)
      end)
    end
  )
end
function M.start(preset)
  if M.ready or starting then
    return notify(
      "Local completion: "
        .. M.profile.name
        .. (starting and " is loading" or " is on")
        .. ". Use :LocalAIStop before changing models."
    )
  end
  if preset and preset ~= "" and not select_profile(preset) then return end
  if vim.fn.executable "llama-server" ~= 1 then return notify("Install llama.cpp first", vim.log.levels.ERROR) end
  if vim.fn.filereadable(model) ~= 1 then return notify("Model not found: " .. model, vim.log.levels.ERROR) end
  starting, generation = true, generation + 1
  local current = generation
  probe(function(matches, occupied)
    if current ~= generation then return end
    if matches then
      M.ready, starting = true, false
      return notify "Local completion is on (using the already running server)"
    elseif occupied then
      starting = false
      return notify("Port " .. M.port .. " is in use by a different model; set NVIM_AI_PORT", vim.log.levels.ERROR)
    end
    vim.fn.mkdir(vim.fn.fnamemodify(log, ":h"), "p")
    vim.fn.writefile({ "Starting local model: " .. model }, log)
    local function append(_, lines)
      local clean = vim.tbl_filter(function(line) return line ~= "" end, lines)
      if #clean > 0 then vim.fn.writefile(clean, log, "a") end
    end
    job = vim.fn.jobstart({
      "llama-server",
      "--model",
      model,
      "--alias",
      M.alias,
      "--host",
      "127.0.0.1",
      "--port",
      tostring(M.port),
      "--ctx-size",
      "4096",
      "--parallel",
      "1",
      "--n-predict",
      "64",
      "--threads",
      "4",
      "--threads-batch",
      "4",
      "--poll",
      "0",
      "--poll-batch",
      "0",
      "--gpu-layers",
      vim.env.NVIM_AI_GPU_LAYERS or "99",
      "--batch-size",
      "256",
      "--ubatch-size",
      "128",
      "--cache-ram",
      "0",
      "--no-webui",
    }, {
      on_stdout = append,
      on_stderr = append,
      on_exit = function(_, code)
        if current ~= generation then return end
        job, starting, M.ready = nil, false, false
        if code ~= 0 then notify("Model stopped; inspect :LocalAILog", vim.log.levels.ERROR) end
      end,
    })
    if job <= 0 then
      job, starting = nil, false
      return notify("Could not start llama-server", vim.log.levels.ERROR)
    end
    notify("Loading " .. M.profile.name .. "…")
    local attempts = 0
    local function wait_ready()
      if current ~= generation or not job then return end
      probe(function(ok)
        if current ~= generation or not job then return end
        if ok then
          M.ready, starting = true, false
          notify(M.profile.name .. " is ready — Tab accepts an AI suggestion")
        else
          attempts = attempts + 1
          if attempts < 180 then
            vim.defer_fn(wait_ready, 500)
          else
            M.stop()
            notify("Model startup timed out; inspect :LocalAILog", vim.log.levels.ERROR)
          end
        end
      end)
    end
    vim.defer_fn(wait_ready, 500)
  end)
end
function M.stop(quiet)
  generation = generation + 1
  M.ready, starting = false, false
  if package.loaded["minuet.backends.common"] then require("minuet.backends.common").terminate_all_jobs() end
  if package.loaded["minuet.virtualtext"] then require("minuet.virtualtext").action.dismiss() end
  local owned = job ~= nil
  if job then
    vim.fn.jobstop(job)
    job = nil
  end
  if not quiet then notify(owned and "Local completion is off") end
end
function M.toggle()
  if M.ready or starting then
    M.stop()
  else
    M.start()
  end
end
function M.setup()
  vim.api.nvim_create_user_command("LocalAIStart", function(opts) M.start(opts.args) end, {
    nargs = "?",
    complete = function() return { "mellum", "qwen" } end,
    desc = "Start local completion (preset: mellum or qwen)",
  })
  vim.api.nvim_create_user_command("LocalAIStop", function() M.stop() end, { desc = "Stop local code completion" })
  vim.api.nvim_create_user_command(
    "LocalAIStatus",
    function() notify(M.profile.name .. ": " .. (M.ready and "on" or starting and "loading" or "off")) end,
    {}
  )
  vim.api.nvim_create_user_command("LocalAILog", function() vim.cmd.split(vim.fn.fnameescape(log)) end, {})
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function() M.stop(true) end,
  })
end
return M
