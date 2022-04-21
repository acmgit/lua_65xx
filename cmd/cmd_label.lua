local a = ass
local l = logger
local cname = "label"
local code

a.registered_command[cname] = function(param)
            
    local passes = {}
    passes[2] = a.lib.calc_label
    
    if(passes[a.pass]) then
        passes[a.pass](param)

    end
    
end

