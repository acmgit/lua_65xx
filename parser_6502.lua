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
local line

lib.parse[1] = function()
    for k,v in pairs(a.source) do
        a.current_line = a.current_line + 1
        
        comment = string.find(v, ";")
        if(comment) then                                                                -- Comment found
            v = string.sub(v,1,comment)                                                 -- Extract it from the Code.
            
        end
        
        local cmd = lib.split(v)                                                         -- Split the command
        print(a.current_line .. ": " .. (cmd[1] or "") .. " " .. (cmd[2] or ""))
        
        if(not cmd) then                                                                 -- There is no Command
            break                                                                        -- next Command
            
        else                                                                             -- Ok, cmd is valid
            for k,v in pairs(cmd) do                                                     -- Clean Command and Parameters
                if(v:match("[%*/%+%-]")) then                                            -- check * / + - in v
                        if(v:len() > 1) then                                             -- Ok, It's not the star-command
                            v = lib.calc_formula(v)
                        
                        end
                        
                end
                
                line = line .. (v or "") .. " "
                
            end -- for k,v
                        
        end -- if(not cmd
               
        local helpcmd = cmd[1]
        if(helpcmd) then
            string.lower(helpcmd)
            
        end
        
        if(a.registered_command[helpcmd]) then
            string.lower(cmd[1])
            a.registered_command[cmd[1]](cmd)
            
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

lib.parse[2] = function()
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
    
    print("Labels are:")
    
    for k,v in pairs(a.labels) do
        print(k .. "\t.......... \t\t" .. v)
    
    end -- for k,v in pairs(labels
    
    lib.print_code()
    
end -- function lib.parse[2
