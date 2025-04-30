return {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    event = {
        "BufReadPre /home/luisp/obsidian-notes/**.md",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
        "nvim-telescope/telescope.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        -- plugin configuration
        local opts = {
            workspaces = {
                {
                    name = "notes",
                    path = "/home/luisp/obsidian-notes",
                },
            },

            completion = {
                nvim_cmp = true,
                min_chars = 2,
            },
            mappings = {
                -- Smart action depending on context, either follow link or toggle checkbox.
                ["<cr>"] = {
                    action = function()
                        return require("obsidian").util.smart_action()
                    end,
                    opts = { buffer = true, expr = true },
                }
            },

            -- customize how note IDs are generated given an optional title.
            ---@param title string|?
            ---@return string
            note_id_func = function(title)
                -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
                -- In this case a note with the title 'My new note' will be given an ID that looks
                -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
                local suffix = ""
                if title ~= nil then
                    -- If title is given, transform it into valid file name.
                    suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                else
                    -- If title is nil, just add 4 random uppercase letters to the suffix.
                    for _ = 1, 4 do
                        suffix = suffix .. string.char(math.random(65, 90))
                    end
                end
                return tostring(os.time()) .. "-" .. suffix
            end,

            -- customize how note file names are generated
            ---@param spec { id: string, dir: obsidian.Path, title: string|? }
            ---@return string|obsidian.Path The full path to the new note.
            note_path_func = function(spec)
                local path = spec.dir / tostring(spec.title)
                return path:with_suffix(".md")
            end,

            -- Either 'wiki' or 'markdown'.
            preferred_link_style = "wiki",
            wiki_link_func = "use_alias_only",

            -- Customize the frontmatter data
            note_frontmatter_func = function(note)
                -- Add the title of the note as an alias.
                if note.title then
                    note:add_alias(note.title)
                end

                local out = {
                    id = note.id,
                    aliases = note.aliases,
                    tags = note.tags,
                    created = os.date("%Y-%m-%d %H:%M"),
                }

                -- `note.metadata` contains any manually added fields in the frontmatter.
                -- So here we just make sure those fields are kept in the frontmatter.
                if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                    for k, v in pairs(note.metadata) do
                        out[k] = v
                    end
                end

                return out
            end,

            -- templates
            templates = {
                folder = "_resources/templates",
                date_format = "%Y-%m-%d",
                time_format = "%H:%M",
                -- A map for custom variables, the key should be the variable and the value a function
                substitutions = {},
            },

            -- wsl-open is needed to open links in windows default browser
            follow_url_func = function(url)
                vim.fn.jobstart({ "wsl-open", url })
            end,

            -- bring obsidian to foreground when opening
            open_app_foreground = true,

            picker = {
                name = "telescope.nvim",
                -- Optional, configure key mappings for the picker. These are the defaults.
                -- Not all pickers support all mappings.
                note_mappings = {
                    -- Create a new note from your query.
                    new = "<C-x>",
                    -- Insert a link to the selected note.
                    insert_link = "<C-l>",
                },
                tag_mappings = {
                    -- Add tag(s) to current note.
                    tag_note = "<C-x>",
                    -- Insert a tag at the current location.
                    insert_tag = "<C-l>",
                },
            },

            -- Optional, sort search results by "path", "modified", "accessed", or "created".
            -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
            -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
            sort_by = "modified",
            sort_reversed = true,

            -- Set the maximum number of lines to read from notes on disk when performing certain searches.
            search_max_lines = 1000,

            -- Optional, determines how certain commands open notes. The valid options are:
            -- 1. "current" (the default) - to always open in the current window
            -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
            -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
            open_notes_in = "current",

            -- Optional, configure additional syntax highlighting / extmarks.
            -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
            ui = {
                enable = true,          -- set to false to disable all additional syntax features
                update_debounce = 200,  -- update delay after a text change (in milliseconds)
                max_file_length = 5000, -- disable UI features for files with more than this many lines
                checkboxes = {},        -- don't format checkboxes
                bullets = {},
                external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
                reference_text = { hl_group = "ObsidianRefText" },
                highlight_text = { hl_group = "ObsidianHighlightText" },
                tags = { hl_group = "ObsidianTag" },
                block_ids = { hl_group = "ObsidianBlockID" },
                hl_groups = {
                    -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
                    ObsidianTodo = { bold = true, fg = "#f78c6c" },
                    ObsidianPartlyDone = { bold = true, fg = "#f78c6c" },
                    ObsidianDone = { bold = true, fg = "#89ddff" },
                    ObsidianImportant = { bold = true, fg = "#d73128" },
                    ObsidianBullet = { bold = true, fg = "#89ddff" },
                    ObsidianRefText = { underline = true, fg = "#c792ea" },
                    ObsidianExtLinkIcon = { fg = "#c792ea" },
                    ObsidianTag = { italic = true, fg = "#89ddff" },
                    ObsidianBlockID = { italic = true, fg = "#89ddff" },
                    ObsidianHighlightText = { bg = "#75662e" },
                },
            },

            -- Specify how to handle attachments.
            attachments = {
                -- The default folder to place images in via `:ObsidianPasteImg`.
                -- If this is a relative path it will be interpreted as relative to the vault root.
                -- You can always override this per image by passing a full path to the command instead of just a filename.
                img_folder = "_resources/assets",
                img_text_func = function(client, path)
                    path = client:vault_relative_path(path) or path
                    return string.format("![%s](%s)", path.name, path)
                end,
            },
        }

        -- setup
        require("obsidian").setup(opts)

        -- vim settings
        vim.opt.conceallevel = 1
        vim.diagnostic.disable()

        -- keybinds
        vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<cr>")
        vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<cr>")
        vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>")
        vim.keymap.set("n", "<leader>ot", ":ObsidianTags<cr>")
        vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>")
        vim.keymap.set("v", "<leader>oe", ":ObsidianExtractNote<cr>")
    end,
}
