local a = ass
local l = logger
local cname = "*"

a.registered_command[cname] = function(param)
            a.start = a.lib.convert_to_hex(param[3]) 
            l.log("base = " .. a.start)
            table.insert(a.code, "base = " .. a.start)
            a.pc = a.start
            a.lib.print_line("*", " = ", a.start)
end

