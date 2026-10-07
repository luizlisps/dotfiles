local compose_schema = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"
local github_workflow_schema = "https://json.schemastore.org/github-workflow.json"

vim.lsp.config["yamlls"] = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml" },
    root_markers = { ".git" },
    settings = {
        yaml = {
            validate = true,
            hover = true,
            completion = true,
            format = {
                enable = true,
            },
            schemaStore = {
                enable = true,
            },
            schemas = {
                [compose_schema] = {
                    "compose*.yml",
                    "compose*.yaml",
                    "docker-compose*.yml",
                    "docker-compose*.yaml",
                },
                [github_workflow_schema] = {
                    ".github/workflows/*.yml",
                    ".github/workflows/*.yaml",
                },
            },
        },
    },
}

vim.lsp.config["dockerls"] = {
    cmd = { "docker-langserver", "--stdio" },
    filetypes = { "dockerfile" },
    root_markers = {
        "Dockerfile",
        ".git",
    },
}

if vim.fn.executable("yaml-language-server") == 1 then
    vim.lsp.enable("yamlls")
end

if vim.fn.executable("docker-langserver") == 1 then
    vim.lsp.enable("dockerls")
end
