return {
    {
        "dense-analysis/ale",
        config = function()
            vim.g.ale_sign_error = '•'
            vim.g.ale_sign_warning = '•'
            vim.g.ale_sign_info = '·'
            vim.g.ale_sign_style_error = '·'
            vim.g.ale_sign_style_warning = '·'
            vim.g.ale_linters = { cs = { 'OmniSharp' } }

            -- Disable virtual text (inline error messages)
            vim.g.ale_virtualtext_cursor = 0

            -- Enable underline highlighting for errors
            vim.g.ale_set_highlights = 1
        end
    }
}