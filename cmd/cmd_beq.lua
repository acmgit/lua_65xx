local a = ass
local l = logger
local cname = "beq"
local code = "f0"

local pass_1

a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = a.lib.prepare_cmd

    if(passes[a.pass]) then
        passes[a.pass](param)                                                            -- Call the Function of the Pass

    end
    
end
