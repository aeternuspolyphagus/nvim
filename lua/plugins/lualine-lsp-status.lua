return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Добавляем компонент LSP в статусную строку
    table.insert(opts.sections.lualine_x, 1, {
      function()
        local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
        if #buf_clients == 0 then
          return ""
        end

        local buf_client_names = {}
        for _, client in pairs(buf_clients) do
          if client.name ~= "null-ls" and client.name ~= "copilot" then
            table.insert(buf_client_names, client.name)
          end
        end

        if #buf_client_names > 0 then
          return "  " .. table.concat(buf_client_names, ", ")
        end
        return ""
      end,
      color = { fg = "#98c379" },
    })
  end,
}
