local M = {}

local UINT32_SIZE = 4294967296

local function read_exact(file, size)
  local data = file:read(size)

  if not data or #data ~= size then
    error("Unexpected end of GGUF file")
  end

  return data
end

local function read_u32(file)
  local b1, b2, b3, b4 = read_exact(file, 4):byte(1, 4)

  return b1 + b2 * 256 + b3 * 65536 + b4 * 16777216
end

local function read_u64(file)
  local low = read_u32(file)
  local high = read_u32(file)

  return low + high * UINT32_SIZE
end

local function read_string(file)
  local size = read_u64(file)

  if size > 64 * 1024 * 1024 then
    error("GGUF string is unexpectedly large")
  end

  return read_exact(file, size)
end

local function skip_string(file)
  local size = read_u64(file)

  if size > 0 then
    assert(file:seek("cur", size))
  end
end

local function read_scalar(file, type_id)
  if type_id == 0 then
    return read_exact(file, 1):byte()
  elseif type_id == 1 then
    local value = read_exact(file, 1):byte()
    return value >= 128 and value - 256 or value
  elseif type_id == 2 then
    local a, b = read_exact(file, 2):byte(1, 2)
    return a + b * 256
  elseif type_id == 3 then
    local a, b = read_exact(file, 2):byte(1, 2)
    local value = a + b * 256
    return value >= 32768 and value - 65536 or value
  elseif type_id == 4 then
    return read_u32(file)
  elseif type_id == 5 then
    local value = read_u32(file)
    return value >= 2147483648 and value - UINT32_SIZE or value
  elseif type_id == 10 then
    return read_u64(file)
  elseif type_id == 11 then
    local value = read_u64(file)
    return value >= 9007199254740992 and value - 18014398509481984 or value
  end

  error("Unsupported scalar type: " .. type_id)
end

local function skip_value(file, type_id)
  local sizes = {
    [0] = 1,
    [1] = 1,
    [2] = 2,
    [3] = 2,
    [4] = 4,
    [5] = 4,
    [6] = 4,
    [7] = 1,
    [10] = 8,
    [11] = 8,
    [12] = 8,
  }

  if sizes[type_id] then
    assert(file:seek("cur", sizes[type_id]))
  elseif type_id == 8 then
    skip_string(file)
  elseif type_id == 9 then
    local element_type = read_u32(file)
    local count = read_u64(file)

    for _ = 1, count do
      skip_value(file, element_type)
    end
  else
    error("Unknown GGUF metadata type: " .. type_id)
  end
end

local function read_header(file)
  if read_exact(file, 4) ~= "GGUF" then
    error("Not a GGUF file")
  end

  local version = read_u32(file)

  if version ~= 2 and version ~= 3 then
    error("Unsupported GGUF version: " .. version)
  end

  local tensor_count = read_u64(file)
  local metadata_count = read_u64(file)

  return tensor_count, metadata_count
end

local fim_keys = {
  ["tokenizer.ggml.fim_pre_token_id"] = "pre",
  ["tokenizer.ggml.fim_suf_token_id"] = "suf",
  ["tokenizer.ggml.fim_mid_token_id"] = "mid",
  ["tokenizer.ggml.fim_pad_token_id"] = "pad",
  ["tokenizer.ggml.fim_rep_token_id"] = "rep",
  ["tokenizer.ggml.fim_sep_token_id"] = "sep",
}

local function read_fim_ids(path)
  local file = assert(io.open(path, "rb"))
  local _, metadata_count = read_header(file)

  local ids = {}

  for _ = 1, metadata_count do
    local key = read_string(file)
    local type_id = read_u32(file)
    local field = fim_keys[key]

    if field and type_id ~= 9 and type_id ~= 8 then
      ids[field] = read_scalar(file, type_id)
    else
      skip_value(file, type_id)
    end
  end

  file:close()

  return ids
end

local function read_fim_tokens(path, ids)
  local wanted = {}

  for name, id in pairs(ids) do
    if id ~= nil and id >= 0 then
      wanted[id] = name
    end
  end

  if next(wanted) == nil then
    return {}
  end

  local file = assert(io.open(path, "rb"))
  local _, metadata_count = read_header(file)

  local result = {}

  for _ = 1, metadata_count do
    local key = read_string(file)
    local type_id = read_u32(file)

    if key == "tokenizer.ggml.tokens" and type_id == 9 then
      local element_type = read_u32(file)
      local count = read_u64(file)

      if element_type ~= 8 then
        error("Tokenizer vocabulary is not a string array")
      end

      for index = 0, count - 1 do
        local name = wanted[index]

        if name then
          result[name] = read_string(file)
        else
          skip_string(file)
        end
      end

      break
    else
      skip_value(file, type_id)
    end
  end

  file:close()

  return result
