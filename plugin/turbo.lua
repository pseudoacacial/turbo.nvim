if vim.fn.has("nvim-0.7.0") == 0 then
  vim.api.nvim_err_writeln("turbo requires at least nvim-0.7.0.1")
  return
end

-- make sure this file is loaded only once
if vim.g.loaded_turbo == 1 then
  return
end
vim.g.loaded_turbo = 1

-- create any global command that does not depend on user setup
-- usually it is better to define most commands/mappings in the setup function
-- Be careful to not overuse this file!
local turbo = require("turbo")

vim.api.nvim_create_user_command(
  "TurboDownload",
  turbo.download_project,
{})
vim.api.nvim_create_user_command(
  "TurboWatch",
  turbo.watch_project,
{})
vim.api.nvim_create_user_command(
  "TurboUnwatch",
  turbo.unwatch_project,
{})
vim.api.nvim_create_user_command(
  "TurboOptions",
  turbo.show_options,
{})
  -- vim.keymap.set(modes, lhs, rhs, {silent = true})
