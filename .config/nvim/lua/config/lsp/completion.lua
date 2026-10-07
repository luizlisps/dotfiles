local function format_completion_item(item)
    local label_details = item.labelDetails or {}
    local label_detail = label_details.detail or ""
    local abbr = item.label

    if label_detail ~= "" then
        abbr = abbr .. " " .. label_detail
    end

    local menu = label_details.description or item.detail or ""

    return {
        abbr = abbr .. " ",
        menu = menu == "" and menu or " " .. menu,
    }
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-completion", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client:is_stopped() then
            return
        end

        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, {
                autotrigger = true,
                convert = format_completion_item,
            })
        end
    end,
})
