-- Debug Adapter Protocol (DAP)
-- https://github.com/Microsoft/vscode-cpptools

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
        },
        config = function()
            local dap = require('dap')
            local dap_adapther_path = vim.fn.exepath("OpenDebugAD7")

            if not dap_adapther_path then
                error("Please install the c-lang DAP adapter")
            end

            dap.configurations.c = {
                {
                    type = 'cppdbg',
                    request = 'launch',
                    name = 'Launch file',

                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopAtEntry = true,
                    MIMode = "lldb",
                    miDebuggerPath = function()
                        return vim.fn.exepath('lldb-mi')
                    end,
                },
            }

            --print("not available")
            --print(dap_adapther_path)

            dap.adapters.cppdbg = {
                type = 'executable',
                command = dap_adapther_path,
                id = "cppdbg",
                request = 'launch',
            }
        end
    },
    {
        "nvim-telescope/telescope-dap.nvim",
        dependencies = {
            "mfussenegger/nvim-dap",
            'nvim-telescope/telescope.nvim',
        },
        config = function()
            require('telescope').load_extension('dap')
        end
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
        config = true,
    },
}
