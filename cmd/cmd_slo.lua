local a = ass
local l = logger
local cname = "slo"
local mode = {
                ["imp"] = nil,
                ["imm"] = nil,
                ["zp"]  = "07",
                ["zpx"] = "17",
                ["zpy"] = nil,
                ["izx"] = "03",
                ["izy"] = "13",
                ["abs"] = "0f",
                ["abx"] = "1f",
                ["aby"] = "1b",
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
