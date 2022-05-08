local a = ass
local l = logger
local cname = "sta"
local mode = {
                ["imp"] = nil,
                ["imm"] = nil,
                ["zp"]  = "85",
                ["zpx"] = "95",
                ["zpy"] = nil,
                ["izx"] = "81",
                ["izy"] = "91",
                ["abs"] = "8d",
                ["abx"] = "9d",
                ["aby"] = "99",
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
