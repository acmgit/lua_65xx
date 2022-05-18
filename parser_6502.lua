--[[
  *******************************************************************
  **                                                               **
  **                       parser.lua                              **
  **                                                               **
  **                                                               **
  *******************************************************************
]]--


local a = ass
local l = logger
local lib = a.lib

-- Calculates all Values or Formulas to hex.
lib.parse[1] = function()
    for k,v in pairs(a.source) do
        a.current_line = k

        comment = string.find(v, ";")                                                    -- Remove the comment
        if(comment) then                                                                 -- Comment found
            v = string.sub(v,1,comment-1)                                                -- Extract it from the Code.

        end -- if(comment

        local cmd = lib.split(v)
        local helpcmd = cmd[1] or ""
        helpcmd = helpcmd:lower()
        helpcmd = lib.trim(helpcmd)

        if(cmd[1] or nil) then

            if(a.registered_command[helpcmd]) then
                a.registered_command[helpcmd](cmd)                                       -- Valid cmd found

            else
                if(cmd[1]:find(":")) then                                                -- Line is a Lable
                    a.registered_command["label"](cmd[1])

                else                                                                     -- no valid cmd found
                    lib.write_error(02)
                    table.insert(a.code, v)

                end -- if(cmd[1

            end -- if(a.registered_command

        else -- if(cmd[1
            table.insert(a.code, " ")

        end

    end -- for k,v

end -- parse[1]

-- Turns the words in lo & hi
lib.parse[2] = function()
    for k,v in pairs(a.source) do
        a.current_line = k

        local cmd = lib.split(v)
        local helpcmd = cmd[1] or ""
        helpcmd = helpcmd:lower()
        helpcmd = lib.trim(helpcmd)

        if(a.registered_command[helpcmd]) then
            a.registered_command[helpcmd](cmd)                                           -- Valid cmd found
        else

            a.registered_command["do_nothing"]()
        end -- if(a.registered

    end -- for k,v

end

-- Calculates the Adress per line
lib.parse[3] = function ()
    local branch = {}

    -- This are special commands, the adress is 2 byte, the command and operator is 2 bytes too
    branch = {
                ["bpl"] = "calc_branch",
                ["bmi"] = "calc_branch",
                ["bvc"] = "calc_branch",
                ["bvs"] = "calc_branch",
                ["bcc"] = "calc_branch",
                ["bcs"] = "calc_branch",
                ["bne"] = "calc_branch",
                ["beq"] = "calc_branch",
            }

    for k,v in pairs(a.source) do
        a.current_line = k
        local line = a.lib.trim(a.source[k])
        local cmd = line:sub(1,3)
        local par = a.lib.trim(line:sub(4, line:len()))
        local len = 0
        cmd = cmd:match("[^%s]+")

        local data = {}                                                                  -- count the operators
        for value in  par:gmatch("[%x]+") do
            table.insert(data, value)

        end -- for value

        len = len + #data or 0

        -- calculates the regulary commands
        if(a.registered_command[cmd]) then                                               -- a valid code needs 1 byte
            if(branch[cmd]) then                                                         -- all branch-codes need only 2 byte
                len = 1

            end -- if(branch
            len = len + 1

        else
            -- calculates Labels
            if(cmd) then                                                                 -- was cmd valid but no command? so it's a label
                local label = a.lib.trim(line)
                a.labels[label] = a.pc
                len = 0
                line = " "

            end -- if(cmd

        end -- if(a.registered

        if(cmd == "dc") then                                                             -- dc is not a cpu-command
            len = len - 1

        end

        a.adress[a.current_line] = a.pc
        a.pc = a.lib.dec2hex(a.lib.hex2dec(a.pc) + len)
        table.insert(a.code, line)
    end -- for k,v

    a.last = (a.pc or "n/a")

end -- lib.parse[3]

-- Calculates the Branches
lib.parse[4] = function ()
    local cmd = {}

    for k,v in pairs(a.source) do
        a.current_line = k

        local cmd = a.source[k]:sub(1,3)
        local line
        line = a.source[k]:sub(5, -1)
        local data = {}
        local pre = a.pre[k] or ""

        for x in line:gmatch("[^%[%]]+[%x]-") do
            table.insert(data,x)

        end

        line = ""
        for x, w in pairs(data) do
            local h = a.lib.trim(w)

            if(h:find(":", h:len(h)))then
                w = a.lib.trim(w)
                lab = a.labels[w]

                if(not lab) then
                    a.lib.write_error(07)
                    line = line .. w

                elseif(lab:len() > 2) then
                    if(pre:match("[#]") or cmd == "dc") then
                        local hilo = pre:match("[<>]") or nil
                        if(hilo == "<") then
                                line = line .. lab:sub(-2)

                        elseif(hilo == ">") then
                                line = line .. lab:sub(1,2)

                        else
                            a.lib.write_error(03)
                            line = line .. w

                        end -- if(hilo

                    else
                        line = line .. lab:sub(-2) .. " "
                        line = line .. lab:sub(1,2) .. " "

                    end -- if(a.pre

                else
                    line = line .. lab

                end -- if(not

            else
                    line = line .. w

            end -- if(h:find

        end -- for x,

        table.insert(a.code, a.source[k]:sub(1,4) .. line)

    end -- for k,v

    -- Calculates the Branches
    a.source = {}
    a.source = a.code
    a.code = {}

    for k,v in pairs(a.source) do
        a.current_line = k

        local line = a.source[k]
        local cmd = line:match("[%w]+")

        if(cmd) then
            a.registered_command[cmd]()

        else
            table.insert(a.code, a.source[k])

        end -- if(cmd

    end -- for k,v

end -- lib.parse[4]

-- Postcalculate and turns unsolved Commands in digits
lib.parse[5] = function ()

    for k,v in pairs(a.source) do                                                        -- Postcalc the line, for example unsolved labels
        a.current_line = k
        if(not a.mode[k] and v ~= " ") then
            cmd = v:match("[%w]+")
            if(cmd:len() == 3) then
                a.registered_command[cmd](cmd)

            end -- if(cmd:len()

        end -- if(not a.mode

    end -- for k,v

    for k,v in pairs(a.source) do                                                        -- Remove the empty lines
        a.current_line = k
        if(v ~= " ") then
            local cmd = v:sub(1,3)
            local line

            if(cmd) then
                if(a.mode[k]) then
                    line = a.mode[k] .. " " .. v:gsub(cmd, "")                           -- cmd is a valid token
                    table.insert(a.code,line)

                else
                    line = v:gsub(cmd, "")
                    table.insert(a.code, line)                                          -- cmd was a datastore-command

                end

            end

        else
            a.source[k] = nil
            a.adress[k] = nil
            a.mode[k] = nil
            a.pre[k] = nil
            a.post[k] = nil

        end -- if(not v ==

    end -- for k,v
    local code = {}

    for i=1,#a.code do
        table.insert(code, a.code[i])

    end

    a.code = {}
    a.code = code

    code = {}
    for i=1,#a.adress do
        table.insert(code, a.adress[i])

    end
    a.adress = {}
    a.adress = code

    a.source = {}

    local file = io.open(a.objectname, "wb")

    if(not file) then
        lib.write_error(11)
        os.exit()

    end

    local hi, lo
    hi = a.lib.hex2dec(a.start:sub(1,2))
    lo = a.lib.hex2dec(a.start:sub(-2))

    file:write(string.char(lo))                                                          -- Start of
    file:write(string.char(hi))                                                          -- the Programm


    for k,v in pairs(a.code) do
        for data in v:gmatch("[%x]+") do
            data = lib.hex2dec(data)
            file:write(string.char(data))
        end


    end

    file:close()

end
