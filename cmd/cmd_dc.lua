local a = ass
local l = logger
local cname = "dc"
local code

a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = a.lib.calculate_dc
    
    if(passes[a.pass]) then
        passes[a.pass](param)
            
    end
    
end


        
