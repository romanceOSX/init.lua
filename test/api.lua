print(vim.fn.stdpath("data"))
print(vim.fn.getcwd())

print(vim.o.runtimepath)

for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
    print(path)
end

