local a = ass
local l = logger
local cname = "dec"
local mode = {
                ["imp"] = nil,
                ["imm"] = nil,
                ["zp"]  = "c6",
                ["zpx"] = "d6",
                ["zpy"] = nil,
                ["izx"] = nil,
                ["izy"] = nil,
                ["abs"] = "ce",
                ["abx"] = "de",
                ["aby"] = nil,
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
