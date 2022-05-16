local a = ass
local l = logger
local cname = "calc_parameter"
local is_dec
local is_formula
local is_binary
local is_hex
local is_label
local is_hilo

local cmd = {}
local base = {}

base = {
        ["$"] = function(value) return value:sub(2,value:len()) end,                     -- Hex
        ["%"] = function(value) return a.lib.is_binary(value:sub(2,value:len())) end,   -- Bin 
        [" "] = function(value) return a.lib.is_dec(value:sub(1,value:len())) end,      -- Dec
        ["<"] = function(value) if(base[value:sub(2,2)]) then                             -- Lo-Value
                                    value, _ = base[value:sub(2,value:len())](value)
                                    return value
                                else
                                    return nil
                                end
                end,
        [">"] = function(value) if(base[value:sub(2,2)]) then                             -- Hi-Value
                                    _, value = base[value:sub(2,value:len())](value)
                                    return value
                                else
                                    return nil
                                end
                end,
    }

a.registered_command[cname] = function(param, modes)
    local parameter = ""
    local line = param[1] .. " "
    local pre_line = ""                                                                       -- Hold the signs BEFORE the number
    local post_line = ""                                                                      -- Hold the signs AFTER the number
    local value = nil

    cmd["{"] = is_formula
    cmd["["] = is_label
    cmd["%"] = is_binary
    cmd["$"] = is_hex
    cmd["<"] = is_hilo
    cmd[">"] = is_hilo

    for k = 2, #param do
        if(k) then
            parameter = parameter .. param[k]

        end

    end

    pre_line = (parameter:match("[%(#<>]+") or "")
    post_line = (parameter:match("[%),xy]+") or "")
    value = (parameter:match("[%w%[%]%{%}%*/%+%-%s%%%$_:]+") or "")

    a.pre[a.current_line] = pre_line
    a.post[a.current_line] = post_line

    if(not value:sub(1,1) or (value:sub(1,1) == "")) then

        if(line) then
            table.insert(a.code, line)
            a.registered_command["calc_mode"](a.lib.trim(line), nil, modes)
        else
            table.insert(a.code, " ")

        end
        return

    end -- if(not value

    if(cmd[value:sub(1,1)]) then                                                         -- Solve the Value
        value = cmd[value:sub(1,1)](value)

    else
        if(tonumber(value)) then
            value = is_dec(value)

        else
            a.lib.write_error(06)
            value = " "

        end -- if(tonumber

    end -- if(not value

    a.registered_command["calc_mode"](param[1], value, modes)
    table.insert(a.code, line .. (value or ""))

end -- a.registered_command[name

function is_dec(value)
        return a.lib.dec2hex(value)

end -- is_dec

function is_hex(value)
    local val = value:match("[^%$][%x]+")
    return val

end -- is_hex

function is_binary(value)
    local val = value:match("[^%%][%d]+")

    return a.lib.bin2hex(val)

end

function is_formula(value)
    local val = value:match("[^{}]+")
    val = a.lib.calc_formula(val)
    val = a.lib.dec2hex(val)
    return val
end

function is_label(value)
   local val = value:match("[^%[%]#<>%$%%]+")
    local lab = val:sub(-1,-1)

    if(lab == ":") then
        return value                                                                     -- is Label

    else
        val = val:byte(1)                                                                -- is char
        if(val) then
            return a.lib.dec2hex(val)

        else
            a.lib(write_error(06))
            return value

        end -- if(val)

    end -- if(value:sub

end -- function is_label

function hilo(value)
    local val 
    
    val = value:sub(1,1)

    if tonumber(value(sub(1,1))) then 
        val = base[" "](value)

    elseif base[val] then
        val = base[val](value)
    
    elseif(not val) then
        a.lib.write_error(06)
        return nil, nil 
    end
    
    return sub(1,2), val:sub(3,val:len())

end -- function hilo(value)
