local a = ass
local l = logger
local cname = "label"
local code

a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[2] = pass_2(cmd)
    
    if(passes[a.pass]) then
        passes[a.pass](param)
    else
            l.log(cname .. ": unkown Pass: " .. a.pass)
    
    end
    
end

function pass_2(cmd)
    l.log(cmd[1])
    a.labels[cmd[1]] = a.pc
    
end
