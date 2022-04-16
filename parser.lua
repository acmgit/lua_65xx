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
local split
local hex2dez
local lib = a.lib

function lib.parse()

    print("Assembling Pass " .. a.pass)
    
    for k,v in pairs(a.source) do
        a.current_line = a.current_line + 1
        local cmd = lib.split(v)        
        if(not cmd) then 
            table.insert(a.code, " ")
            
        else
            cmd[1] = cmd[1] or ""
            cmd[2] = cmd[2] or ""
            cmd[3] = cmd[3] or ""
            if(cmd[1] == "") then cmd[1] = nil end
            lib.check(cmd)                                                                   -- Ok, try to execute the line
            
                            
        end -- if(not cmd 
        
    end -- for k,v in

end -- function a.parse()



