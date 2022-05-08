local a = ass
local l = logger
local cname = "calc_branch"

a.registered_command[cname] = function(param, modes)

    local adress = a.adress[a.current_line]
    local line = a.source[a.current_line] or ""
    local param = line:sub(4,line:len()) or ""
    local cmd = line:sub(1,3) or ""
    
    if param:find(":") then
        param = param:match("[^%[%]%s]+")
        param = a.labels[a.lib.trim(param)]
        
    else
        param = param:gsub("%s","")
        local lo = param:sub(-2)
        local hi = param:sub(1,2)
        
        param = lo .. hi
        
    end
        
    local value = a.lib.hex2dec(param)
    adress = a.lib.hex2dec(adress)
    local diff = value - adress
    
    if(value < adress) then
        diff = (value-adress) + 254                                                      -- we need the value from 128 - 255
        if(diff < 128) then
            a.lib.write_error(08)
            diff = 128
            
        end -- if(diff
        
    else
        diff = (value - adress) - 2                                                      -- 1 Byte for the command, 1 Byte for the operand
        if(diff > 127) then
                a.lib.write_error(08)
                diff = 127
                
        end -- if(diff
        
    end -- if(value
    
    math.abs(diff)
    diff = a.lib.dec2hex(diff)
    a.mode[a.current_line] = modes["rel"]
    table.insert(a.code, modes["rel"] .. " " .. diff)
    
end
