-- lib.lua

local a = ass
a.lib = {}
local lib = a.lib
local l = logger

lib.command_is = {}
                    
lib.error = {
              "Ok. No Error.",                  -- 00
              "File not found.",                -- 01
              "Synthax Error.",                 -- 02
            }

function lib.check(cmd)
    local line
    if((not cmd[1]) or (cmd[1] == "")) then
        --print(a.current_line .. ":")
        return
        
    else
        if(not cmd[3]) then
            if( not cmd[2]) then
                line = cmd[1]
                
            else
                line = cmd[1] .. " " .. cmd[2]
                
            end -- if(not cmd[2]
        
        else
            line = cmd[1] .. " " .. cmd[2] .. " " .. cmd[3]
        
       end -- if(not cmd[3]
       
    end -- if(not.registered_command
    
    if(a.registered_command[cmd[1]]) then
        a.registered_command[cmd[1]](cmd)
        --print(a.current_line .. ": " .. line)
    else
        print(a.current_line .. ": " .. line .. " <" .. a.lib.error[3] .. " >")
    
    end -- if(registered_command
    
end -- function lib.check

function lib.clear_flags()
    l.log("Clear Flags ...")
    for k,v in pairs(lib.command_is) do
        table.remove(lib.command_is, k)
        
    end -- for

end -- function clear_flags

function lib.split(parameter)
        local cmd = {}
        local comment
        
        if(parameter == nil) then return end
        
        comment = string.find(parameter, ";")
        if(comment) then                                                                -- Comment found
            parameter = string.sub(parameter,1,comment)
            
        end
        
        lib.trim(parameter)
        for word in string.gmatch(parameter, "[%w%-%:%%%(%)%,%*%#%$%=%.2f%_]+") do
            table.insert(cmd, word)
            
        end -- for word

        return cmd

end -- function lib.split

function lib.trim(parameter)
    if(parameter) then
        parameter:gsub("^%s*(.-)%s*$", "%1")                                              -- Trim
    end
    
    return parameter

end
 
function lib.get_value(parameter)
    local value
    local flag
    local base
    
    value = string.match(parameter, "[%x]+")
    base = string.match(parameter, "[%$%%]")
        
    return base, value
    
end -- function get_value

function lib.dez2hex(number)
    if(not number) then
        return 0
    
    else
        if (string.len(number) >= 4) then
            return string.format("%04x", number)
        
        else
            return string.format("%02x", number)
        
        end -- if(number < 256
        
    end -- if(not number

end -- function dez2hex

function lib.bin2hex(number)
   return lib.dez2hex(tonumber(number, 2))
   
end

function lib.convert_to_hex(cmd)
    local number = cmd
    local first = string.sub(number, 1,1)
    local second = string.sub(number, 2) 
    local value = nil
    
    if(first == "%") then
            second = lib.bin2hex(second)
            
    elseif(first ~= "$") then
            second = lib.dez2hex(first .. second)

    end -- if(first ==
    
    return "$" .. second
    
end -- check_base

function lib.write_error(number)
    number = number + 1
    print(ass.error[number])
    l.log(ass.error[number])
    
end -- function a.write_error

function lib.check_flags(cmd)
    
    lib.check_immediate(cmd)
    lib.check_absolut(cmd)
    lib.check_indirect(cmd)
    
end

-- check the source for a # and convert the value behind
function lib.check_immediate(text)
    local check = string.match(text, "#")

    if(check) then
        table.insert(lib.command_is, "imm")
    
    end -- if(pos)
    
end -- function lib.check_immediate

function lib.check_absolut(text)
    local check = string.match(text,"[#%(]")
    if(not check) then
    
        check = string.match(text, "[,x]")
        if(check) then
            table.insert(lib.command_is, "abx")
        
        else
            check = string.match(text, "[,y]")
            if(check) then
                table.insert(lib.command_is,"aby")
                
            else
                table.insert(lib.command_is, "abs")
                
            end -- if(check
            
        end -- if(check
            
    end-- if(string.sub
        
end -- function check_absolut
    

function lib.check_indirect(text)
    local pos = string.match(text, "[%(]")
    
    if(pos) then
        table.insert(lib.command_is, "ind")
    
    end-- if(string.sub
    
end -- function check_indirect
    
function lib.pass_1_only_cmd(cmd)
    table.insert(a.code, cmd[1])
    
end

function lib.pass_1(cmd)
    a.lib.check_flags(cmd[2])
    
    local flags = ""
    local base, value = a.lib.get_value(cmd[2])
    
    for k,v in pairs(a.lib.command_is) do
            flags = flags .. (v or "") .. " "
    
    end
    
    flags = a.lib.trim(flags) or ""
    a.lib.clear_flags()
    
    if(base == "%") then
        value = a.lib.bin2hex(value)
        
    elseif(not base) then
        value = a.lib.dez2hex(value)
        
    end -- if(base
    
    line = cmd[1] .. " " .. value .. " |" .. flags
    table.insert(a.code, line)
    
end -- function pass_1

