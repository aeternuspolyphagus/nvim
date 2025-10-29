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
    vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
      callback = function()
        vim.cmd("redrawstatus")
      end,
    })
  end,
}
