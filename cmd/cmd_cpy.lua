local a = ass
local l = logger
local cname = "cpy"
local code

a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = a.registered_command["calc_parameter"]
    passes[2] = a.registered_command["turn_value"]
    passes[4] = a.registered_command["do_nothing"]
    
        passes[a.pass](param)                                                            -- Call the Function of the Pass

end
    
