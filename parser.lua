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

        if(not cmd) then 
            break                                                                        -- next Command
            
        else
            for k,v in pairs(cmd) do
                cmd[k] = v or nil
                line = line .. (v or "") .. " "
                
            end -- for k,v
                        
        end -- if(not cmd
        
        if(a.registered_command[cmd[1]]) then
            a.registered_command[cmd[1]](cmd)
            
        else
            if(cmd[1]) then
                print("Line " .. a.current_line .. ": " .. line .. " <" .. a.lib.error[2] .. ">")
                a.debug = false
            else
                a.code[#a.code + 1] = ""
                
            end
    
        end -- if(registered_command
        line = ""
        
    end -- for k,v in
    
    if(not a.debug) then
        print("Pass " .. a.pass .. " finished with Errors.")
        os.exit()
        
    else
        print(a.lib.error[0])
        print("Pass " .. a.pass .. " finished without Errors.")
        
    end
end -- function a.parse()
