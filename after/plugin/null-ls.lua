if (not vim.g.vscode) then

    local null_ls_status_ok, null_ls = pcall(require, 'null-ls')
    if not null_ls_status_ok then
        print('null_ls not found, skipping null_ls plugin')
        return
    end

    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local code_actions = null_ls.builtins.code_actions
    local hover = null_ls.builtins.hover
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    null_ls.setup({
        debug = false,
        sources = {formatting.prettier.with({
            extra_filetypes = {"svelte"}
        }), diagnostics.luacheck, diagnostics.eslint, diagnostics.golangci_lint, diagnostics.jsonlint,
                   formatting.stylelint, formatting.gofmt, formatting.rustfmt, formatting.fixjson, hover.dictionary,
                   code_actions.gitrebase},
        on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({
                    group = augroup,
                    buffer = bufnr
                })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                        vim.lsp.buf.formatting_sync(nil, 1000000000)
                    end
                })
            end
        end
    })

end
