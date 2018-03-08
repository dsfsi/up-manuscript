require "../config.lua"

function input_all(list)
   for _, i in ipairs(list) do
      tex.sprint("\\input{../" .. i .. "}")
   end
end

function value(key)
   tex.sprint(key)
end
