local a = ass
local l = logger
local cname = "do_nothing"


a.registered_command[cname] = function(param)
            
    table.insert(a.code,a.source[a.current_line]) 
        
end