end

function M.inspect_metadata(path)
  local file = assert(io.open(path, "rb"))
  local _, metadata_count = read_header(file)

  local result = {}

  for _ = 1, metadata_count do
    local key = read_string(file)
    local type_id = read_u32(file)

    if key:find("tokenizer", 1, true) or key:find("fim", 1, true) then
      result[#result + 1] = {
        key = key,
        type = type_id,
      }
    end

    skip_value(file, type_id)
  end

  file:close()

  return result
end

local token_formats = {
  -- Standard FIM: Qwen, StarCoder и совместимые модели
  ["<|fim_prefix|>"] = { field = "pre", format = "standard_fim" },
  ["<|fim_suffix|>"] = { field = "suf", format = "standard_fim" },
  ["<|fim_middle|>"] = { field = "mid", format = "standard_fim" },

  ["<fim_prefix>"] = { field = "pre", format = "standard_fim" },
  ["<fim_suffix>"] = { field = "suf", format = "standard_fim" },
  ["<fim_middle>"] = { field = "mid", format = "standard_fim" },

  -- CodeLlama
  ["<pre>"] = { field = "pre", format = "codellama" },
  ["<suf>"] = { field = "suf", format = "codellama" },
  ["<mid>"] = { field = "mid", format = "codellama" },

  -- DeepSeek FIM
  ["<｜fim▁begin｜>"] = { field = "pre", format = "deepseek_fim" },
  ["<｜fim▁end｜>"] = { field = "suf", format = "deepseek_fim" },
  ["<｜fim▁hole｜>"] = { field = "mid", format = "deepseek_fim" },
}

local function scan_fim_tokens(path)
  local file = assert(io.open(path, "rb"))
  local _, metadata_count = read_header(file)

  local result = {}
  local detected_format

  for _ = 1, metadata_count do
    local key = read_string(file)
    local type_id = read_u32(file)

    if key == "tokenizer.ggml.tokens" and type_id == 9 then
      local element_type = read_u32(file)
      local count = read_u64(file)

      if element_type ~= 8 then
        error("Tokenizer vocabulary is not a string array")
      end

      for _ = 1, count do
        local token = read_string(file)
        local definition = token_formats[token:lower()]

        if definition then
          result[definition.field] = result[definition.field] or token
          detected_format = definition.format
        end
      end

      break
    else
      skip_value(file, type_id)
    end
  end

  file:close()

  return result, detected_format
end

local function detect_format(tokens)
  local pre = tokens.pre and tokens.pre:lower()
  local suf = tokens.suf and tokens.suf:lower()
  local mid = tokens.mid and tokens.mid:lower()

  if
    pre == "<|fim_prefix|>" and suf == "<|fim_suffix|>" and mid == "<|fim_middle|>"
    or pre == "<fim_prefix>" and suf == "<fim_suffix>" and mid == "<fim_middle>"
  then
    return "standard_fim"
  end

  if pre == "<pre>" and suf == "<suf>" and mid == "<mid>" then
    return "codellama"
  end

  if pre == "<｜fim▁begin｜>" and suf == "<｜fim▁end｜>" and mid == "<｜fim▁hole｜>" then
    return "deepseek_fim"
  end

  if pre and suf and mid then
    return "custom_fim"
  end

  return "unsupported"
end

function M.read_fim(path)
  local ok, result = pcall(function()
    local ids = read_fim_ids(path)
    local tokens = read_fim_tokens(path, ids)

    local metadata_count = 0

    for _, name in ipairs({ "pre", "suf", "mid" }) do
      if tokens[name] then
        metadata_count = metadata_count + 1
      end
    end

    local scanned = {}

    if metadata_count < 3 then
      scanned = scan_fim_tokens(path)
    end

    for name, token in pairs(scanned) do
      tokens[name] = tokens[name] or token
    end

    local supported = tokens.pre ~= nil and tokens.suf ~= nil and tokens.mid ~= nil

    local source

    if metadata_count == 3 then
      source = "metadata_ids"
    elseif metadata_count > 0 then
      source = "mixed"
    else
      source = "vocabulary"
    end

    return {
      ids = ids,
      tokens = tokens,
      format = detect_format(tokens),
      source = source,
      supported = supported,
    }
  end)

  if not ok then
    return nil, tostring(result)
  end

  return result
end

return M
