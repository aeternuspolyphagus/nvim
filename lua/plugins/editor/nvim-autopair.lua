return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    npairs.setup({
      check_ts = true, -- использовать Treesitter для умного закрытия
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        typescript = { "string", "template_string" },
        powershell = { "string", "string_literal" },
      },
      disable_filetype = { "TelescopePrompt", "vim" },
      disable_in_macro = true,
      disable_in_visualblock = false,
      disable_in_replace_mode = true,
      ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
      enable_moveright = true,
      enable_afterquote = true,
      enable_check_bracket_line = true,
      enable_bracket_in_quote = true,
      enable_abbr = false,
      break_undo = true,
      map_cr = true,
      map_bs = true,
      map_c_h = false,
      map_c_w = false,
    })

    -- Специальные правила для PowerShell
    npairs.add_rules({
      -- Правило для переменных ${} в PowerShell
      Rule("{", "}", "powershell"):with_pair(function(opts)
        local prev_char = opts.line:sub(opts.col - 1, opts.col - 1)
        return prev_char == "$"
      end),

      -- Правило для массивов @() в PowerShell
      Rule("(", ")", "powershell"):with_pair(function(opts)
        local prev_char = opts.line:sub(opts.col - 1, opts.col - 1)
        return prev_char == "@"
      end),

      -- Правило для хеш-таблиц @{} в PowerShell
      Rule("{", "}", "powershell"):with_pair(function(opts)
        local prev_char = opts.line:sub(opts.col - 1, opts.col - 1)
        return prev_char == "@"
      end),
    })

    -- Интеграция с blink.cmp
    -- Автоматически добавляет закрывающую скобку после выбора функции из автодополнения
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    -- Хук для blink.cmp (если используется через nvim-cmp совместимость)
    -- Если blink.cmp полностью независим, этот блок может не понадобиться
    local ok, cmp = pcall(require, "cmp")
    if ok then
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
  end,
}
