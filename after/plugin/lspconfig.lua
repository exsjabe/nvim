if (not vim.g.vscode) then
    -- Setup lspconfig.
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
    local servers = {'pyright', 'tsserver', 'vuels', 'gopls', 'html', 'rust_analyzer', 'cssls', 'powershell_es',
                     'dockerls', 'svelte', 'tailwindcss', 'csharp_ls'}
    for _, server in pairs(servers) do
        require('lspconfig')[server].setup {
            capabilities = capabilities,
            on_attach = function(client)
                client.resolved_capabilities.document_formatting = false
                client.resolved_capabilities.document_range_formatting = false
            end
        }
    end

end
