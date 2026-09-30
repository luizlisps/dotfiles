-- Add a theme entry here after installing variants for every configured app.
-- Theme IDs also name each theme's asset directory.
return {
    sunbather = {
        label = "Sunbather",
        colorscheme = "sunbather",
        ghostty = { light = "sunbather-light", dark = "sunbather-dark" },
        yazi = { light = "sunbather-light", dark = "sunbather-dark" },
        palette = {
            light = {
                warning = { fg = "#5f4b00", bg = "#d6b82c", text = "#262626" },
                telescope = {
                    surface = "#eeeeee", text = "#262626", border = "#a8a8a8",
                    prompt = "#c30771", results = "#008ec4", preview = "#10a778",
                    selection = "#b6d6fd", selection_text = "#262626",
                },
            },
            dark = {
                warning = { fg = "#ffff87", bg = "#121212", text = "#c6c6c6" },
                telescope = {
                    surface = "#121212", text = "#c6c6c6", border = "#767676",
                    prompt = "#d75f87", results = "#008ec4", preview = "#5fd7a7",
                    selection = "#d75f87", selection_text = "#000000",
                },
            },
        },
    },
    solarized = {
        label = "Solarized",
        colorscheme = "solarized",
        ghostty = { light = "solarized-light", dark = "solarized-dark" },
        yazi = { light = "solarized-light", dark = "solarized-dark" },
        palette = {
            light = {
                warning = { fg = "#b58900", bg = "#eee8d5", text = "#002b36" },
                telescope = {
                    surface = "#fdf6e3", text = "#657b83", border = "#93a1a1",
                    prompt = "#d33682", results = "#268bd2", preview = "#859900",
                    selection = "#eee8d5", selection_text = "#586e75",
                },
            },
            dark = {
                warning = { fg = "#b58900", bg = "#073642", text = "#fdf6e3" },
                telescope = {
                    surface = "#002b36", text = "#839496", border = "#586e75",
                    prompt = "#d33682", results = "#268bd2", preview = "#859900",
                    selection = "#073642", selection_text = "#93a1a1",
                },
            },
        },
    },
}
