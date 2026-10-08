-- Add a theme entry here after installing variants for every configured app.
-- Theme IDs also name each theme's asset directory.
return {
    web = {
        label = "Web",
        colorscheme = "web",
        ghostty = { light = "web-light", dark = "web-dark" },
        yazi = { light = "web-light", dark = "web-dark" },
        palette = {
            light = {
                warning = { fg = "#8a4b00", bg = "#fff4ce", text = "#000000" },
                telescope = {
                    surface = "#f3f4f6", text = "#000000", border = "#d1d5db",
                    prompt = "#0000ee", results = "#008000", preview = "#006a70",
                    selection = "#e5e7eb", selection_text = "#000000",
                },
                colors = {
                    background = "#ffffff", surface = "#f3f4f6", text = "#000000",
                    muted = "#5b616e", border = "#d1d5db", selection = "#e5e7eb",
                    link = "#0000ee", visited = "#551a8b", active = "#ff0000",
                    error = "#b00020", warning = "#8a4b00", success = "#008000",
                    string = "#008000", number = "#8a4b00", keyword = "#551a8b",
                    type = "#006a70", func = "#0000ee", constant = "#a31515",
                    variable = "#000000", operator = "#000000",
                },
            },
            dark = {
                warning = { fg = "#f2cc60", bg = "#3a3000", text = "#ffffff" },
                telescope = {
                    surface = "#1c1c1c", text = "#f5f5f5", border = "#4b5563",
                    prompt = "#8ab4f8", results = "#3fb950", preview = "#56d4dd",
                    selection = "#30363d", selection_text = "#f5f5f5",
                },
                colors = {
                    background = "#111111", surface = "#1c1c1c", text = "#f5f5f5",
                    muted = "#b4b4b4", border = "#4b5563", selection = "#30363d",
                    link = "#8ab4f8", visited = "#d2a8ff", active = "#ff7b72",
                    error = "#ff7b72", warning = "#f2cc60", success = "#3fb950",
                    string = "#7ee787", number = "#f2cc60", keyword = "#d2a8ff",
                    type = "#56d4dd", func = "#8ab4f8", constant = "#ffa198",
                    variable = "#f5f5f5", operator = "#c9d1d9",
                },
            },
        },
    },
}
