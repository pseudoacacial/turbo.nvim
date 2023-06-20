# turbo.nvim
plugin for neovim.
it uses curl to let you work on local files, and keeps them synchronised to a
server over api
## Installation
with lazy.nvim:
```
{
    dir = "path/to/turbo.nvim",
    requires = { "nvim-lua/plenary.nvim", "rktjmp/fwatch.nvim" },
    config = function()
      require("turbo").setup({
        token = "[BEARER AUTH TOKEN HERE]",
        project = "NK_Project (1)",
        package = "package",
        local_path = "path/to/workspace/",
      })
    end,
  },
```
plugin will download (and overwrite) files into: [local_path][project]/[package],
with " (1)" removed from the project name

## Using

my keymaps
```
vim.keymap.set("n", "<leader>td", ":TurboDownload<Enter>", { desc = "download
project" })
vim.keymap.set("n", "<leader>tw", ":TurboWatch<Enter>", { desc = "watch local
project for changes" })
vim.keymap.set("n", "<leader>tu", ":TurboUnwatch<Enter>", { desc = "stop
watching for changes" })
```

## Thanks
[Plugin template][plugin-template]

[plugin-template]: https://github.com/m00qek/plugin-template.nvim
