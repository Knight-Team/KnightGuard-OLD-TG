--[[
#●#●#●#●#●#●#●#●#●#●#●#●#●#●#●#●#●#●#●#●#
✽》 Writed By MohammadWH                ✽
✽》 Last Update: 2016/26/11 01:05       ✽
✽》 My Channel:     @Knight_Team        ✽
✽》 My UserName:    @GodOfDevelopers    ✽
✽》 My Pmresan:     @KnightGuardBot     ✽
✽》 My AntiSpamBot: @KnightGuardBot     ✽
#●#●#●#●#●#●#●#●#●#●#●#●#●#●#●#●#●#●#●#●#
]]

local function run(msg,matches)
if matches[1] == "add" and is_admin1(msg) then
local textadd = "\n✽Status:»One Group Added!« \n➖➖➖➖➖\nAdder Info: \n》Name Adder: "..(msg.from.print_name or '----').." \n》UserName: @"..(msg.from.username or 'Knight_Team').."\n》ID: "..(msg.from.id or '----').." \n➖➖➖➖➖\nGroup Info:  \n●Name: "..string.gsub(msg.to.print_name, "_", " ").." \n●ID : "..(msg.to.id or '----').." \n➖➖➖➖➖\nFor Leave Bot Send:\n/leave "..(msg.to.id or '----').."\n➖➖➖➖➖\nKnight Team"


send_large_msg("user#id161141712",textadd)

end
if matches[1] == "rem" and is_admin1(msg) then

local textrem = "\n✽Status:»One Group Removed!« \n➖➖➖➖➖\nRemover Info:  \n》Name Remover: "..(msg.from.print_name or '----').." \n》UserName: @"..(msg.from.username or 'Knight_Team').."\n》ID: "..(msg.from.id or '----').." \n➖➖➖➖➖\nGroup Info:  \n●Name: "..string.gsub(msg.to.print_name, "_", " ").." \n●ID : "..(msg.to.id or '----').." \n➖➖➖➖➖\nKnight Team"
send_large_msg("user#id161141712",textrem)
end
end
return {
patterns = {
"^[!#/]([Aa]dd)$",
"^[!#/]([Rr]em)$",
},
run = run
}
--@Knight_Team