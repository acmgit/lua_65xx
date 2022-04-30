local a = ass
local l = logger
local cname = "dey"
local code = "88"

a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = a.registered_command["calc_parameter"]
    passes[2] = a.registered_command["do_nothing"]
    passes[4] = a.registered_command["do_nothing"]

    if(passes[a.pass]) then
        passes[a.pass](param)                                                            -- Call the Function of the Pass

    end
    
end
