do
-- Will leave the group if be added
local function run(msg, matches)
local bot_id = 253187717
local receiver = get_receiver(msg)
    if matches[1] == 'leave' and is_admin1(msg) then
       chat_del_user("chat#id"..msg.to.id, 'user#id'..bot_id, ok_cb, false)
	   leave_channel(receiver, ok_cb, false)
end
	if matches[1] == "leave" and matches[2] and is_sudo(msg) then
			send_large_msg("channel#id"..matches[2],"ربات به دلایلی(انقضا,صلاحیت گپ,دستور مدیر)از گروه خارج میشود\n\nبرای اطلاع بیشتر به ربات پیام رسان زیر پیام بدید\nربات پیام رسان : @KnightGuardBot")
      chat_del_user("chat#id"..matches[2], 'user#id'..bot_id, ok_cb, false)
      leave_channel("channel#id"..matches[2], ok_cb, false)
			return "ربات از گروه ["..matches[2].."] خارج شد"
end
    if msg.service and msg.action.type == "chat_add_user" and msg.action.user.id == tonumber(bot_id) and not is_admin1(msg) then
       send_large_msg(receiver, 'This Group Not Added!\nFor Buy Group Send Massage To @KnightGuardBot', ok_cb, false)
       chat_del_user(receiver, 'user#id'..bot_id, ok_cb, false)
	   leave_channel(receiver, ok_cb, false)
      block_user("user#id"..msg.from.id,ok_cb,false)
elseif msg.service and msg.action.type == 'chat_created' and not is_admin1(msg) then
       chat_del_user(receiver, 'user#id'..bot_id, ok_cb, false)
      block_user("user#id"..msg.from.id,ok_cb,false)
    end
end

return {
  patterns = {
    "^[#!/](leave)$",
    "^[#!/](leave)(.*)$",
    "^(leave)$",
    "^(leave)(.*)$",	
    "^!!tgservice (.+)$",
  },
  run = run
}
end
