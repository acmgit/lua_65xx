local a = ass
local l = logger
local cname = "sty"
local code

a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = a.registered_command["calc_parameter"]
    
    if(passes[a.pass]) then
        passes[a.pass](param)                                                            -- Call the Function of the Pass

    end
    
end
