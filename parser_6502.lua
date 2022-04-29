--[[
  *******************************************************************
  **                                                               **
  **                       parser.lua                              **
  **                                                               **
  **                                                               **
  *******************************************************************
]]--


local a = ass
local l = logger
local lib = a.lib

-- Pass 1 only calculates all Values or Formulas to hex.
lib.parse[1] = function()
    for k,v in pairs(a.source) do
        a.current_line = k
        
        comment = string.find(v, ";")                                                    -- Remove the comment
        if(comment) then                                                                 -- Comment found
            v = string.sub(v,1,comment)                                                  -- Extract it from the Code.
            
        end -- if(comment
        
        local cmd = lib.split(v)
        local helpcmd = cmd[1] or ""
        helpcmd = helpcmd:lower()
        helpcmd = lib.trim(helpcmd)
        
        if(cmd[1] or nil) then
            
            if(a.registered_command[helpcmd]) then
                a.registered_command[helpcmd](cmd)                                       -- Valid cmd found
            
            else
                if(cmd[1]:find(":")) then                                                -- Line is a Lable
                    a.registered_command["label"](cmd[1])
                    
                else                                                                     -- no valid cmd found
                    lib.write_error(02)
                    table.insert(a.code, v)
                    
                end -- if(cmd[1
                
            end -- if(a.registered_command
            
        else -- if(cmd[1
            table.insert(a.code, " ")
            
        end
        
    end -- for k,v
    
end -- parse[1]

lib.parse[2] = function()
    for k,v in pairs(a.source) do
        a.current_line = k    
                
        local cmd = lib.split(v)
        local helpcmd = cmd[1] or ""
        helpcmd = helpcmd:lower()
        helpcmd = lib.trim(helpcmd)
              
        if(a.registered_command[helpcmd]) then
            a.registered_command[helpcmd](cmd)                                           -- Valid cmd found
        else
        
            a.registered_command["do_nothing"]()
        end -- if(a.registered

    end -- for k,v 

end

lib.parse[3] = function ()
    local branch = {}
    
    -- This are special commands, the adress is 2 byte, the command and operator is 2 bytes too
    branch = {
                ["bpl"] = "calc_branch",
                ["bmi"] = "calc_branch",
                ["bvc"] = "calc_branch",
                ["bvs"] = "calc_branch",
                ["bcc"] = "calc_branch",
                ["bcs"] = "calc_branch",
                ["bne"] = "calc_branch",
                ["beq"] = "calc_branch",
            }
    
    for k,v in pairs(a.source) do
        a.current_line = k
        local line = a.lib.trim(a.source[k])
        local cmd = a.lib.trim(line:sub(1,3))
        local par = a.lib.trim(line:sub(4, line:len()))
        local len = a.lib.round(par:len()/3)
        cmd = cmd:match("[^%s]+")
        
        if(a.registered_command[cmd]) then                                               -- a valid code needs 1 byte
            if(branch[cmd]) then                                                         -- all branch-codes nees only 2 byte
                len = 1
                
            end -- if(branch
            len = len + 1
            
        else
            if(cmd) then                                                                 -- was cmd valid but no command? so it's a label
                local label = a.lib.trim(line)
                a.labels[label] = a.pc
                len = 0
                line = " "
                
            end -- if(cmd
            
        end -- if(a.registered
            
        a.adress[k] = a.pc
        a.pc = a.lib.dec2hex(a.lib.hex2dec(a.pc) + len)
        table.insert(a.code, line)
                
    end -- for k,v
        
    a.last = (a.adress[a.pc] or "n/a")
    
end -- lib.parse[3]

lib.parse[4] = function ()
    local cmd = {}

    for k,v in pairs(a.source) do
        a.current_line = k
        
        local cmd = a.source[k]:sub(1,3)
        local line
        line = a.source[k]:sub(5, -1)
        local data = {}
        local pre = a.pre[k] or ""
        
        for x in line:gmatch("[^%[%]]+[%x]-") do
            table.insert(data,x)
        
        end
        
        line = ""
        for x, w in pairs(data) do
            local h = a.lib.trim(w)
            
            if(h:find(":", h:len(h)))then
                w = a.lib.trim(w)
                lab = a.labels[w]
                
                if(not lab) then
                    a.lib.write_error(07)
                    line = line .. w 
                    
                elseif(lab:len() > 2) then
                    if(pre:find("#",1,pre:len())) then
                        a.lib.write_error(03)
                        line = line .. w
                        
                    elseif(cmd == "dc ") then
                        a.lib.write_error(03)
                        line = line .. w
                        
                    else
                        line = line .. lab:sub(-2) .. " "
                        line = line .. lab:sub(1,2) .. " "
                    
                    end -- if(a.pre
                
                else
                    line = line .. lab
                    
                end -- if(not
                
            else
                    line = line .. w
                    
            end -- if(h:find
            
        end -- for x,
        
        table.insert(a.code, a.source[k]:sub(1,4) .. line)
        
    end -- for k,v
    
    for k,v in pairs(a.code) do
        a.current_line = k
        
        local line = a.code[k]
        local cmd = line:match("[%w]+")
        if(cmd) then
            a.registered_command[cmd]()
            
        end
        
    end
    
end -- lib.parse[4]
        
