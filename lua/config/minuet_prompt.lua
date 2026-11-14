local M = {}

local function get_template(format)
  local templates = {
    standard_fim = function(fim, before, after)
      return fim.pre .. before .. fim.suf .. after .. fim.mid
    end,

    deepseek_fim = function(fim, before, after)
      return fim.pre .. before .. fim.mid .. after .. fim.suf
    end,
  }

  return templates[format]
end

function M.build(before, after)
  local server = require("config.llama_server")
  local config, err = server.get_fim_config()

  if not config then
    return nil, err
  end

  vim.notify("Minuet FIM: " .. tostring(config.format), vim.log.levels.INFO)

  local template = get_template(config.format)

  if not template then
    return nil, "Unsupported FIM format: " .. tostring(config.format)
  end

  return template(config.tokens, before, after)
end

return M
