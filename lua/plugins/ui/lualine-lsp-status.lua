return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- === LSP Иконки ===
    local lsp_icons = {
      lua_ls = "󰢱",
      html = "󰌧",
      cssls = "󰌜",
      jsonls = "󰘦",
      yamlls = "",
      powershell_es = "󰨊",
    }

    local function lsp_status()
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
      if #clients == 0 then
        return "LSP: ✗"
      end
      local icons = {}
      for _, client in ipairs(clients) do
        table.insert(icons, lsp_icons[client.name] or "")
      end
      return "LSP: " .. table.concat(icons, " ")
    end

    opts.sections.lualine_c = opts.sections.lualine_c or {}
    table.insert(opts.sections.lualine_c, {
      lsp_status,
      color = { fg = "#a6e3a1", gui = "bold" },
    })

    -- === Aerial ===
    opts.sections.lualine_x = opts.sections.lualine_x or {}
    table.insert(opts.sections.lualine_x, 2, {
      "aerial",
      sep = " > ",
      depth = 2,
      dense = false,
      dense_sep = ".",
      colored = true,
      color = { fg = "#89b4fa" },
    })

    -- === Codeium / Windsurf с мигающим AI ===
    local prev_current = 0
    local timer = vim.loop.new_timer()
    local flash = false

    local codeium_status = function()
      local ok, vt = pcall(require, "codeium.virtual_text")
      if not ok then
        return ""
      end
      local status = vt.status()

      if status.state == "idle" then
        prev_current = 0
        return "%#CodeiumIdle#󰚪 AI"
      elseif status.state == "waiting" then
        return "%#CodeiumWaiting#󱙺 AI…"
      elseif status.state == "completions" and status.total > 0 then
        -- если появился новый вариант, запускаем мигание
        if status.current ~= prev_current then
          flash = true
          prev_current = status.current
          timer:start(
            200,
            0,
            vim.schedule_wrap(function()
              flash = false
              vim.cmd("redrawstatus")
            end)
          )
        end
        if flash then
          return "%#CodeiumFlash#󰚩 " .. status.current .. "/" .. status.total
        else
          return "%#CodeiumActive#󰚩 " .. status.current .. "/" .. status.total
        end
      end
      return ""
    end

    table.insert(opts.sections.lualine_x, 1, { codeium_status })

    -- === Highlights ===
    vim.api.nvim_set_hl(0, "CodeiumIdle", { fg = "#585b70" }) -- серый
    vim.api.nvim_set_hl(0, "CodeiumWaiting", { fg = "#f9e2af" }) -- жёлтый
    vim.api.nvim_set_hl(0, "CodeiumActive", { fg = "#a6e3a1" }) -- зелёный
    vim.api.nvim_set_hl(0, "CodeiumFlash", { fg = "#f38ba8", bold = true }) -- мигание, розовый/яркий

    -- === Автообновление статуса ===
    vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
      callback = function()
        vim.cmd("redrawstatus")
      end,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "TextChangedI" }, {
      callback = function()
        vim.cmd("redrawstatus")
      end,
    })
  end,
}
