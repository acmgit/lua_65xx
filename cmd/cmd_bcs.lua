local a = ass
local l = logger
local cname = "bcs"
local code = "b0"

local pass_1

a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = a.lib.pass_1(param)
    
    if(passes[a.pass]) then
        passes[a.pass](param)                                                            -- Call the Function of the Pass

    else
        l.log(cname .. " - unkown Pass: " .. a.pass)
    
    end
    
end
