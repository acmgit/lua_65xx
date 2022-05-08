local a = ass
local l = logger
local cname = "bcs"
local mode = {
                ["imp"] = nil,
                ["imm"] = nil,
                ["zp"]  = nil,
                ["zpx"] = nil,
                ["zpy"] = nil,
                ["izx"] = nil,
                ["izy"] = nil,
                ["abs"] = nil,
                ["abx"] = nil,
                ["aby"] = nil,
                ["ind"] = nil,
                ["rel"] = "b0",
                }

a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = a.registered_command["calc_parameter"]
    passes[2] = a.registered_command["turn_value"]
    passes[4] = a.registered_command["calc_branch"]
    passes[5] = a.registered_command["calc_mode"]

    if(passes[a.pass]) then
        passes[a.pass](param, mode)                                                            -- Call the Function of the Pass

    end
    
end
