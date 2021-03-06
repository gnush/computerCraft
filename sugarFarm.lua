--[[
    Author: gnush
    An automated sugar cane farm.
    Need an active gps to work.
    Uses gpsMove.lua for positioning.
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

home      = Point:new{x=197, y=-33, z=68}   -- Point of the disk drive
start     = Point:new{x=200, y=-34, z=69}   -- Where to start harvesting?
dropzone  = Point:new{x=198, y=-32, z=69}   -- Point to drop the harvested stuff
numRows   = 4                               -- number of rows to harvest
length    = 15                              -- length of each row
pos       = 0                               -- Directions are {0: x+, 1: y+, 2: x-, 3: y-}

-- TODO add direction for the rows

function position()
    local x0,y0,z0=gps.locate(2,false)
    local src = Point:new{x=x0, y=y0, z=z0}
    
    turtle.select(8)
    local i=0
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
        
    i=0
    while i < pos do
        turtle.turnRight()
        i = i+1
    end
end

function harvest_lane()
    position()

    local slot=1
    local i=0
    while i < length+1 do
        if turtle.getItemSpace(slot) > 2 then
            turtle.dig()
            turtle.digDown()
            turtle.forward()
        else
            slot = slot + 1
            turtle.select(slot)
            i = i - 1
        end
        i = i + 1
    end
    
    i=0
    while i < length+1 do
        turtle.back()
        i = i+1
    end
end

function harvest()
    local p = Point:new{x=start.x, y=start.y, z=start.z}
    
    local i = 0
    while i < numRows do
        shell.run("gpsMove", p.x, p.y, p.z)
        harvest_lane()
        p = Point:new{x=p.x, y=p.y-2, z=p.z}
        i = i+1
    end
end

function drop()
    shell.run("gpsMove", dropzone.x, dropzone.y, dropzone.z)
    
    local i=1
    while i < 10 do
        turtle.select(i)
        turtle.drop()   -- FIXME change to dropDown() if computercraft version >= 1.4
        i = i+1
    end
end

while true do
    shell.run("gpsMove", home.x, home.y, home.z)
    harvest()
    drop()
    shell.run("gpsMove", home.x, home.y, home.z)
    os.sleep(60)
end
