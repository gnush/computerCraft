--[[
    Author: gnush
    This program will set a 2 bit redpower output.
]]--
-- disable terminating via Ctrl + t
os.pullEvent = os.pullEventRaw

-- variables for the prompt
program = "solarOS"
version = "0.1"
host = "derp"
user = ""

-- define users and their respective passwords
users = {"root", "herp", "narwhal"}
pass = {"toor" ,"derp", "bacon"}

-- variables for the redpower signals
signalTime = 2


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
    login()
end

function exec()
    local command = read()
    
    if command:match("logout") then
        logout()
    elseif command:match("clear") then
        clear()
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
