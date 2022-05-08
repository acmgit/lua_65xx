local a = ass
local l = logger
local cname = "cmp"
local mode = {
                ["imp"] = nil,
                ["imm"] = "c9",
                ["zp"]  = "c5",
                ["zpx"] = "d5",
                ["zpy"] = nil,
                ["izx"] = "c1",
                ["izy"] = "d1",
                ["abs"] = "cd",
                ["abx"] = "dd",
                ["aby"] = "d9",
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
