local function run(msg, matches)
		------fun------
		if matches[1]:lower() == 'infome' and not msg.reply_id then
		local user_id = msg.from.id
    local chat_id = get_receiver(msg)
    local token = "253607124:AAHXElBBu-vnAYYuZP7cuq_YKnSXpe9y04s"
    local db = 'https://api.telegram.org/bot'..token..'/getUserProfilePhotos?user_id='..user_id
    local path = 'https://api.telegram.org/bot'..token..'/getFile?file_id='
    local img = 'https://api.telegram.org/file/bot'..token..'/'
    local res, code = https.request(db)
    local jdat = json:decode(res)
    local fileid = ''
    local count = jdat.result.total_count
  local bot = '253607124'
  if jdat.result.total_count == 0 then
      send_photo(chat_id,photos,ok_cb,false)
         else
    fileid = jdat.result.photos[1][3].file_id
    end
    if tonumber(count) == 0 then
  local photos = '/root/TeleSeed/userinfo/ax.png'
  local user_info = {}
			local uhash = 'user:'..msg.from.id
			local user = redis:hgetall(uhash)
			local um_hash = 'msgs:'..msg.from.id..':'..msg.to.id
			user_info.msgs = tonumber(redis:get(um_hash) or 0)
 local text = '》 نام : {'..msg.from.first_name..'}\n'
..'》 شناسه کاربری : ['..msg.from.id..']\n'
..'》 یوزرنیم [ @'..(msg.from.username or '—-')..' ]\n' 
..'》 تعداد عکس پروفایل : ['..count..']\n'
..'》 تعداد پیام ارسال شده : ['..user_info.msgs..']'
      send_photo2(chat_id,photos,text,ok_cb,false)
         else
    local pt, code = https.request(path..fileid)
    local jdat2 = json:decode(pt)
    local path2 = jdat2.result.file_path
    local link = img..path2
   local photo = download_to_file(link,"ax"..user_id..".jpg")
  local user_info = {}
			local uhash = 'user:'..msg.from.id
			local user = redis:hgetall(uhash)
			local um_hash = 'msgs:'..msg.from.id..':'..msg.to.id
			user_info.msgs = tonumber(redis:get(um_hash) or 0)
		local hash = 'rank:variables'
	if hash then
	  local value = redis:hget(hash, msg.from.id)
	   --if not value then
	   -- value = value..'---'
	  -- end
	   end
	  local _nl, ctrl_chars = string.gsub(msg.text, '%c', '')
	    if string.len(msg.from.print_name) > 40 or ctrl_chars > 70 then
		local text = '<i> 》کاربر </i> [<b>'..msg.from.first_name..'</b>] <i> به دلیل استفاده از کارکتر های طولانی در نام اکانت کاربری خود قادر به نمایش اطلاعات شما نیستم </i>'
return reply_msg(msg.id, text, ok_cb, false)
end

if string.find(msg.from.username , 'A_P_P_L_E') or string.find(msg.from.username , 'ValtMan') or string.find(msg.from.username , 'Apple_VPN') or string.find(msg.from.username , 'booodit') or string.find(msg.from.username , 'Kiarashlua') then
local text = '<i> >متاسفم.شما از بخش دریافت اطلاعات خود مسدود هستید! </i> \n<i> >برای رفع مشکل با مدیریت ارتباط برقرار کنید </i>'
return reply_msg(msg.id, text, ok_cb, false)
end
	   userrank = "Member"
	if tonumber(msg.from.id) == 159887854 then
		userrank = "Master ⭐⭐⭐⭐"
	elseif is_sudo(msg) then
		userrank = "Sudo ⭐⭐⭐⭐⭐"
	elseif is_admin1(msg) then
		userrank = "Admin ⭐⭐⭐"
	elseif tonumber(msg.from.id) == tonumber(is_owner) then
		userrank = "Leader ⭐⭐"
	elseif is_momod(msg) then
		userrank = "Moderator ⭐"
		elseif not is_momod(msg) then
		userrank = "Member ⭐"
	elseif tonumber(msg.from.id) == tonumber(our_id) then
		userrank = "SecurityBOT ⭐⭐⭐⭐⭐⭐"
	elseif msg.from.username then
		if string.sub(msg.from.username:lower(), -3) == "bot" then
			userrank = "API Bot"
		end
		end
		
   local text = '》 نام : {'..msg.from.first_name..'}\n'
..'》 شناسه کاربری: ['..msg.from.id..']\n'
..'》 یوزرنیم: [ @'..(msg.from.username or '—-')..' ]\n' 
..'》 تعداد تصاویر پروفایل: ['..count..']\n'
..'》 تعداد پیام های ارسالی: ['..user_info.msgs..']\n'
..'》 مقام: [---]\n'
..'》 جایگاه: ['..userrank..']'
       --send_photo2(chat_id,photo,text,ok_cb,false)
	   send_photo2(chat_id, photo, text, ok_cb, false)
end
end
end

return {
  patterns = {
    "^[#!/]([Ii][Nn][Ff][Oo][Mm][Ee])$"
  },
  run = run
}
