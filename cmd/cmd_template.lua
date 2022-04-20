local a = ass
local l = logger
local cname = "template"
local code

a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = pass_1(cmd)
    
    if(passes[a.pass]) then
        passes[a.pass](param)
    else
            l.log(cname .. ": unkown Pass: " .. a.pass)
    
    end
    
end

function pass_1(cmd)
    print(cname .. "- Pass 1")
    
end
