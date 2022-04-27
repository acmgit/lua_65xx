local a = ass
local l = logger
local cname = "*"
local set_base

a.registered_command[cname] = function(param)

    local passes = {}
    
    passes[1] = set_base

    if(passes[a.pass]) then
        passes[a.pass](param)                                                            -- Call the Function of the Pass

    end

end

function set_base(param)
    
    if(a.set_base) then
        a.debug = false
        a.lib.write_error(4)
                
    else
        a.start = a.lib.convert_to_hex(param[3]) 
        l.log("base = " .. a.start)
        a.pc = a.start
        a.set_base = true
        
    end -- if(a.set_base

    table.insert(a.code, " ")
    
end -- local function
