local a = ass
local l = logger
local cname = "clv"
local code = "b8"


a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = a.lib.pass_1_only_cmd(param)

    if(passes[a.pass]) then
        passes[a.pass](param)                                                            -- Call the Function of the Pass

    else
        l.log(cname .. " - unkown Pass: " .. a.pass)
    
    end
    
end
