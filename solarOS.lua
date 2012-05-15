--[[
    Author: gnush
    This program can be used as a basic operating system for whatever you want to implement.
    It features a login and some basic filesystem stuff.
    Tested with CraftOS 1.3
]]--
-- disable terminating via Ctrl + t
os.pullEvent = os.pullEventRaw

-- variables for the prompt
program = "solarOS"
version = "0.4.6"
host = "derp"
user = ""
k = 65432895

-- define users and their respective passwords
users = {"root", "narwhal"}
pass = {"vzMfrxL6+Ujty|N7[>^?_@0($" , "%#\"P8,U;.Vjty|N7[>^?_@0($"}

-- variables for controlling the output
outSide = "left"                       -- possible values are: top, back, left, right, bottom
signal = {colors.green, colors.blue}   -- the wires to be set
signalMatcher = {"solar", "light"}     -- and their respective arguments

function hash(str)
    local s = 0
    local p = ""
    
    for c in str:gmatch(".") do
        s = s + string.byte(c)
    end

    s = bit.bxor(k, s)

    while s > 0 do
        p = p .. string.char(s % 94 + 33)
        s = bit.brshift(s, 1)
    end
    
    return string.sub(p, 1, p:len() - 1)
end

function clear()
    term.clear()
    term.setCursorPos(1, 1)
end

function prompt()
    local suffix = "%"

    if user:match("root") then
        suffix = "#"
    end
    
    write(user .. " at " .. host .. " in /" .. shell.dir() .. " " .. suffix .. " ")
end

function login()
    local u = ""
    local p = ""
    local pos = -1
    
    write(host .. " Login: ")
    u = read();
    write("Password: ")
    p = read("");
    
    for i = 1,3 do
        if users[i] == u then
            pos = i
            break
        end
    end
    
    if pos ~= -1 then
        if pass[pos] == hash(p) then
            user = u
            write("Linux " .. host .. " 3.3.5 x86_64 " .. program .. " " .. version .. "\n\n")
        else
            write("Login incorrect\n\n")
            os.sleep(2)
            login()
        end
    else
        write("Login incorrect\n\n")
        os.sleep(2)
        login()
    end
end

function logout()
    clear()
    login()
end

function edit(path)
    shell.run("edit", path)
end

function ls()
    shell.run("ls")
end

function cd(path)
    shell.run("cd", path)
end

function start(arg)
    for i = 1,table.getn(signalMatcher) do
        if arg:match(signalMatcher[i]) then
            rs.setBundledOutput(outSide, rs.getBundledOutput(outSide) + signal[i])
            return
        end
    end
    
    if arg:match("all") then
        rs.setBundledOutput(outSide, signal[1] + signal[2])
        return
    end
    
    write("Usage: start [solar|light|all]\n")
end

function stop(arg)
    for i = 1,table.getn(signalMatcher) do
        if arg:match(signalMatcher[i]) then
             rs.setBundledOutput(outSide, rs.getBundledOutput(outSide) - signal[i] % 65535)
            return
        end
    end
        
    if arg:match("all") then
        rs.setBundledOutput(outSide, 0)
        return
    end
    
    write("Usage: stop [solar|light|all]\n")
end

function exec()
    local command = read()

    if command:match("logout") then
        logout()
    elseif command:match("clear") then
        clear()
    elseif command:match("start") then
        start(string.sub(command, 6))
    elseif command:match("stop") then
        stop(string.sub(command, 5))
    elseif command:match("edit") then
        edit(string.sub(command, 6))
    elseif command:match("ls") then
        ls()
    elseif command:match("cd") then
        cd(string.sub(command, 4))
    else
        write("zsh: command not found: " .. command .. "\n")
    end
end

function loop()
    prompt()
    exec()
    loop()
end

clear()
write(program .. " " .. version .. " " .. host .. " tty1\n\n")
login()
loop()
