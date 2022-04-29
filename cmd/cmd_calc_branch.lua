local a = ass
local l = logger
local cname = "calc_branch"

a.registered_command[cname] = function()

    local value = a.lib.hex2dec(a.pc)
    a.adress[a.current_line] = a.pc
    value = value + 2
    value = a.lib.dec2hex(value)
    a.pc = value

end
