--[[
    Author: gnush
    This will set up an output depending on the daytime.
    Noon: 0
    Night: 1
]]--

outSide = "bottom"

function time()
    local t = os.time()
    
    if ( t > 22.0 && t < 7.0) then
        rs.setOutput(outSide, true)
    else
        rs.setOutput(outSide, false)
    end
end

function loop()
    time()
    os.sleep(10)
    loop()
end

loop()
