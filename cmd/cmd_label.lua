local a = ass
local l = logger
local cname = "label"
local code
local cmd = {}

local formula
local hex
local dec
local bin
local char
local calc_label
local deflabel
local get_label_adress

a.registered_command[cname] = function(param)

    local passes = {}
    passes[1] = calc_label(param)

    if(passes[a.pass]) then
        passes[a.pass](param)

    end

end

function calc_label(param)
    local label = ""
    local line = a.source[a.current_line]
    local def

    cmd["{"] = formula
    cmd["$"] = hex
    cmd["%"] = bin
    cmd["#"] = dec
    cmd["["] = char
    cmd["="] = deflabel

    label = line:sub(1, line:find(":"))
    def = line:find("=")

    if(def) then                                                                         -- Label is a Deklaration
        cmd["="](label, def)

    else
        a.labels[label] = a.start
        table.insert(a.code, label)

    end -- if(def


end


function formula(lab, text)
    local line = text:match("[^{}]+")

    line = a.lib.dec2hex(a.lib.calc_formula(line))
    a.labels[lab] = line

end

function hex(lab, text)
    local line = text:sub(2)
    a.labels[lab] = line

end

function dec(lab, text)
    local line = a.lib.dec2hex(text)
    a.labels[lab] = line

end

function bin(lab, text)
    local line = text:sub(2)
    line = a.lib.bin2hex(line)
    a.labels[lab] = line

end

function char(text)
    local line = text:match("[^%[%]]+[.]")
    line = a.lib.dec2hex(line:byte(1))
    a.labels[lab] = line

end

function deflabel(label, def)
    local line = a.source[a.current_line]
    line = line:sub(def+1)
    line = line:gsub("%s","")

    local command = ""
    command = line:sub(1,1)
    command = command:gsub("%s","")

    if(tonumber(command)) then                                                       -- it's a decimal digit
        command = "#"

    end -- if(tonumber(command

    if(cmd[command]) then
        cmd[command](label, line)
        table.insert(a.code, " ")

    else
        a.lib.write_error(05)
        table.insert(a.code, " ")

    end -- if(cmd[command]

end
