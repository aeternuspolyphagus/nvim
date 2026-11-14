local M = {}

local config = {
  model = "C:\\Models\\Qwen2.5-Coder-0.5B-Q4_K_M.gguf",
  model_dir = "C:\\Models",
  host = "127.0.0.1",
  port = 8080,
  threads = 8,
  context_size = 4096,
  predict = 128,

  auto_start = true,

  filetypes = {
    "lua",
    "ps1",
    "psm1",
    "psd1",
    "powershell",
    "python",
    "sh",
    "bash",
    "zsh",
    "rust",
    "go",
    "javascript",
    "typescript",
  },

  startup_timeout = 30000,
  check_interval = 500,
  stop_on_exit = true,
}

local process = nil
local running_model = nil
local starting = false
local waiting = false
local stopping = false
local server_state = "unknown"
local fim_cache = {}

local function set_state(state)
  if server_state == state then
    return
  end

  server_state = state

  vim.schedule(function()
    vim.cmd("redrawstatus")
  end)
end

function M.statusline()
  local icons = {
    running = "󰒍 LLM",
    starting = "󰑮 LLM",
    stopped = "󰒏 LLM",
    unknown = "󰋗 LLM",
  }

  return icons[server_state] or "󰋗 LLM"
end

function M.statusline_color()
  local colors = {
    running = "#a6e3a1",
    starting = "#f9e2af",
    stopped = "#f38ba8",
    unknown = "#6c7086",
  }

  return colors[server_state] or "#6c7086"
end

local function endpoint()
  return "http://" .. config.host .. ":" .. config.port
end

local function model_name(path)
  if not path or path == "" then
    return "unknown"
  end

  return path:gsub("\\", "/"):match("([^/]+)$") or path
end

local function same_model(a, b)
  if not a or not b then
    return false
  end

  return a:gsub("/", "\\"):lower() == b:gsub("/", "\\"):lower()
end

local function get_models()
  local models = vim.fn.globpath(config.model_dir, "*.gguf", false, true)

  table.sort(models, function(a, b)
    return a:lower() < b:lower()
  end)

  return models
end

local function get_running_model_path()
  if process then
    return running_model
  end

  local response = vim.fn.system({
    "curl.exe",
    "-s",
    "--connect-timeout",
    "1",
    "--max-time",
    "2",
    endpoint() .. "/v1/models",
  })

  if vim.v.shell_error ~= 0 then
    return nil
  end

  local ok, data = pcall(vim.json.decode, response)

  if not ok or not data.data or not data.data[1] then
    return nil
  end

  local id = data.data[1].id

  if not id then
    return nil
  end

  if vim.fn.filereadable(id) == 1 then
    return id
  end

  for _, path in ipairs(get_models()) do
    if model_name(path):lower() == model_name(id):lower() then
      return path
    end
  end

  return nil
end

local function get_running_model()
  local path = get_running_model_path()
  return path and model_name(path) or "unknown"
end

local function get_fim_for_path(path)
  if not path then
    return nil, "Model path is unknown"
  end

  if not fim_cache[path] then
    local ok, result, err = pcall(function()
      return require("config.gguf").read_fim(path)
    end)

    if not ok then
      return nil, tostring(result)
    end

    if not result then
      return nil, err or "Failed to read GGUF metadata"
    end

    fim_cache[path] = result
  end

  local result = fim_cache[path]

  if not result.supported then
    return nil, "FIM format is not supported for " .. model_name(path)
  end

  return result
end

function M.get_fim_config()
  if not M.is_running() then
    return nil, "llama-server is not running"
  end

  local path = get_running_model_path()

  if not path then
    return nil, "Unable to determine running model path"
  end

  return get_fim_for_path(path)
end

function M.get_fim_tokens()
  local fim, err = M.get_fim_config()

  if not fim then
    return nil, err
  end

  return fim.tokens
end

