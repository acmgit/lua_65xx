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
        --local line = ""
    
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
    a.current_line = 0
    lib.print_code()
    
end -- parse[1]

--[[    
lib.parse[2] = function()
    for k,v in pairs(a.source) do
        a.current_line = a.current_line + 1
        
        
        local cmd = lib.split(v)                                                         -- Split the command
        print(a.current_line .. ": " .. (cmd[1] or "") .. " " .. (cmd[2] or ""))
        
        if(not cmd) then                                                                 -- There is no Command
            break                                                                        -- next Command
            
        else                                                                             -- Ok, cmd is valid
            for b,e in pairs(cmd) do                                                     -- Clean Command and Parameters
                if(e:match("[%*/%+%-]")) then                                            -- check * / + - in v
                    if(e:len() > 1) then                                             -- Ok, It's not the star-command
                        if(e:sub(1,1)) == "#" then
                            e = "#" .. lib.dec2hex(lib.calc_formula(e:sub(2)))
                        else
                            e = lib.dec2hex(lib.calc_formula(e))
                            
                        end -- if(v:sub(
                        
                        cmd[b] = e
                        
                    end -- if(v:len
                        
                end -- if(v:match
                                
            end -- for k,v
                        
        end -- if(not cmd
        
        local helpcmd = cmd[1]
        if(helpcmd) then
            helpcmd = string.lower(helpcmd)
            
        end
        
        if(a.registered_command[helpcmd]) then
            a.registered_command[helpcmd](cmd)
            
        else
            
            if(cmd[1]) then
                if(cmd[1]:find(":")) then                                              -- Line is a Lable
                    a.code[#a.code + 1] = a.source[a.current_line]                     -- Insert it to the code
                    
                else
                    print("Line " .. a.current_line .. ": " .. line .. " <" .. a.lib.error[2] .. ">")
                    a.debug = false
                    
                end -- if(cmd[1]:find
                
            else
                a.code[#a.code + 1] = ""
                
            end
    
        end -- if(registered_command
        line = ""
        
    end -- for k,v in
    lib.print_code()
    
end -- function a.parse[1]

lib.parse[3] = function()
    a.current_line = 1
    a.code = {}
    line = ""
    cmd = {}
    
    for k,v in pairs(a.source) do                                                        -- The whole source
        a.current_line = a.current_line + 1
        cmd = lib.split(v)
        cmd[1] = cmd[1] or ""

        if(cmd[1]:find(":")) then
            a.registered_command["label"](cmd)
            
        else
            a.code[#a.code+1] = v
            
        end
    end -- for k,v
    
    lib.print_code()
    
end -- function lib.parse[2
]]--
