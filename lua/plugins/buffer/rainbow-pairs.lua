return {
  "aeternuspolyphagus/rainbow-pairs",
  config = function()
    require("rainbow-pairs").setup({
      colors = {
        "Function",
        "Keyword",
        "Type",
        "Constant",
        "Special",
        "String",
      },
    })
  end,
}
