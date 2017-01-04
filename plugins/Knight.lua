do
local function admin_list(msg)
    local data = load_data(_config.moderation.data)
        local admins = 'admins'
        if not data[tostring(admins)] then
        data[tostring(admins)] = {}
        save_data(_config.moderation.data, data)
        end
        local message = 'Admins >\n'
        for k,v in pairs(data[tostring(admins)]) do
                message = message .. '> @' .. v .. ' [' .. k .. '] ' ..'\n'
        end
        return message
end
local function run(msg, matches)
local uptime = io.popen('uptime'):read('*all')
local admins = admin_list(msg)
local data = load_data(_config.moderation.data)
local group_link = data[tostring(1054786249)]['settings']['set_link'] --put your support id here 
local github = 'github.com/CopierTeam/Umbrella-Cp'
local space = '+-------------------------------+'
if not group_link then
return ''
end
return "╔═─┅┅┅┅─═ঈঊ ..<b>In The Name Of Allah </b>..ঊঈ═─┅┅┅┅─═╗"
.."\n  +-------------------------------+"
.."\n       <i>..:Knight Team:.. </i>"
.."\n  +-------------------------------+"
.."\n  <b>》Projects: </b>"
.."\n  <i>》Knight Guard </i>[@KnightGuard]"
.."\n  <i>》Knight Guard Helper </i>[@KnightGuardHelper]"
.."\n  <i>》YouTube Downloader </i>[@Youtube_DownloaderRoBot]"
.."\n  <i>》Dont Edit Your Massage </i>[@FuckEditbot]"
.."\n  <i>》TranslateBot </i>[@TranslateapiBot]"
.."\n  <i>》And More Coming Soon! </i>"
.."\n  +-------------------------------+"
.."\n  <b>》Features Of The Knight Guard Bot: </b>"
.."\n  <b>》1. </b> <code>Specific Source </code>"
.."\n  <b>》2. </b> <code>Fast And Powerful </code>"
.."\n  <b>》3. </b> <code>Always Updated! </code>"
.."\n  +-------------------------------+"
.."\n  <b>Cteator: </b>"
.."\n  -=-=-=-=-=--=-=-=-=-=-=-=-==-=-=-"
.."\n  <b>ReZa PoKeR </b>"
.."\n  <i>》ID: </i>@P_u_k_e_r_a_m"
.."\n  <i>》PMBoT: </i>@Payamre3an_Bot"
.."\n  <b>Position And Duties: </b>"
.."\n  <i>》Channel Link Exchange </i>"
.."\n  <i>》Handle Support BoT </i>"
.."\n  <i>》Advice To Users(Optional) </i>"
.."\n  <i>》Addressing User Questions(Optional) </i>"
.."\n  <i>》Update Plugins BoT(Optional) </i>"
.."\n  -=-=-=-=-=--=-=-=-=-=-=-=-==-=-=-"
.."\n  <b>ɱøɦΛɱɱΛƊωɦ </b>"
.."\n  <i>》ID: </i>@GodOfDevelopers"
.."\n  <i>》PMBoT: </i>@KnightGuardbot"
.."\n  <b>Position And Duties: </b>"
.."\n  <i>》Developer Source </i>"
.."\n  <b>》Leadership Team </b>"
.."\n  <i>》Writing Plugins </i>"
.."\n  <i>》Advice To Users(Optional) </i>"
.."\n  <i>》Addressing User Questions(Optional) </i>"
.."\n  <i>》Update Plugins BoT </i>"
.."\n  -=-=-=-=-=--=-=-=-=-=-=-=-==-=-=- "
.."\n  <b>Thank You For Your Use Of The BoT </b>"
.."\n  <b>Our Chanel: </b>@Knight_Team"
.."\n  "..space
.."\n  <b>UpTime: </b>"
.."\n-=-=-=-=-=--=-=-=-=-=-=-=-==-=-=-"
.."\n<code>"..uptime.." </code>-=-=-=-=-=--=-=-=-=-=-=-=-==-=-=-"
.."\n <b>Group support link: </b>"
.."\n"..group_link
.."\n ╚═─┅┅┅┅──═ঈঊ ..<b>КЛłght GuΛЯÐ </b>..ঊঈ═─┅┅┅┅──═╝"
end
return {
patterns = {
"^[Kk]night$",
"^[!/#][Kk]night$",
},
run = run
}
end
