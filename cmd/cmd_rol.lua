local a = ass
local l = logger
local cname = "rol"
local mode = {
                ["imp"] = "2a",
                ["imm"] = nil,
                ["zp"]  = "26",
                ["zpx"] = "36",
                ["zpy"] = nil,
                ["izx"] = nil,
                ["izy"] = nil,
                ["abs"] = "2e",
                ["abx"] = "3e",
                ["aby"] = nil,
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
