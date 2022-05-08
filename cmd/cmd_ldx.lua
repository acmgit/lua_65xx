local a = ass
local l = logger
local cname = "ldx"
local mode = {
                ["imp"] = nil,
                ["imm"] = "a2",
                ["zp"]  = "a6",
                ["zpx"] = nil,
                ["zpy"] = "b6",
                ["izx"] = nil,
                ["izy"] = nil,
                ["abs"] = "ae",
                ["abx"] = nil,
                ["aby"] = "be",
                ["ind"] = nil,
                ["rel"] = nil,
                }

a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = a.registered_command["calc_parameter"]
    passes[2] = a.registered_command["turn_value"]
    passes[4] = a.registered_command["do_nothing"]
    
    if(passes[a.pass]) then
        passes[a.pass](param, mode)                                                           -- Call the Function of the Pass

    end
    
end
