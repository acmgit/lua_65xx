local a = ass
local l = logger
local cname = "calc_mode"

    local mode = {
                ["#"] = "imm",
                ["#_len"] = 2, 
                ["#<"] = "imm",
                ["#<_len"] = 2,
                ["#>"] = "imm",
                ["#>_len"] = 2,
                ["()"] = "ind",
                ["()_len"] = 3,
            }   

a.registered_command[cname] = function(param, value, modes)

    if(a.pass == 5) then
        modes = value
        local line = a.source[a.current_line]
        value = line:sub(4,line:len())
        value = value:gsub("%s","")

    end

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
        mode["n/a_len"] = 2
        mode[",x"] = "zpx"
        mode[",x_len"] = 2
        mode[",y"] = "zpy"
        mode[",y_len"] = 2
        mode["(,x)"] = "izx"
        mode["(,x)_len"] = 2
        mode["(),x"] = "izx"
        mode["(),x_len"] = 2
        mode["(,y)"] = "izy"
        mode["(,y)_len"] = 2
        mode["(),y"] = "izy"
        mode["(),y_len"] = 2
    else
        mode["n/a"] = "abs"
        mode["n/a_len"] = 3
        mode[",x"] = "abx"
        mode[",x_len"] = 3
        mode[",y"] = "aby"
        mode[",y_len"] = 3 

    end -- if(val <=

    if(value and value:match("[%[{:]")) then                                             -- value is a text, label or formula
        if(modes["rel"]) then                                                            -- it's a branch with label
            a.mode[a.current_line] = "rel"
            a.cmd_len[a.current_line] = 2
            return
        else
            a.mode[a.current_line] = nil
            a.cmd_len[a.current_line] = mode[line .. "_len"]
            return

        end

    end -- if value:match


    if(not val and line == "#") then
        a.lib.write_error(09)
        return

    end
    
    if(val) then 
        if(modes[mode[line]]) then
            a.mode[a.current_line] = modes[mode[line]]
            a.cmd_len[a.current_line] = mode[line .. "_len"]

        elseif(not modes["rel"]) then
            a.lib.write_error(10)
        
        else                                                                             -- Mode is relativ
            if(line ~= "n/a") then                                                       -- and has other modes
                a.lib.write_error(10)

            end                                                                          -- Ok, branch-command has no other modes
            a.cmd_len[a.current_line] = 2                                                -- Branch-commands has a len of 2

        end -- if(mode[line

    elseif(modes["imp"]) then
        a.mode[a.current_line] = modes["imp"]
        a.cmd_len[a.current_line] = 1

    elseif(modes["rel"]) then
        a.mode[a.current_line] = modes["rel"]
        a.cmd_len[a.current_line] = 2

    else
        a.lib.write_error(10)

    end -- if(val

end -- function a.registered_command



