require "../config.lua"



-- function dirtree(dir)
--
--   if string.sub(dir, -1) == "/" then
--     dir=string.sub(dir, 1, -2)
--   end
--
--   local function yieldtree(dir)
--     local items = {}
--     for item in lfs.dir(dir) do
--       table.insert(items, item)
--     end
--     table.sort(items)
--
--     for _, entry in ipairs(items) do
--       if not entry:match("^%.") then
--         entry=dir.."/"..entry
--           if lfs.isdir(entry) then
--             yieldtree(entry)
--           else
--             coroutine.yield(entry)
--           end
--       end
--     end
--   end
--
--   return coroutine.wrap(function() yieldtree(dir) end)
-- end
--
--
-- local cwd = lfs.currentdir()
-- lfs.chdir("../content")
-- for i in dirtree(lfs.currentdir()) do
--   local filename = i:gsub(".*/([^/]+)$","%1")
--   tex.sprint("\\input " ..  i .. " ")
-- end
-- lfs.chdir(cwd)
