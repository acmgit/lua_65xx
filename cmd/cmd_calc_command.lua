local a = ass
local l = logger
local cname = "calc_command"
local imp, imm, zp, abs

a.registered_command[cname] = function(param, modes)

    local mode = (a.pre[a.current_line] or "") .. (a.post[a.current_line] or "")
    local cmd_mode = ""
    local cmd = param[1]:sub(1,3)
    local par 
--[[    
    for i=2,#param do
        param[2] = param[2] .. param[i] or ""
        
    end
]]--    
    par = param[2] or ""
    
    print(cmd .. " --- " .. par or "")
    
    if(not mode) then cmd_mode = ["imp"]
    elseif (mode.find(["zp"],1,mode:len())) then cmd_mode = cmd_mode .. ["zp"]
    elseif (mode.find(",x",1,mode:len())) then cmd_mode = cmd_mode .. "x"
    elseif (mode.find(",y",1,mode:len())) then cmd_mode = cmd_mode .. "y"
    elseif (mode.find(["abs"],1,mode:len())) then cmd_mode = cmd_mode .. ["abs"]
    elseif (mode.find("(",1,mode:len())) then cmd_mode = cmd_mode .. ["ind"]
    elseif (mode.find("#",1,mode:len())) then cmd_mode = cmd_mode ..["imm"]
    end
    
    print(a.current_line .. ": ------ " .. cmd_mode or "")
    
end

function onemode(value)
    if (value == nil) then return end

end

