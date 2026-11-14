return {
  {
    "milanglacier/minuet-ai.nvim",
    opts = {
      provider = "openai_fim_compatible",
      n_completions = 1,
      context_window = 512,
      provider_options = {
        openai_fim_compatible = {
          api_key = "APPDATA",
          name = "llama.cpp",
          end_point = "http://localhost:8080/v1/completions",
          model = "PLACEHOLDER",

          optional = {
            max_tokens = 56,
            temperature = 0,
            top_p = 0.9,
          },
          template = {
            prompt = function(before, after, _)
              local prompt = require("config.minuet_prompt")

              local result, err = prompt.build(before, after)

              if not result then
                vim.notify("Minuet: " .. tostring(err), vim.log.levels.WARN)

                return ""
              end

              return result
            end,
            suffix = false,
          },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or { "lsp", "path", "snippets", "buffer" }

      table.insert(opts.sources.default, "minuet")

      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.minuet = {
        name = "minuet",
        module = "minuet.blink",
        async = true,
        timeout_ms = 10000,
        score_offset = 50,
      }
      opts.completion = opts.completion or {}
      opts.completion.menu = opts.completion.menu or {}
      opts.completion.menu.draw = opts.completion.menu.draw or {}

      local draw = opts.completion.menu.draw

      draw.components = draw.components or {}

      draw.components.source_icon = {
        ellipsis = false,
        text = function(ctx)
          local icons = {
            minuet = "󱗻",
          }

          return icons[ctx.source_name:lower()] or ""
        end,
        highlight = "BlinkCmpSource",
      }

      local columns = draw.columns
        or {
          { "label", "label_description", gap = 1 },
          { "kind_icon", "kind" },
        }

      local has_source_icon = false

      for _, column in ipairs(columns) do
        if type(column) == "table" and vim.tbl_contains(column, "source_icon") then
          has_source_icon = true
          break
        end
      end

      if not has_source_icon then
        table.insert(columns, { "source_icon" })
      end

      draw.columns = columns
    end,
  },
}
