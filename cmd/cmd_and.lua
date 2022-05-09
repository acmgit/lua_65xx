local a = ass
local l = logger
local cname = "and"
local mode = {
                ["imp"] = nil,
                ["imm"] = "29",
                ["zp"]  = "25",
                ["zpx"] = "35",
                ["zpy"] = nil,
                ["izx"] = "21",
                ["izy"] = "31",
                ["abs"] = "2d",
                ["abx"] = "3d",
                ["aby"] = "39",
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