local function notify(message, level)
  vim.schedule(function()
    vim.notify(message, level or vim.log.levels.INFO)
  end)
end

function M.select_model()
  local models = get_models()

  if #models == 0 then
    notify("No GGUF models found in " .. config.model_dir, vim.log.levels.WARN)
    return
  end

  local active_model

  if M.is_running() then
    active_model = get_running_model()
  end

  local selected_model = model_name(config.model)

  vim.ui.select(models, {
    prompt = "Select llama.cpp model:",
    format_item = function(path)
      local name = model_name(path)
      local normalized = name:lower()

      if active_model and normalized == active_model:lower() then
        return "● " .. name .. " [RUNNING]"
      end

      if normalized == selected_model:lower() then
        return "✓ " .. name .. " [SELECTED]"
      end

      return "  " .. name
    end,
  }, function(choice)
    if not choice then
      return
    end

    if same_model(config.model, choice) then
      return
    end

    local was_running = M.is_running()

    config.model = choice

    notify("Selected model: " .. model_name(choice))

    if was_running then
      M.start()
    end
  end)
end

function M.is_running()
  local result = vim.fn.system({
    "curl.exe",
    "-s",
    "--connect-timeout",
    "1",
    "--max-time",
    "2",
    "-o",
    "NUL",
    "-w",
    "%{http_code}",
    endpoint() .. "/health",
  })

  local running = vim.v.shell_error == 0 and result:match("^200") ~= nil

  if running then
    starting = false
    set_state("running")
  elseif process or starting then
    set_state("starting")
  else
    set_state("stopped")
  end

  return running
end

local function launch_server()
  if process or starting then
    return
  end

  local executable = vim.fn.exepath("llama-server")

  if executable == "" then
    notify("llama-server.exe not found in PATH", vim.log.levels.ERROR)
    return
  end

  local selected_model = config.model

  starting = true
  running_model = selected_model

  process = vim.system({
    executable,
    "--model",
    selected_model,
    "--host",
    config.host,
    "--port",
    tostring(config.port),
    "--threads",
    tostring(config.threads),
    "--ctx-size",
    tostring(config.context_size),
    "--n-predict",
    tostring(config.predict),
  }, {
    detach = true,
    text = true,
  }, function(result)
    vim.schedule(function()
      process = nil
      running_model = nil
      starting = false
      set_state("stopped")

      if stopping then
        stopping = false
        return
      end

      if result.code ~= 0 then
        notify("llama-server exited with code " .. result.code, vim.log.levels.ERROR)
      end
    end)
  end)

  notify("Starting llama-server with model: " .. model_name(selected_model))
  set_state("starting")
  local elapsed = 0

  local function check_ready()
    if not process then
      return
    end

    if M.is_running() then
      local active_model = get_running_model_path()

      if same_model(active_model, selected_model) then
        set_state("running")
        notify("llama-server is ready: " .. model_name(active_model))
        return
      end
    end

    if elapsed >= config.startup_timeout then
      notify("llama-server startup timed out", vim.log.levels.ERROR)
      return
    end

    elapsed = elapsed + config.check_interval
    vim.defer_fn(check_ready, config.check_interval)
  end

  vim.defer_fn(check_ready, config.check_interval)
end

function M.start()
  if starting then
    return
  end

  if M.is_running() then
    notify("Switch check: active=" .. tostring(get_running_model_path()) .. ", selected=" .. tostring(config.model))
    local active_model = get_running_model_path()

    if same_model(active_model, config.model) then
      notify("llama-server is already running with selected model")
      return
    end

    if not process then
      notify(
        "External llama-server is running with another model. Stop it manually before switching.",
        vim.log.levels.WARN
      )
      return
    end

    notify("Switching model: " .. model_name(config.model))

    M.stop()

    local elapsed = 0

    local function wait_for_stop()
      if process then
        if elapsed >= config.startup_timeout then
          notify("Timed out waiting for llama-server process to stop", vim.log.levels.ERROR)
          return
        end

        elapsed = elapsed + config.check_interval
        vim.defer_fn(wait_for_stop, config.check_interval)
        return
      end

      if M.is_running() then
        if elapsed >= config.startup_timeout then
          notify("llama-server did not stop. Cannot switch model.", vim.log.levels.ERROR)
          return
        end

        elapsed = elapsed + config.check_interval
        vim.defer_fn(wait_for_stop, config.check_interval)
        return
      end

      launch_server()
    end

    vim.defer_fn(wait_for_stop, config.check_interval)
    return
  end

  if process then
    notify("llama-server process is still shutting down", vim.log.levels.WARN)
    return
  end

  launch_server()
