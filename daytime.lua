--[[
    Author: gnush
    This will set up an output depending on the daytime.
    Noon: 0
    Night: 1
]]--

-- possible values are: top, back, left, right, bottom
outSides = {"back", "left", "right"}

 
function list_iter(t)
  local i = 0
  local n = table.getn(t)
  return function ()
           i = i + 1
           if i <= n then return t[i] end
         end
end

function time()
    local t = os.time()
    
    if t < 7.5 or t > 21.5 then
        for s in list_iter(outSides) do
            rs.setOutput(s, true)
        end
    else
        for s in list_iter(outSides) do
            rs.setOutput(s, false)
        end
    end
end

while true do
    time()
    os.sleep(30)
end
