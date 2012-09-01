--[[
    Author: gnush
    This is a prototype for a turtle based cobble farm.
    Required: Mining Turtle
]]--

while true do
    if turtle.detect() and turtle.getItemCount(1) <= 16 then
        turtle.dig()
    else
        turtle.back()
        turtle.turnLeft()
        turtle.drop()
        turtle.turnRight()
        turtle.forward()
    end
end
