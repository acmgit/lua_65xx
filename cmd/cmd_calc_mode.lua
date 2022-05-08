local a = ass
local l = logger
local cname = "calc_mode"

    local mode = {
                ["#"] = "imm",
                ["#<"] = "imm",
                ["#>"] = "imm",
                ["()"] = "ind",
            }

a.registered_command[cname] = function(param, value, modes)

    if(a.pass == 5) then
        modes = value
        local line = a.source[a.current_line]
        value = line:sub(4,line:len())
        value = value:gsub("%s","")
        
    end
    
    if(value and value:match("[%[{:]")) then                                                        -- value is a text, label or formula 
        a.mode[a.current_line] = nil
        return
        
    end -- if value:match   
    
    local post = a.post[a.current_line]
    local pre = a.pre[a.current_line]
    local line
    
    if(post == "" and pre == "") then
        line = "n/a"
        
    else
        line = pre .. post
        line = line:match("[^%s]+")
        
    end
        
    local val
    if(value) then
        val = tonumber(a.lib.hex2dec(value))
        
    else
        val = nil
        
    end -- if(value
    
    if(val and val <= 255) then
        mode["n/a"] = "zp"
        mode[",x"] = "zpx"
        mode[",y"] = "zpy"
        mode["(,x)"] = "izx"
        mode["(),x"] = "izx"
        mode["(,y)"] = "izy"
        mode["(),y"] = "izy"
        
    else
        mode["n/a"] = "abs"
        mode[",x"] = "abx"
        mode[",y"] = "aby"
        
    end -- if(val <=
    
    if(not val and line == "#") then
        a.lib.write_error(09)
        return
        
    end
    
    if(val) then
        if(modes[mode[line]]) then
            a.mode[a.current_line] = modes[mode[line]]
            
        elseif(not modes["rel"]) then
            a.lib.write_error(10)
            
        end -- if(mode[line
        
    elseif(modes["imp"]) then
        a.mode[a.current_line] = modes["imp"]
    
    elseif(modes["rel"]) then
        a.mode[a.current_line] = modes["rel"]
        
    else
        a.lib.write_error(10)
            
    end -- if(val
            
end --
        
    

