local a = ass
local l = logger
local cname = "brk"
local code = "00"


a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = a.registered_command["calc_parameter"](param)
    passes[2] = a.lib.pass_1_only_cmd

    if(passes[a.pass]) then
        passes[a.pass](param)                                                            -- Call the Function of the Pass

    end
    
end
