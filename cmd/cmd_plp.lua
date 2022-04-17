local a = ass
local l = logger
local cname = "plp"
local code = "28"

a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = a.lib.pass_1_only_cmd(param)

    if(passes[a.pass]) then
        passes[a.pass](param)                                                            -- Call the Function of the Pass
        
    end
    
end

