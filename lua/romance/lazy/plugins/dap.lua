-- Debug Adapter Protocol (DAP)
-- Adapters: cpptools (C/C++), codelldb (Rust), debugpy (Python)

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap    = require('dap')
            local dapui  = require('dapui')

            -- Auto open/close DAP UI with debug sessions
            dap.listeners.before.attach.dapui_config          = function() dapui.open() end
            dap.listeners.before.launch.dapui_config          = function() dapui.open() end
            dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
            dap.listeners.before.event_exited.dapui_config    = function() dapui.close() end

            -- Keymaps
            vim.keymap.set("n", "<leader>db",  dap.toggle_breakpoint,  { desc = "Toggle breakpoint" })
            vim.keymap.set("n", "<leader>dB",  function()
                dap.set_breakpoint(vim.fn.input("Condition: "))
            end, { desc = "Conditional breakpoint" })
            vim.keymap.set("n", "<leader>dc",  dap.continue,           { desc = "Continue" })
            vim.keymap.set("n", "<leader>dso", dap.step_over,          { desc = "Step over" })
            vim.keymap.set("n", "<leader>dsi", dap.step_into,          { desc = "Step into" })
            vim.keymap.set("n", "<leader>dsx", dap.step_out,           { desc = "Step out" })
            vim.keymap.set("n", "<leader>dr",  dap.repl.open,          { desc = "Open REPL" })
            vim.keymap.set("n", "<leader>du",  dapui.toggle,           { desc = "Toggle DAP UI" })

            -- ── C / C++ ─────────────────────────────────────────────────────────
            local cpptools = vim.fn.exepath("OpenDebugAD7")
            if cpptools ~= "" then
                dap.adapters.cppdbg = {
                    id      = "cppdbg",
                    type    = 'executable',
                    command = cpptools,
                }
                local cpp_launch = {
                    {
                        type    = 'cppdbg',
                        request = 'launch',
                        name    = 'Launch file',
                        program = function()
                            return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/', 'file')
                        end,
                        cwd          = '${workspaceFolder}',
                        stopAtEntry  = true,
                        MIMode       = "lldb",
                        miDebuggerPath = vim.fn.exepath('lldb-mi') ~= "" and vim.fn.exepath('lldb-mi') or nil,
                    },
                }
                dap.configurations.c   = cpp_launch
                dap.configurations.cpp = cpp_launch
            end

            -- ── Rust (codelldb preferred, falls back to cppdbg) ─────────────────
            local codelldb = vim.fn.exepath("codelldb")
            if codelldb ~= "" then
                dap.adapters.codelldb = {
                    type       = 'server',
                    port       = '${port}',
                    executable = { command = codelldb, args = { '--port', '${port}' } },
                }
                dap.configurations.rust = {
                    {
                        type    = 'codelldb',
                        request = 'launch',
                        name    = 'Launch Rust program',
                        program = function()
                            return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
                        end,
                        cwd          = '${workspaceFolder}',
                        stopOnEntry  = false,
                    },
                }
            elseif dap.configurations.cpp then
                dap.configurations.rust = dap.configurations.cpp
            end

            -- ── Python (debugpy) ─────────────────────────────────────────────────
            local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
            local debugpy_python = vim.fn.executable(mason_debugpy) == 1
                and mason_debugpy
                or (vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python")

            dap.adapters.python = {
                type    = 'executable',
                command = debugpy_python,
                args    = { '-m', 'debugpy.adapter' },
            }
            dap.configurations.python = {
                {
                    type    = 'python',
                    request = 'launch',
                    name    = 'Launch file',
                    program = '${file}',
                    pythonPath = function()
                        local venv = os.getenv('VIRTUAL_ENV')
                        if venv then return venv .. '/bin/python' end
                        return debugpy_python
                    end,
                },
            }
        end
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            require("dapui").setup()
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-dap-virtual-text").setup({ commented = true })
        end,
    },
    {
        "nvim-telescope/telescope-dap.nvim",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require('telescope').load_extension('dap')
        end
    },
}
