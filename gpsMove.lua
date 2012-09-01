--[[
    Author: gnush
    To allow absolute movement of a turtle.
    Needs a working gps infrastructure.
    
    Usage: gpsMove x y z
    
    returns nil if either x,y or z is not a number
]]--

x = toNumber(tArgs[1])
y = toNumber(tArgs[2])
z = toNumber(tArgs[3])

if x == nil or y == nil or z == nil then
    return nil;
end

-- initialise the gps program (else the gps api won't work, bug?)
shell.run("gps", "locate")

currX,currY,currZ=gps.locate(2,false)

-- gps api provides coordinates *10 (TODO why?)
currX = currX / 10
currY = currY / 10
currZ = currZ / 10


