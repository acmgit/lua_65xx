local a = ass
local l = logger
local cname = "sbc"
local mode = {
                ["imp"] = nil,
                ["imm"] = "e9",
                ["zp"]  = "e5",
                ["zpx"] = "f5",
                ["zpy"] = nil,
                ["izx"] = "e1",
                ["izy"] = "f1",
                ["abs"] = "ed",
                ["abx"] = "fd",
                ["aby"] = "f9",
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
