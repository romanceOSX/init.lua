
-- 'runtimepath' inspection

--print(vim.inspect(vim.api.nvim_list_runtime_paths()))
local runtimepath = vim.inspect(vim.api.nvim_list_runtime_paths())

-- comma separated string to list
local function _comma_split(str)
    local fields = {}
    for field in str:gmatch('([^,]+)') do
        fields[#fields+1] = field
    end
    return fields
end

local function _print_list(arg) do
    -- print each list element individually
    for _, v in pairs(arg) do
        print(v)
    end
end
end

-- tests 
--_print_list(_comma_split(runtimepath))
print(vim.bo.filetype)
print(type(vim.bo.filetype))

-- vim functions
--print(vim.fn.stdpath('data'))

local test_string = "usr/local/test.lua"
print(test_string)
-- remove .tex extension
print(test_string:sub(1, -5) .. "pdf")

