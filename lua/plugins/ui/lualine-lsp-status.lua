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
