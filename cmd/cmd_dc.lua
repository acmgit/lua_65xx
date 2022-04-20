local a = ass
local l = logger
local cname = "dc"
local code

a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = pass_1(cmd)
    
    if(passes[a.pass]) then
        passes[a.pass](param)
    else
            l.log(cname .. ": unkown Pass: " .. a.pass)
    
    end
    
end

function pass_1(cmd)
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
    
    table.insert(a.code, line)
    
end

local function check_value(value)
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

        
