--[[
  *******************************************************************
  **                                                               **
  **                         Log.lua                               **
  **                                                               **
  **                 (?) 2022 by A.C.M. on                         **
  **                Deadsoft Development Corp.                     **
  **                                                               **
  *******************************************************************
]]--

logger = {}

local l = logger

l.file = nil
l.filename = ""
l.ok = false

function l.open()
    if(l.filename == "") then
        print("Error, no Logfilename given.")
        return false
        
    end -- if(log.filename
    
    l.file = io.open(l.filename, "w")
    if(not l.file) then
        print("Can not open Logfile: " .. l.filename .. ".")
        return false
        
    end -- if(not log.file
    
    l.ok = true
    
end -- function log.open

function l.log(Message)
    if(l.ok) then
       l.file:write(os.date() .. ": " .. Message .. "\n")
       
    end -- if(l.ok)
    
end -- function log.write(Messge

function l.close()
    if(l.ok) then
        l.file:close()
        l.file = nil
        l.ok = false
    end
    
end -- function log.close()
