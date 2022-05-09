local a = ass
local l = logger
local cname = "rla"
local mode = {
                ["imp"] = nil,
                ["imm"] = nil,
                ["zp"]  = "27",
                ["zpx"] = "37",
                ["zpy"] = nil,
                ["izx"] = "23",
                ["izy"] = "33",
                ["abs"] = "2f",
                ["abx"] = "3f",
                ["aby"] = "3b",
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
