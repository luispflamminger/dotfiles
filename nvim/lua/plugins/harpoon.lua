return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  keys = {
    {
      "<Space>h",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Harpoon add file",
    },
    {
      "<Space>H",
      function()
        local harpoon = require("harpoon")
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = "Harpoon menu",
    },
    {
      "<Space>j",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Harpoon file 1",
    },
    {
      "<Space>k",
      function()
        require("harpoon"):list():select(2)
      end,
      desc = "Harpoon file 2",
    },
    {
      "<Space>l",
      function()
        require("harpoon"):list():select(3)
      end,
      desc = "Harpoon file 3",
    },
  },
}
