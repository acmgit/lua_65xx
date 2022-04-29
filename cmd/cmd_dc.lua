local a = ass
local l = logger
local cname = "dc"
local code

local calculate_dc
local convert_text
local check_label
local formula
local hex
local bin 
local negativ

local cmd = {}
                
a.registered_command[cname] = function()
            
    local passes = {}
    
    passes[1] = calculate_dc
    passes[2] = a.registered_command["do_nothing"]
    passes[3] = a.registered_command["do_nothing"]
    passes[4] = function() return end
    
    if(passes[a.pass]) then
        passes[a.pass]()
            
    end
    
end -- function a.registered_command
                
function calculate_dc()
    local data = {}
    local helpstring = ""
    local line = ""
    
    cmd["$"] = hex
    cmd["%"] = bin
    cmd["#"] = a.lib.dec2hex
    cmd["["] = check_label
    cmd["{"] = formula
    cmd["-"] = negativ
    
    helpstring = a.lib.trim(a.source[a.current_line])
    helpstring = helpstring:sub(helpstring:find("dc")+2, helpstring:len())
        
    for word in string.gmatch(helpstring, "[^,]+[(.)%w%$%%:%[%]%{%}]+") do
        data[#data+1] = word
        
    end -- for word in
        
    for k,v in pairs(data) do
        local command = ""        
        command = v:match("[^%s]+")
        command = command:sub(1,1)
        
        if(tonumber(command)) then                                                       -- it's decimal
            command = "#"
            
        end -- if(tonumber
        
        if(cmd[command]) then
            line = line .. (cmd[command](v) or "") .. " "
            
        else
            a.lib.write_error(06)
            line = line .. v .. " "
            
        end -- if(cmd[command
        
    end -- for k,v
    
    line = "dc " .. line    
    table.insert(a.code, line)
    
end -- function calculate_dc

function hex(text)
    text = text:match("[^%s%$]+")
    return text

end -- hex(text

function bin(text)
    local line = text:match("[^%s%%]+")
    line = a.lib.bin2hex(line)
    return line
    
end -- bin(text)

function negativ(text)
    text = text:match("[^%-%s][%w]")
    local pre = text:sub(1,1)
    if(cmd[pre]) then
        text = cmd[pre](text)
        a.lib.hex2dec(text)
        
    end

    text = 255 - text
    text = a.lib.dec2hex(text)
    
    return text
    
end -- function negativ

function check_label(text)
    
    local line = text:match("[^%s]+[^%[%]]+")
    
    if(line:sub(line:len(), line:len()) == ":") then                                     -- Ok, it's a label
        return text
    
    else
        local result
        result = convert_text(line)
        
        return result
        
    end -- if(line:sub(
    
end -- check_label

function formula(text)
    local line = text:match("[^%s]+[^{}]+")
    line = a.lib.dec2hex(a.lib.calc_formula(line))
    return line
    
end -- function formula

function convert_text(text)
    local line = ""
    for i=1,text:len() do
        line = line .. a.lib.dec2hex(text:byte(i)) .. " "
    
    end
    
    line = a.lib.trim(line)
    return line
   
end -- function convert_text

    
        
