local function run(msg, matches) 
if matches[1] == "setnerkh" then 
if not is_sudo(msg) then 
return 'شما سودو نیستید' 
end 
local nerkh = matches[2] 
redis:set('bot:nerkh',nerkh) 
return 'متن شما با موفقیت تنظیم شد.^_^' 
end 
if matches[1] == 'nerkh' or '💳' or 'نرخ' then 
    local hash = ('bot:nerkh') 
    local nerkh = redis:get(hash) 
    if not nerkh then 
    return ' ثبت نشده' 
    else 
    reply_msg(msg.id, nerkh, ok_cb, false) 
    end 
    end 
if matches[1] == 'delnerkh' then 
if not is_admin1(msg) then 
return 'شما ادمین نیستید' 
end 
    local hash = ('bot:nerkh') 
    redis:del(hash) 
return ' پاک شد' 
end 
end 
return { 
patterns ={ 
"^[!#/](setnerkh) (.*)$", 
"^[!#/](nerkh)$",
"^💳$",
"^نرخ$", 
"^[!#/](delnerkh)$", 
}, 
run = run 
}