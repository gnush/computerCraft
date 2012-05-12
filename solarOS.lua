-- disable terminating via Ctrl + t
os.pullEvent = os.pullEventRaw

-- variables for the prompt
user = ""
host = "derp"
version = "0.1"

-- define users and their respective passwords
users = {"root", "herp", "narwhal"}
pass = {"" ,"derp", "bacon"}

-- variables for the redpower signals
signalTime = 2


function clear()
    term.clear()
    term.setCursorPos(1, 1)
end

function prompt()
    write(user .. " at " .. host .. " in " .. shell.dir() .. " ")
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
        end
    else
        write("Login incorrect\n\n")
        os.sleep(1)
        login()
    end

    clear()
    write("Linux " .. host .. " 3.3.5 x86_64\nsolarOS " .. version .. "\n")
    prompt()
end

clear()
write("solarOS " .. version .. " herp tty1\n\n")
login()
