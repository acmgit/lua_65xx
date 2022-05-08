local a = ass
local l = logger
local cname = "eor"
local mode = {
                ["imp"] = nil,
                ["imm"] = "49",
                ["zp"]  = "45",
                ["zpx"] = "55",
                ["zpy"] = nil,
                ["izx"] = "41",
                ["izy"] = "51",
                ["abs"] = "4d",
                ["abx"] = "5d",
                ["aby"] = "59",
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
