-- lib.lua

local a = ass
local lib = a.lib
local l = logger

lib.command_is = {}
                    
lib.error = {
              [0] = "Ok. No Error found.",                                               -- 00
              "File not found.",                                                         -- 01
              "Unknown Command found.",                                                  -- 02
              "Range Error: Only Byte allowed.",                                         -- 03
              "Base error, * is twice in the code."                                      -- 04 
              
            }

function lib.write_error(number)

    print(number .. ": " .. lib.error[number])
    --l.log(lib.error[number])
    
end -- function a.write_error

function lib.clear_flags()
    for k,v in pairs(lib.command_is) do
        table.remove(lib.command_is, k)
        
    end -- for

end -- function clear_flags

function lib.split(parameter)
        local cmd = {}
        local comment
        
        if(parameter == nil) then return end
                
        lib.trim(parameter)
        for word in string.gmatch(parameter, "[%w%-%:%%%(%)%,%*%#%$%=%.2f%_]+") do
            word = word or nil
            lib.trim(word)
            table.insert(cmd, word)
            
        end -- if(not cmd
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
    local base
    
    if(parameter:match("[%+%-%*/]")) then
        l.log("Is Formula")
        
    end
    
    if(not parameter:find(":")) then
        value = string.match(parameter, "[%x]+")
        base = string.match(parameter, "[%$%%]")
    else
        value = parameter
        base = ""
    
    end
    
    return base, value
    
end -- function get_value

function lib.dec2hex(number)
    if(not number) then
        return 0
    
    else
        if (string.len(number) >= 4) then
            return string.format("%04x", number)
        
        else
            return string.format("%02x", number)
        
        end -- if(number < 256
        
    end -- if(not number

end -- function dec2hex

function lib.bin2hex(number)
   return lib.dec2hex(tonumber(number, 2))
   
end

function lib.convert_to_hex(cmd)
    local number = cmd
    local first = string.sub(number, 1,1)
    local second = string.sub(number, 2) 
    local value = nil
    
    if(first == "%") then
            second = lib.bin2hex(second)
            
    elseif(first ~= "$") then
            second = lib.dec2hex(first .. second)

    end -- if(first ==
    
    return "$" .. second
    
end -- check_base

function lib.check_flags(cmd)
    local flag = ""
    
    flag = lib.check_absolut(cmd)
    flag = flag .. lib.check_idx(cmd)
    flag = flag .. lib.check_immediate(cmd)
    flag = flag .. lib.check_indirect(cmd)
    flag = flag .. lib.check_zero(cmd)

    table.insert(lib.command_is, flag)
    
end

function lib.check_zero(text)
    local check = string.match(text, "[%w]+")
    if(string.len(check) == 2) then        
        return " zro"
    
    end
    
    return ""
   
end
-- check the source for a # and convert the value behind
function lib.check_immediate(text)
    local check = string.find(text, "#",1)
    if(check) then
        return " imm"
    
    end -- if(pos)
    
    return ""
    
end -- function lib.check_immediate

function lib.check_absolut(text)
    local check = (string.find(text,"#",1) or string.find(text, "%("))
            
    if(not check) then
        return " abs"
    
    end
    
    return ""
    
end -- function check_absolut
    

function lib.check_indirect(text)
    local pos = string.find(text, "%(", 1)
    if(pos) then
        return " ind"
    
    end -- if(string.sub
    
    return ""
    
end -- function check_indirect

function lib.check_idx(text)
    local check = string.find(text, ",x", 1)
    
    if(check) then
        return " idx"
        
    else
        check = string.find(text, ",y", 1)
        if(check) then
            return " idy"
        
        end -- if(check
        
    end -- if(check
    
    return ""
    
end

function evalStr(str)
    local f= load ('return ('..str..')')
    return f()
    
end

function lib.print_code()
    for k,v in pairs(a.code) do
        print(v)
        
    end
    
end

function lib.print_source()
    for k,v in pairs(a.source) do
        print(v)
        
    end
    
end

function lib.pass_1_only_cmd(cmd)
    table.insert(a.code, cmd[1])
    
end

function lib.prepare_cmd(cmd)
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
        value = a.lib.dec2hex(value)
        
    end -- if(base
    
    line = cmd[1] .. " " .. value .. " |" .. flags
    table.insert(a.code, line)
    
end -- function prepare_command

function lib.calc_label(cmd)
    local line = a.source[a.current_line-1]
    local value    
    if(line:find("=")) then                                                              -- Label is a Deklaration
        lval = line:match("[%$%%%dabcdef]+")
        if (lval:sub(1,1) == "$") then                                                   -- is value hex
                lval = lval:match("[^%$][%x]+")
                
        elseif (lval:sub(1,1) == "%") then                                                -- is value binary
                lval = lval:match("[^%%][%w]+")
                lval = a.lib.bin2hex(lval)
                
        else
                lval = lval:match("%w")                                                   -- value is decimal
                lval = a.lib.dec2hex(lval)
                
        end
        
        a.labels[cmd[1]] = "$" .. lval
        
    else
        a.labels[cmd[1]] = a.pc
        
    end
    a.code[#a.code+1] = " "
    
end

function lib.calculate_dc(cmd)
    local data = {}
    local helpstring = ""
    local line = ""
    
    helpstring = a.lib.trim(a.source[a.current_line])
    helpstring = helpstring:sub(helpstring:find("dc")+3, helpstring:len())
    
    for word in string.gmatch(helpstring, "[^,]+[%w%$%%:]+") do
        data[#data+1] = a.lib.trim(word)
        
    end
    
    for k,v in pairs(data) do
        local x = ""
        if(v:find(":")) then                                                             -- is it a label?
            x = v
            
        elseif(v:find("%$")) then                                                        -- is it hex?
            x = v:match("[^$]+[%x]+")
            
        elseif (v:find("%%")) then                                                       -- is it binary
            x = a.lib.bin2hex(v:match("[^%%]+[%w]+"))
            
        elseif (tonumber(x)) then                                                        -- is it dec
            x = a.lib.dec2hex(v)
            
        else                                                                             -- no, it's a string
            for b=1, v:len() do
                x = x .. a.lib.dec2hex(v:byte(b,b)) .. " "
            
            end
            
        end

        line = line .. x .. " "
    end
    
    table.insert(a.code, "dc " .. line)
end

function lib.check_dc_value(value)
    if(value:find(":")) then                                                             -- is it a label?
        return value
        
    elseif (value:find("$")) then                                                        -- is it hex?
        return value:match("[^$]+[%x]+")

    elseif (value:find("%")) then
        return a.lib.bin2hex(value:match("[^%%]+[%w]+"))
        
    elseif (tonumber(value)) then
        return a.lib.dec2hex(tonumber(value))
        
    else
        return value
        
    end

end

function lib.check_declaration(cmd)
    local line 
    line = a.source[a.current_line]
    
    if(line:find("=")) then
        print(line:match("[%$%%]"))
    end
end

