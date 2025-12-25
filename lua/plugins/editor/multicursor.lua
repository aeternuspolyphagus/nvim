return {
  "jake-stewart/multicursor.nvim",
  -- branch = "1.0",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()
    local set = vim.keymap.set
    -- Add or skip cursor above/below the main cursor.
    set({ "n", "x" }, "<leader>bck", function()
      mc.lineAddCursor(-1)
    end, { desc = "Add cursor above" })
    set({ "n", "x" }, "<leader>bcj", function()
      mc.lineAddCursor(1)
    end, { desc = "Add cursor below" })
    set({ "n", "x" }, "<leader>bc<c-k>", function()
      mc.lineSkipCursor(-1)
    end, { desc = "Skip and add cursor above" })
    set({ "n", "x" }, "<leader>bc<c-j>", function()
      mc.lineSkipCursor(1)
    end, { desc = "Skip and add cursor below" })
    -- Add or skip adding a new cursor by matching word/selection.
    set({ "n", "x" }, "<leader>bcn", function()
      mc.matchAddCursor(1)
    end, { desc = "Match add cursor (next)" })
    set({ "n", "x" }, "<leader>bcs", function()
      mc.matchSkipCursor(1)
    end, { desc = "Match skip cursor (next)" })
    set({ "n", "x" }, "<leader>bc<c-n>", function()
      mc.matchAddCursor(-1)
    end, { desc = "Match add cursor (previous)" })
    set({ "n", "x" }, "<leader>bc<c-s>", function()
      mc.matchSkipCursor(-1)
    end, { desc = "Match skip cursor (previous)" })
    -- Add and remove cursors with control + left click.
    set("n", "<c-leftmouse>", mc.handleMouse, { desc = "Handle mouse click" })
    set("n", "<c-leftdrag>", mc.handleMouseDrag, { desc = "Handle mouse drag" })
    set("n", "<c-leftrelease>", mc.handleMouseRelease, { desc = "Handle mouse release" })
    -- Disable and enable cursors.
    set({ "n", "x" }, "<leader>bc<c-q>", mc.toggleCursor, { desc = "Toggle cursors" })
    -- Mappings defined in a keymap layer only apply when there are
    -- multiple cursors. This lets you have overlapping mappings.
    mc.addKeymapLayer(function(layerSet)
      -- Select a different cursor as the main one.
      layerSet({ "n", "x" }, "<leader>bch", mc.prevCursor, { desc = "Previous cursor" })
      layerSet({ "n", "x" }, "<leader>bcl", mc.nextCursor, { desc = "Next cursor" })
      -- Delete the main cursor.
      layerSet({ "n", "x" }, "<leader>bcx", mc.deleteCursor, { desc = "Delete cursor" })
      -- Enable and clear cursors using escape.
      layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end, { desc = "Toggle/clear cursors" })
    end)
    -- Customize how cursors look.
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { reverse = true })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorMatchPreview", { link = "Search" })
    hl(0, "MultiCursorDisabledCursor", { reverse = true })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
