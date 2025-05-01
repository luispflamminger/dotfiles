local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local function move_current_file()
    local current_file = vim.api.nvim_buf_get_name(0)
    if current_file == "" then
        return
    end

    pickers.new({}, {
        prompt_title = "Select Destination Folder",
        finder = finders.new_oneshot_job(
            { "find", ".", "-maxdepth", "1", "-type", "d", }, {}),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection then
                    local dest_folder = selection[1]
                    local filename = vim.fn.fnamemodify(current_file, ":t")
                    local new_path = dest_folder .. "/" .. filename
                    local success, err = os.rename(current_file, new_path)
                    if success then
                        vim.api.nvim_buf_set_name(0, new_path)
                        print("File moved to " .. new_path)
                    else
                        print("Error moving file: " .. err)
                    end
                end
            end)
            return true
        end,
    }):find()
end

vim.keymap.set('n', '<leader>mf', move_current_file, {})

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "plenary" },
        tag = "0.1.5",
        config = function()
            require("telescope").setup()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fp', builtin.git_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        end,
    },
}