end

function M.ensure_running()
  if waiting then
    return
  end

  if M.is_running() then
    local active_model = get_running_model_path()

    if same_model(active_model, config.model) then
      waiting = false
      set_state("running")
      return
    end
  end

  waiting = true

  M.start()

  local elapsed = 0

  local function check()
    if M.is_running() then
      local active_model = get_running_model_path()

      if same_model(active_model, config.model) then
        waiting = false
        return
      end

      if not process then
        waiting = false
        notify(
          "Running model differs from selected model. External server cannot be restarted automatically.",
          vim.log.levels.WARN
        )
        return
      end
    end

    if elapsed >= config.startup_timeout then
      waiting = false
      notify("llama-server startup timed out", vim.log.levels.ERROR)
      return
    end

    elapsed = elapsed + config.check_interval
    vim.defer_fn(check, config.check_interval)
  end

  vim.defer_fn(check, config.check_interval)
end

function M.stop()
  if not process then
    if M.is_running() then
      notify("llama-server is running externally")
    else
      notify("llama-server is already stopped")
    end

    return
  end

  stopping = true

  local ok, err = pcall(function()
    process:kill(15)
  end)

  if not ok then
    stopping = false
    notify("Failed to stop llama-server: " .. tostring(err), vim.log.levels.ERROR)
    return
  end

  notify("Stopping llama-server...")
end

function M.status()
  local running = M.is_running()

  local server_status

  if running then
    server_status = "RUNNING"
  elseif process or starting then
    server_status = "STARTING"
  else
    server_status = "STOPPED"
  end

  local message = "llama-server: " .. server_status

  if running then
    message = message .. "\nModel: " .. get_running_model()
  elseif process or starting then
    message = message .. "\nModel: " .. model_name(config.model)
  end

  message = message .. "\nAuto-start: " .. (config.auto_start and "ON" or "OFF")

  notify(message)
end

function M.toggle_auto()
  config.auto_start = not config.auto_start

  notify("llama-server auto-start: " .. (config.auto_start and "ON" or "OFF"))
end

function M.setup()
  local group = vim.api.nvim_create_augroup("LlamaServer", { clear = true })
  vim.api.nvim_create_user_command("LlamaStop", function()
    M.stop()
  end, {})

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      if config.stop_on_exit and process then
        pcall(function()
          process:kill(15)
        end)
      end
    end,
  })
  local filetype_lookup = {}

  for _, filetype in ipairs(config.filetypes) do
    filetype_lookup[filetype] = true
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
      if not config.auto_start then
        return
      end

      if not filetype_lookup[vim.bo[args.buf].filetype] then
        return
      end

      if vim.bo[args.buf].buftype ~= "" then
        return
      end

      M.ensure_running()
    end,
  })

  vim.api.nvim_create_user_command("LlamaStart", function()
    M.ensure_running()
  end, {})

  vim.api.nvim_create_user_command("LlamaStatus", function()
    M.status()
  end, {})

  vim.api.nvim_create_user_command("LlamaToggle", function()
    M.toggle_auto()
  end, {})
  vim.api.nvim_create_user_command("LlamaModel", function()
    M.select_model()
  end, {})
  vim.schedule(function()
    M.is_running()
  end)
end

return M
