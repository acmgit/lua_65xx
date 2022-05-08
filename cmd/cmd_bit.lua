local a = ass
local l = logger
local cname = "bit"
local mode = {
                ["imp"] = nil,
                ["imm"] = nil,
                ["zp"]  = "24",
                ["zpx"] = nil,
                ["zpy"] = nil,
                ["izx"] = nil,
                ["izy"] = nil,
                ["abs"] = "2c",
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
    passes[5] = a.registered_command["calc_mode"]

    if(passes[a.pass]) then
        passes[a.pass](param, mode)                                                            -- Call the Function of the Pass

    end
    
end
