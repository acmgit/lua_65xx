local a = ass
local l = logger
local cname = "dey"
local code = "88"

local pass_1

a.registered_command[cname] = function(param)
            
    local passes = {}
    
    passes[1] = pass_1(cname)

    if(passes[a.pass]) then
        passes[a.pass](param)                                                            -- Call the Function of the Pass

    else
        l.log(cname .. " - unkown Pass: " .. a.pass)
    
    end
    
end

function pass_1()
    print(a.current_line .. ": " .. cname)

end
