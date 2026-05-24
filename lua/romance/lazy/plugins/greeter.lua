return {
    {
        "goolord/alpha-nvim",
        -- dependencies = { 'echasnovski/mini.icons' },
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local dashboard = require('alpha.themes.dashboard')

            local header_path = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h") .. "/greeter.txt"
            dashboard.section.header.val = vim.fn.readfile(header_path)

            require('alpha').setup(dashboard.config)
        end
    },
}
