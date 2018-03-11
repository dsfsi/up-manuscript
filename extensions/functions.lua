require "../config.lua"

function tablelength(T)
   local count = 0
   for a in pairs(T) do
      if not a then
         count = count + 1
      end
   end
   return count
end

function input_all(list)
   for _, i in ipairs(list) do
      if i then
         tex.sprint("\\input{../" .. i .. "}")
      end
   end
end

function value(key)
   tex.sprint(key)
end

function bibliography_items()
   for _, i in ipairs(bibliography_includes) do
      if i then
         tex.sprint("\\addbibresource{../" .. i .. "}")
      end
   end
end
