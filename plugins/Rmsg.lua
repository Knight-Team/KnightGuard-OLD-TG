local function history(extra, suc, result)
  for i=1, #result do
    delete_msg(result[i].id, ok_cb, false)
  end
  if tonumber(extra.con) == #result then
    send_msg(extra.chatid, 'تعداد <b>['..#result..'] </b>پیام با #موفقیت حذف شد!', ok_cb, false)
  else
    send_msg(extra.chatid, '<i>تعداد پیام های مورد نظر شما با #موفقیت حذف شد! </i>', ok_cb, false)
  end
end
local function run(msg, matches)
if redis:get("del:"..msg.to.id) then
    if not is_sudo(msg) then
      local limit = redis:ttl("del:"..msg.to.id)
      local name = msg.from.first_name
      local text = "متاسفم "..name.."\nبه علت محدودیت های تلگرام شما فقط می توانید هر 1200 ثانیه (20 دقیقه) می توانید پیام های گروه خودتان را پاک کنید.\nلطفا <b>["..limit.."] </b>ثانیه دیگر مجداد امتحان کنید."
return text
end
end
redis:setex("del:"..msg.to.id, 1200, true)
  if matches[1] == 'restartdel' then
    if not is_sudo(msg) then
      return "<i>تنها سازنده ربات توانایی ری استارت کردن و 0 کردن زمان پاک کردن پیام گروه شما را دارد! </i>"
      end
    redis:del("del:"..msg.to.id)
    return "زمان با #موفقیت 0 شد.\nهم اکنون می توانید پیام ها رو پاک کنید. (فقط یک بار 😁)"
    end
  if matches[1] == 'del' and is_owner(msg) then
    if msg.to.type == 'channel' then
      if tonumber(matches[2]) > 10000 or tonumber(matches[2]) < 1 then
        return "لطفا دقایقی دیگر امتحان کنید!"
      end
      get_history(msg.to.peer_id, matches[2] + 1 , history , {chatid = msg.to.peer_id, con = matches[2]})
    else
      return "پاک کردن پیام فقط در سوپرگروه ممکن است!"
    end
  else
    return "فقط مدیر_اصلی گروه توانایی حذف پیام ها را دارد!"
  end
end

return {
    patterns = {
        '^[!/#](del) (%d*)$',
        '^[!/#](restartdel)$',
    },
    run = run
}
--by peyman.lua :)
-- @All_0r_NothinG