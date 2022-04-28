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
        a.current_line = a.current_line + 1
    
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
                a.registered_command[helpcmd](cmd)                                -- Valid cmd found
            
            else
                if(cmd[1]:find(":")) then                                                -- Line is a Lable
                    a.registered_command["label"](cmd)
                    
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
    for k,v in ipairs(a.source) do
        a.current_line = a.current_line + 1    
                
        local cmd = lib.split(v)
        local helpcmd = cmd[1] or ""
        helpcmd = helpcmd:lower()
        helpcmd = lib.trim(helpcmd)
              
        if(a.registered_command[helpcmd]) then
            a.registered_command[helpcmd](cmd)                                -- Valid cmd found
        else
        
            a.registered_command["do_nothing"]()
        end -- if(a.registered

    end -- for k,v 

end

