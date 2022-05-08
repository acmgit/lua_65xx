-- lib.lua

local a = ass
local lib = a.lib
local l = logger

lib.command_is = {}
                    
lib.error = {
              [0] = "Ok. No Error found.",                                               -- 00
              "File not found.",                                                         -- 01
              "Unknown Command found.",                                                  -- 02
              "Range error: Only Byte allowed.",                                         -- 03
              "Base error, * is twice in the code.",                                     -- 04
              "Illegal Labeldefinition found.",                                          -- 05
              "Illegal value found.",                                                    -- 06
              "Unkown Label found.",                                                     -- 07
              "Branch out of Range.",                                                    -- 08
              "# without Value found.",                                                  -- 09
              "Illegal mode found.",                                                     -- 10
              "Can't open file.",                                                        -- 11
              
            }

function lib.write_error(number)
    print("Line " .. a.current_line .. ": (" .. number .. ") " .. lib.error[number])
    if(number > 0) then
        a.debug = false
        
    end
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
        for word in string.gmatch(parameter, "[%w#%$%%%*/%+%-%:%(%),%[%]{}%=%.2f%_<>]+") do
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
        
    if(not parameter:find(":")) then
        value = string.match(parameter, "[%x]+")
        base = string.match(parameter, "[%$%%]")
    else
        value = parameter
        base = ""
    
    end
    
    return base, value
    
end -- function get_value

function lib.hex2dec(number)
    return tonumber(number,16)

end

function lib.bin2dec(number)
    return tonumber(number,2)
    
end

function lib.dec2hex(number)
    if(not tonumber(number)) then
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
    
    if(first == "%") then
            second = lib.bin2hex(second)
            
    elseif(first ~= "$") then
            second = lib.dec2hex(first .. second)

    end -- if(first ==
    
    return second
    
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

function lib.calc_formula(formula)
local b = {}
    
    for part in string.gmatch(formula,"[^#][%x%%%$]*[%+%-%*/]*") do
        b[#b+1] = part:match("[%w%%%$]+")
        b[#b+1] = part:match("[%+%-%*/]")
    
    end
        
    for k,v in pairs(b) do                                                               -- Calculate the Parts 
        local digit

        digit = v:match("[%w%%%$]+")
        if(digit) then
            digit = "$" .. lib.convert_to_hex(digit)
            b[k] = lib.hex2dec(digit:sub(2))
            
        end -- if(digit
        
    end -- for k
    

    local form = ""        
    for k,v in pairs(b) do
        form = form .. v
        
    end
        
    form = form:match("[%w%*/%-%+]+")
    local result = lib.evalStr(form)
    if(result < 0) then                                                                  -- if result = negativ, result + 255 = result - $ff
        result = result + 255
        
    end
    
    return lib.round(result)
        
end -- lib.calc_formula

function lib.evalStr(str)
    local f= load ('return ('..str..')')
    return f()
    
end -- lib.eval

function lib.round(num) 
    if num >= 0 then return math.floor(num+.5) 
    else return math.ceil(num-.5) end
    
end -- lib.round

function lib.calc_adress(line)
    local value = a.lib.hex2dec(a.pc)
    a.adress[a.current_line] = a.pc
    value = value + (a.lib.round(line:len()/3))
    value = a.lib.dec2hex(value)
    a.pc = value
    
end

function lib.print_code(codebase)
    local index = ""
    
    for k,v in pairs(codebase) do
        index = a.adress[k]
        value = a.mode[k] or "n/a"
        
        if(index) then
            print(k .. ": $" .. index .. ": " .. v)
            
        else
            print(k .. ": " .. v)
            
        end -- if(index - Adresses available
        
    end -- for k,v in
    
end -- print_code

        
function lib.report()
    local cend = {}
    local value
        
    print("------<<<<<<[ Report ]>>>>>>------\n")
    print("Source             = " .. a.filename)
    print("Object             = " .. a.objectname)
    print("Code starts at     = $" .. a.start)

    value = lib.trim(a.code[#a.adress])
    for data in value:gmatch("[%x]+") do
        table.insert(cend, data)
        
    end
    
    value = lib.hex2dec(a.adress[#a.adress])
    value = value + #cend -1
    value = lib.dec2hex(value)
    
    print("Code ends at       = $" .. value)
    print("Number of Lines    = " .. #a.adress .. "\n")
    print("Labels are:")
    for k,v in pairs(a.labels) do
        print("--------------------------------------------------------------------------------------")
        print("\27[1A" .. k .."\27[80G" .. "$" .. v)
        
    end -- for k,v in

end -- function lib.report
    
