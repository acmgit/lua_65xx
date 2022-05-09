local a = ass
local l = logger
local cname = "isc"
local mode = {
                ["imp"] = nil,
                ["imm"] = nil,
                ["zp"]  = "e7",
                ["zpx"] = "f7",
                ["zpy"] = nil,
                ["izx"] = "e3",
                ["izy"] = "f3",
                ["abs"] = "ef",
                ["abx"] = "ff",
                ["aby"] = "fb",
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
