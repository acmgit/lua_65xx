local a = ass
local l = logger
local cname = "sec"
local mode = {
                ["imp"] = "38",
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
                ["rel"] = nil,
                }

a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = a.registered_command["calc_parameter"]
    passes[2] = a.registered_command["do_nothing"]
    passes[4] = a.registered_command["do_nothing"]
    
    if(passes[a.pass]) then
        passes[a.pass](param, mode)                                                            -- Call the Function of the Pass

    end
    
end
