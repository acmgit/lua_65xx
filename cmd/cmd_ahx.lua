local a = ass
local l = logger
local cname = "ahx"
local mode = {
                ["imp"] = nil,
                ["imm"] = nil,
                ["zp"]  = nil,
                ["zpx"] = nil,
                ["zpy"] = nil,
                ["izx"] = nil,
                ["izy"] = "93",
                ["abs"] = nil,
                ["abx"] = nil,
                ["aby"] = "9f",
                ["ind"] = nil,
                ["rel"] = nil,
                }
                
a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = a.registered_command["calc_parameter"]
    passes[2] = a.registered_command["turn_value"]
    passes[4] = a.registered_command["do_nothing"]
    passes[5] = a.registered_command["calc_mode"]
        
    if(passes[a.pass]) then
        passes[a.pass](param, mode)                                                            -- Call the Function of the Pass
    end
    
end
