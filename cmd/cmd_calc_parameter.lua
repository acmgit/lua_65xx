local a = ass
local l = logger
local cname = "calc_parameter"
local code

a.registered_command[cname] = function(param)
    local parameter = nil
    local line = param[1] .. " "
    
    for k = 2, #param do
        parameter = param[k]
        
    end
    
    if(not parameter) then                                                               -- Code has no Parameter
        table.insert(a.code, line)
        return
        
    elseif(parameter:sub(1,1) == "#") then                                                -- Paramter starts with #
        line = line .. "#"
        parameter = parameter:sub(2,parameter:len())                                       -- new Parameter w/o #
        
    end
    
    if(parameter:match("[%*/%+%-]")) then                                                 -- Parameter is a Formula
        parameter = "$" .. a.lib.dec2hex(a.lib.calc_formula(parameter))
    
    else 
        parameter = a.lib.convert_to_hex(parameter)
    
    end
    
    table.insert(a.code, line .. parameter)
    
end
