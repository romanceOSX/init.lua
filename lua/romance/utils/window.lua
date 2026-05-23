local M = {}

local _zoom_state = nil

local function capture()
    local wins = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        wins[win] = {
            buf    = vim.api.nvim_win_get_buf(win),
            cursor = vim.api.nvim_win_get_cursor(win),
            width  = vim.api.nvim_win_get_width(win),
            height = vim.api.nvim_win_get_height(win),
        }
    end
    return {
        tree    = vim.fn.winlayout(),
        wins    = wins,
        current = vim.api.nvim_get_current_win(),
    }
end

-- Returns the first (top-left) old window ID in a layout subtree.
-- Used to look up the saved width/height that represents the whole subtree.
local function first_leaf(node)
    if node[1] == "leaf" then return node[2] end
    return first_leaf(node[2][1])
end

-- Recursively rebuilds a saved winlayout tree starting from the current window.
-- Creates all sibling slots before recursing so nested subtrees don't interfere
-- with sibling allocation. Returns the new window ID for this subtree so the
-- parent can apply the correct saved dimension after building each child.
-- id_map accumulates old-win-id → new-win-id for every leaf so the caller can
-- restore focus to the exact window regardless of buffer duplication.
local function restore_node(node, wins, id_map)
    if node[1] == "leaf" then
        local orig = node[2]
        local data = wins[orig]
        local cur  = vim.api.nvim_get_current_win()
        if data and vim.api.nvim_buf_is_valid(data.buf) then
            vim.api.nvim_win_set_buf(cur, data.buf)
            pcall(vim.api.nvim_win_set_cursor, cur, data.cursor)
        end
        id_map[orig] = cur
        return cur
    end

    local children  = node[2]
    local is_row    = node[1] == "row"
    local split_cmd = is_row and "belowright vsplit" or "belowright split"
    local slots     = { vim.api.nvim_get_current_win() }

    for i = 2, #children do
        vim.api.nvim_set_current_win(slots[i - 1])
        vim.cmd(split_cmd)
        slots[i] = vim.api.nvim_get_current_win()
    end

    local new_wins = {}
    for i, child in ipairs(children) do
        vim.api.nvim_set_current_win(slots[i])
        new_wins[i] = restore_node(child, wins, id_map)
    end

    -- Apply saved dimensions to all but the last child; the last gets whatever
    -- remains, which will be correct once its siblings are the right size.
    for i = 1, #children - 1 do
        local rep  = first_leaf(children[i])
        local data = wins[rep]
        if data and new_wins[i] then
            if is_row then
                pcall(vim.api.nvim_win_set_width,  new_wins[i], data.width)
            else
                pcall(vim.api.nvim_win_set_height, new_wins[i], data.height)
            end
        end
    end

    return new_wins[1]
end

function M.zoom_toggle()
    if _zoom_state then
        local saved = _zoom_state
        _zoom_state = nil
        vim.cmd("only")
        local id_map = {}
        restore_node(saved.tree, saved.wins, id_map)
        local target = id_map[saved.current]
        if target and vim.api.nvim_win_is_valid(target) then
            vim.api.nvim_set_current_win(target)
        end
    else
        if #vim.api.nvim_list_wins() < 2 then return end
        _zoom_state = capture()
        vim.cmd("only")
    end
end

return M
