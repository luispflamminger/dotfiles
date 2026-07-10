return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  dependencies = {
    {
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {},
        picker = {
          actions = {
            opencode_send = function(...)
              return require("opencode").snacks_picker_send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  config = function()
    local oc = require("opencode")
    local opencode_cmd = "opencode --port"
    local opencode_win = { position = "right", enter = false }

    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks").terminal.open(opencode_cmd, { win = opencode_win })
        end,
      },
      select = {
        snacks = {
          layout = {
            width = 0.8,
          },
        },
      },
    }

    vim.o.autoread = true

    vim.keymap.set({ "n", "x" }, "<leader>oa", function() oc.ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
    vim.keymap.set({ "n", "x" }, "<leader>os", oc.select,  { desc = "Execute opencode action" })
    vim.keymap.set({ "n", "t" }, "<leader>ot", oc.toggle,  { desc = "Toggle opencode" })

    vim.keymap.set({ "n", "x" }, "<leader>or", function() return oc.operator("@this ") end,        { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n",          "<leader>ol", function() return oc.operator("@this ") .. "_" end, { desc = "Add line to opencode",  expr = true })

    vim.keymap.set("n", "<leader>ou", function() oc.command("session.half.page.up") end,   { desc = "Scroll opencode up" })
    vim.keymap.set("n", "<leader>od", function() oc.command("session.half.page.down") end, { desc = "Scroll opencode down" })

    -- Select and connect to a running opencode instance
    vim.keymap.set("n", "<leader>oc", function()
      require("opencode.server.discovery")
        .get_all()
        :next(function(servers)
          return require("opencode.ui.select_server").select_server(servers)
        end)
        :next(function(server)
          return server:connect()
        end)
        :catch(function(err)
          if err then
            vim.notify("opencode: " .. tostring(err), vim.log.levels.ERROR)
          end
        end)
    end, { desc = "Connect to opencode instance" })

    -- Pick a directory and launch a new opencode instance there
    vim.keymap.set("n", "<leader>on", function()
      require("snacks").picker.pick({
        title = "Launch opencode in…",
        finder = function(opts, ctx)
          return require("snacks.picker.source.proc").proc(
            ctx:opts({
              cmd = "find",
              args = { vim.env.HOME .. "/dev", "-mindepth", "1", "-maxdepth", "6", "-type", "d" },
              transform = function(item)
                item.file = item.text
              end,
            }),
            ctx
          )
        end,
        format = "file",
        confirm = function(picker, item)
          picker:close()
          if not item then return end
          local dir = item.file

          -- Allocate a free port so we know exactly which instance to connect to
          local tcp = vim.uv.new_tcp()
          tcp:bind("127.0.0.1", 0)
          local port = tcp:getsockname().port
          tcp:close()

          require("snacks").terminal.open("opencode --port " .. port, {
            cwd = dir,
            win = opencode_win,
          })

          -- Poll until the server is up, then connect directly by URL
          local Server = require("opencode.server")
          local url = "http://localhost:" .. port

          local function try(attempt)
            Server.new(url)
              :next(function(server)
                server:connect():catch(function(err)
                  if err then vim.notify("opencode: " .. tostring(err), vim.log.levels.ERROR) end
                end)
              end)
              :catch(function()
                if attempt < 10 then
                  vim.defer_fn(function() try(attempt + 1) end, 1000)
                else
                  vim.notify("opencode: port " .. port .. " did not respond in time", vim.log.levels.WARN)
                end
              end)
          end

          vim.defer_fn(function() try(1) end, 1000)
        end,
      })
    end, { desc = "Launch opencode in directory" })
  end,
}
