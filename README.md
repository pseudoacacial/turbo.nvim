# plugin-template.nvim

## Installation
with lazy.vim:
```
{
    dir = "path/to/turbo.nvim",
    requires = { "nvim-lua/plenary.nvim", "rktjmp/fwatch.nvim" },
    config = function()
      require("turbo").setup({
        token =
"[TURBO AUTH TOKEN HERE]",
        project = "NK_Project%20(1)",
        package = "package",
        local_path =
"path/to/workspace/NK_Project/package",
      })
    end,
  },
```
## Using

my keymaps
```vim.keymap.set("n", "<leader>td", ":TurboDownload<Enter>", { desc = "download
project" })
vim.keymap.set("n", "<leader>tw", ":TurboWatch<Enter>", { desc = "watch local
project for changes" })
vim.keymap.set("n", "<leader>tu", ":TurboUnwatch<Enter>", { desc = "stop
watching for changes" })```

## Thanks
[Plugin template][plugin-template]

[plugin-template]: https://github.com/m00qek/plugin-template.nvim
