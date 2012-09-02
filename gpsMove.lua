--[[
    Author: gnush
    To allow absolute movement of a turtle.
    Needs a working gps infrastructure.
    
    Usage: gpsMove <x> <y> <z>
    
    returns nil if either x,y or z is not a number
]]--
Point = { x = 0,
          y = 0,
          z = 0,
          
          new = function(this, o)
            o = o or {}
            setmetatable(o, this)
            this.__index=this
            return o
          end,
          
          -- calculates the distance of two points (euclidean)
          dist = function(this, p)
            return math.sqrt(math.pow(this.x - p.x, 2) + math.pow(this.y - p.y, 2) + math.pow(this.z - p.z, 2))
          end,
          
          -- compares two points (coordinates)
          compare = function(this, p)
            return (this.x == p.x) and (this.y == p.y) and (this.z == p.z)
          end
}

local function printUsage()
        print( "Usage:" )
        print( "gpsMove <x> <y> <z>" )
end

local tArgs = { ... }
if #tArgs < 3 then
        printUsage()
        return
end

dst = Point:new{x = tonumber(tArgs[1]), y = tonumber(tArgs[2]), z = tonumber(tArgs[3])}

if dst.x == nil or dst.y == nil or dst.z == nil then
    return nil
end

-- initialise the gps program (else the gps api won't work, bug?)
devnull=shell.run("gps", "locate")

x0,y0,z0=gps.locate(2,false)
src = Point:new{x=x0, y=y0, z=z0}

-- align turtle to x-axis
turtle.select(8)
i=0
while i < 4 do
    dig=turtle.dig()
    turtle.forward()
    tmp = gps.locate(2, false)
    turtle.back()
    
    if dig then
        turtle.place()
    end
    
    if(src.x < tmp) then
        break
    end
    
    turtle.turnLeft()
end
turtle.select(1)

-- as long as turtle is not at goal, make steps
while not dst:compare(src) do
    -- get neighbors
    neighbors = {}
    max = Point:new{x=134217727,y=134217727,z=134217727}
    posX = {1,0,-1,0}
    posY = {0,-1,0,1}

    i = 1
    while i < 5 do
        if(not turtle.detect()) then
            neighbors[i] = Point:new{x=src.x+posX[i], y=src.y+posY[i],z=src.z}
        else
            neighbors[i] = max
        end
        
        turtle.turnLeft()
        i = i + 1
    end

    if(not turtle.detectUp()) then
        neighbors[5] = Point:new{x=src.x,y=src.y,z=src.z+1}
    else
        neighbors[5] = max
    end

    if(not turtle.detectDown()) then
        neighbors[6]      = Point:new{x=src.x,y=src.y,z=src.z-1}
    else
        neighbors[6] = max
    end


    -- find next point
    minDist=2147483647
    i=1
    while i<7 do
        if dst:dist(neighbors[i]) < minDist then
            minDist = dst:dist(neighbors[i])
            direction=i
        end
        
        i=i+1
    end

    -- goto next point
    if(direction == 1) then
        turtle.forward()
    elseif (direction == 2) then
        turtle.turnLeft()
        turtle.forward()
        turtle.turnRight()
    elseif (direction == 3) then
        turtle.back()
    elseif (direction == 4) then
        turtle.turnRight()
        turtle.forward()
        turtle.turnLeft()
    elseif (direction == 5) then
        turtle.up()
    elseif (direction == 6) then
        turtle.down()
    end

    src=neighbors[direction]
end
