local a = ass
local l = logger
local cname = "lda"
local mode = {
                ["imp"] = nil,
                ["imm"] = "a9",
                ["zp"]  = "a5",
                ["zpx"] = "b5",
                ["zpy"] = nil,
                ["izx"] = "a1",
                ["izy"] = "b1",
                ["abs"] = "ad",
                ["abx"] = "bd",
                ["aby"] = "b9",
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



