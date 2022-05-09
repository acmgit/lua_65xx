local a = ass
local l = logger
local cname = "ora"
local mode = {
                ["imp"] = nil,
                ["imm"] = "09",
                ["zp"]  = "05",
                ["zpx"] = "15",
                ["zpy"] = nil,
                ["izx"] = "01",
                ["izy"] = "11",
                ["abs"] = "0d",
                ["abx"] = "1d",
                ["aby"] = "19",
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
        passes[a.pass](param, mode)                                                           -- Call the Function of the Pass

    end

end
