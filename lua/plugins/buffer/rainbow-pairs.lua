return {
  "aeternuspolyphagus/rainbow-pairs",
  config = function()
    require("rainbow-pairs").setup({
      debounce = 80,
      priority = 200,

      colors = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      },
    })
  end,
}
