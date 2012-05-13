--[[
    Author: gnush
    This program will set a output signal up to 6 bit using the start/stop command.
]]--
-- disable terminating via Ctrl + t
os.pullEvent = os.pullEventRaw

-- variables for the prompt
program = "solarOS"
version = "0.3.1"
host = "derp"
user = ""

-- define users and their respective passwords
users = {"root", "herp", "narwhal"}
pass = {"toor" ,"derp", "bacon"}

-- variables for controlling the output
outSide = "top"             -- possible values are: top, back, left, right, bottom

function clear()
    term.clear()
    term.setCursorPos(1, 1)
end

function prompt()
    local suffix = "%"

    if user:match("root") then
        suffix = "#"
    else
        suffix = "%"
    end
    
    write(user .. " at " .. host .. " in ~ " .. suffix .. " ")
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
        if pass[pos]:match(p) then
            user = u
            write("Linux " .. host .. " 3.3.5 x86_64\ " .. program .. " " .. version .. "\n\n")
        end
    else
        write("Login incorrect\n\n")
        os.sleep(1)
        login()
    end
end

function logout()
    clear()
    login()
end

function edit(arg)
    local path = string.sub(arg, 6)
    
    shell.run("edit", path)
end

function start(arg)
    if arg:match("start panel") then
            rs.setBundledOutput(outSide, colors.green)
        elseif arg:match("start array") then
            rs.setBundledOutput(outSide, colors.blue)
        elseif arg:match("start all") then
            rs.setBundledOutput(outSide, colors.blue + colors.green)
        else
            write("Usage: start [panel|array|all]\n")
    end
end

function stop(arg)
    rs.setBundledOutput(outSide, 0)
end

function exec()
    local command = read()
    
    if command:match("logout") then
        logout()
    elseif command:match("clear") then
        clear()
    elseif command:match("start") then
        start(command)
    elseif command:match("stop") then
        stop()
    elseif command:match("edit") then
        edit(command)
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
