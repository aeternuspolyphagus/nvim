return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local lsp_icons = {
      lua_ls = "󰢱", -- Lua
      html = "󰌧", -- HTML
      cssls = "󰌜", -- CSS
      jsonls = "󰘦", -- JSON
      yamlls = "", -- YAML
      powershell_es = "󰨊", -- PowerShell
    }
    local function lsp_status()
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
      if #clients == 0 then
        return "LSP: ✗"
      end
      local icons = {}
      for _, client in ipairs(clients) do
        local icon = lsp_icons[client.name] or "" -- fallback
        table.insert(icons, icon)
      end
      return "LSP: " .. table.concat(icons, " ")
    end
    opts.sections.lualine_c = opts.sections.lualine_c or {}
    table.insert(opts.sections.lualine_c, {
      lsp_status,
      color = { fg = "#a6e3a1", gui = "bold" },
    })
    opts.sections.lualine_x = opts.sections.lualine_x or {}
    table.insert(
      opts.sections.lualine_x,
      1,
      { -- Вставка в начало секции для логического порядка
        "aerial",
        sep = " > ", -- Разделитель между символами иерархии
        depth = 2, -- Ограничение глубины (например, только 2 уровня: Class > Method)
        dense = false, -- Полный режим с иконками
        dense_sep = ".", -- Разделитель в плотном режиме (если dense = true)
        colored = true, -- Окраска иконок по типам символов
        color = { fg = "#89b4fa" }, -- Кастомный цвет текста (синий акцент, адаптировано под Kanagawa)
      }
    )
    vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
      callback = function()
        vim.cmd("redrawstatus")
      end,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      callback = function()
        if require("aerial").get_location() then
          vim.cmd("redrawstatus")
        end
      end,
    })
  end,
}
