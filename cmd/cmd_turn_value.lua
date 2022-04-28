local a = ass
local l = logger
local cname = "turn_value"

a.registered_command[cname] = function(param)

    local line = a.source[a.current_line]
    local value
    local cmd = {}
    
    cmd = a.lib.split(line)
    
    value = line:match("[^%w]+[%x]+") or ""
    value = value:match("[^%s]+[%x]+")
    local len = value:len()
    
    if(len > 2) then
        local hi = value:sub(1,2)
        local lo = value:sub(-2)
        local pre = a.pre[a.current_line]
        local dec = a.lib.hex2dec(value)
                
        if(dec <= 255) then
            line = cmd[1] .. lo
            
        else
            if(not pre:find("#")) then
                line = cmd[1] .. " " .. lo .. " " .. hi
                
            else
                a.lib.write_error(03)
                line = a.source[a.current_line]
                
            end -- if(not pre
            
        end -- (dec
                
    else
        line = cmd[1] .. " " .. value
        
    end -- if(len > 2
    
    table.insert(a.code, line)
    
end
