local a = ass
local l = logger
local cname = "*"

a.registered_command[cname] = function(param)
            if(a.set_base) then
                a.debug = false
                a.lib.write_error(4)
                
            else
                a.start = a.lib.convert_to_hex(param[3]) 
                l.log("base = " .. a.start)
                table.insert(a.code, "base = " .. a.start)
                a.pc = a.start
                a.set_base = true
                return
                
            end
end

