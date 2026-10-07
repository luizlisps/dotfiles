local clue = require("mini.clue")

clue.setup({
    triggers = {
        { mode = { "n", "x" }, keys = "<Leader>" },
    },
    clues = {
        { mode = "n", keys = "<Leader>b", desc = "+Buffers" },
        { mode = "n", keys = "<Leader>c", desc = "+Code" },
        { mode = "n", keys = "<Leader>d", desc = "+Diagnostics" },
        { mode = "n", keys = "<Leader>f", desc = "+Find" },
        { mode = "n", keys = "<Leader>g", desc = "+Git" },
        { mode = "n", keys = "<Leader>h", desc = "+Help" },
        { mode = "n", keys = "<Leader>m", desc = "+Markdown" },
        { mode = "n", keys = "<Leader>p", desc = "+Peek" },
        { mode = "n", keys = "<Leader>r", desc = "+Config" },
        { mode = "x", keys = "<Leader>f", desc = "+Find" },
        { mode = "x", keys = "<Leader>m", desc = "+Markdown" },
    },
    window = {
        delay = 200,
        config = { border = { "+", "-", "+", "|", "+", "-", "+", "|" }, width = "auto" },
    },
})
-- The initial buffer enters its window before this module is loaded.
clue.ensure_buf_triggers()
