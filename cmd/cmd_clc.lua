local a = ass
local l = logger
local cname = "clc"
local code = "18"

a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = a.lib.pass_1_only_cmd

    if(passes[a.pass]) then
        passes[a.pass](param)                                                            -- Call the Function of the Pass

    end
    
end
