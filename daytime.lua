--[[
    Author: gnush
    This will set up an output depending on the daytime.
    Noon: 0
    Night: 1
]]--

-- possible values are: top, back, left, right, bottom
outSide = "bottom"

function time()
    local t = os.time()
    
    if t < 7.5 or t > 22.0 then
        rs.setOutput(outSide, true)
    else
        rs.setOutput(outSide, false)
    end
end

while true do
    time()
    os.sleep(30)
end
