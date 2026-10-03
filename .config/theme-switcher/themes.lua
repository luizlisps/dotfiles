-- Add a theme entry here after installing variants for every configured app.
-- Theme IDs also name each theme's asset directory.
return {
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
