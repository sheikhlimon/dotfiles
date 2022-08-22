local M = {}

M.autotag = function()
   local present, autotag = pcall(require, "nvim-ts-autotag")

   if present then
      autotag.setup()
   end
end

M.autosave = function()
   local present, autosave = pcall(require, "autosave")

   if present then
      autosave.setup()
   end
end

return M
