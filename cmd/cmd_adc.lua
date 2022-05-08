local a = ass
local l = logger
local cname = "adc"
local mode = {
                ["imp"] = nil,
                ["imm"] = "69",
                ["zp"]  = "65",
                ["zpx"] = "75",
                ["zpy"] = nil,
                ["izx"] = "61",
                ["izy"] = "71",
                ["abs"] = "6d",
                ["abx"] = "7d",
                ["aby"] = "79",
                ["ind"] = nil,
                ["rel"] = nil,
                }
                
a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = a.registered_command["calc_parameter"]
    passes[2] = a.registered_command["turn_value"]
    passes[4] = a.registered_command["do_nothing"]
    
        
    if(passes[a.pass]) then
        passes[a.pass](param, mode)                                                            -- Call the Function of the Pass
    end
    
end
