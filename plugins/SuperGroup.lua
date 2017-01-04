 --Begin supergrpup.lua
--Check members #Add supergroup
local function check_member_super(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  if type(result) == 'boolean' then
     return reply_msg(msg.id, '><code> متاسفم.قادر به خواندن این پیام نیستم. </code>\n<b>[Not supported] This is a old message!</b>', ok_cb, false)
   end  
  if success == 0 then
	send_large_msg(receiver, "Promote me to admin first!")
  end
  for k,v in pairs(result) do
    local member_id = v.peer_id
    if member_id ~= our_id then
      -- SuperGroup configuration
      data[tostring(msg.to.id)] = {
        group_type = 'SuperGroup',
		long_id = msg.to.peer_id,
		moderators = {},
        set_owner = member_id ,
        settings = {
          set_name = string.gsub(msg.to.title, '_', ' '),
		  lock_arabic = 'no',
		  lock_link = "no",
		  tag = "no",
		  unsp = "no",
          flood = 'yes',
		  lock_spam = 'yes',
		  lock_sticker = 'no',
		  member = 'no',
		  public = 'yes',
		  lock_rtl = 'no',
		  lock_tgservice = 'yes',
		  lock_contacts = 'no',
		  expiretime = 'null',
		  strict = 'no'
        }
      }
      save_data(_config.moderation.data, data) 
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
	  local text = '<b>SuperGroup Has Been Added!</b>'
      return reply_msg(msg.id, text, ok_cb, false)
    end
  end
end

--Check Members #rem supergroup
local function check_member_superrem(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  if type(result) == 'boolean' then
     return reply_msg(msg.id, '><code> متاسفم.قادر به خواندن این پیام نیستم. </code>\n<b>[Not supported] This is a old message!</b>', ok_cb, false)
   end    
  for k,v in pairs(result) do
    local member_id = v.id
    if member_id ~= our_id then
	  -- Group configuration removal
      data[tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
	  local text = 'SuperGroup Has Been Removed'
      return reply_msg(msg.id, text, ok_cb, false)
    end
  end
end

--Function to Add supergroup
local function superadd(msg)
	local data = load_data(_config.moderation.data)
	local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_super,{receiver = receiver, data = data, msg = msg})
end

--Function to remove supergroup
local function superrem(msg)
	local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_superrem,{receiver = receiver, data = data, msg = msg})
end

--Get and output admins and bots in supergroup
local function callback(cb_extra, success, result)
local i = 1
local chat_name = string.gsub(cb_extra.msg.to.print_name, "_", " ")
local member_type = cb_extra.member_type
local text = member_type.." for "..chat_name..":\n"
for k,v in pairsByKeys(result) do
if not v.first_name then
	name = " "
else
	vname = v.first_name:gsub("‮", "")
	name = vname:gsub("_", " ")
	end
		text = text.."\n"..i.." - "..name.."["..v.peer_id.."]"
		i = i + 1
	end
    send_large_msg(cb_extra.receiver, text)
end

--Get and output info about supergroup
local function callback_info(cb_extra, success, result)
local title ='\n<i>》Info For SuperGroup </i>: <b>'..result.title..' </b>'
local admin_num = '\n<b>》Admin Count </b>: <code>'..result.admins_count..' </code>'
local user_num = '\n<b>》User Count </b>: <code>'..result.participants_count..' </code>'
local kicked_num = '\n<b>》Kicked user count </b>: <code>'..result.kicked_count..' </code>'
local channel_id ='\n<b>》ID </b>: <code>'..result.peer_id..' </code>'
if result.username then
	channel_username = "Username: @"..result.username
else
	channel_username = ""
end
local text = title..admin_num..user_num..kicked_num..channel_id..channel_username
    send_large_msg(cb_extra.receiver, text)
end

--Get and output members of supergroup
local function callback_who(cb_extra, success, result)
local text = "Members for "..cb_extra.receiver
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		username = " @"..v.username
	else
		username = ""
	end
	text = text.."\n"..i.." - "..name.." "..username.." [ "..v.peer_id.." ]\n"
	--text = text.."\n"..username
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./groups/lists/supergroups/"..cb_extra.receiver..".txt", ok_cb, false)
	post_msg(cb_extra.receiver, text, ok_cb, false)
end

--Get and output list of kicked users for supergroup
local function callback_kicked(cb_extra, success, result)
--vardump(result)
local text = "Kicked Members for SuperGroup "..cb_extra.receiver.."\n\n"
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		name = name.." @"..v.username
	end
	text = text.."\n"..i.." - "..name.." [ "..v.peer_id.." ]\n"
	i = i + 1
end
    local file = io.open("./groups/lists/supergroups/kicked/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./groups/lists/supergroups/kicked/"..cb_extra.receiver..".txt", ok_cb, false)
	--send_large_msg(cb_extra.receiver, text)
end

--Begin supergroup locks
local function lock_group_links(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'yes' then
    return '<i>✽Link✽</i><b>Posting Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['lock_link'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Link✽</i> <b>Posting Has Been Enabled</b>'
  end
end

local function unlock_group_links(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'no' then
    return '<i>✽Link✽</i>  <b>Posting Is Not Enabled</b>'
  else
    data[tostring(target)]['settings']['lock_link'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Link✽</i>  <b>Posting Has Been Disabled</b>'
  end
end

local function lock_group_all(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_all_lock = data[tostring(target)]['settings']['all']
  if group_all_lock == 'yes' then
    return '<i>✽All✽</i>  <b>Setting Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['all'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽All✽</i>  <b>Setting Has Been Enabled</b>'
  end
end

local function unlock_group_all(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_all_lock = data[tostring(target)]['settings']['all']
  if group_all_lock == 'no' then
    return '<i>✽All✽</i>  <b>Setting Is Not Enabled</b>'
  else
    data[tostring(target)]['settings']['all'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽All✽</i>  <b>Setting Has Been Disabled</b>'
  end
end

local function lock_group_operator(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_operator_lock = data[tostring(target)]['settings']['operator']
  if group_operator_lock == 'yes' then
    return '<i>✽Operator✽</i>  <b>Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['operator'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Operator✽</i>  <b>Has Been Enabled</b>'
  end
end

local function unlock_group_operator(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_operator_lock = data[tostring(target)]['settings']['operator']
  if group_operator_lock == 'no' then
    return '<i>✽Operator✽</i>  <b>Is Not Enabled</b>'
  else
    data[tostring(target)]['settings']['operator'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Operator✽</i>  <b>Has Been Disabled</b>'
  end
end

local function lock_group_media(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_media_lock = data[tostring(target)]['settings']['media']
  if group_media_lock == 'yes' then
    return '<i>✽Media✽</i>  <b>Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['media'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Media✽</i>  <b>Has Been Enabled</b>'
  end
end

local function unlock_group_media(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_media_lock = data[tostring(target)]['settings']['media']
  if group_media_lock == 'no' then
    return '<i>✽Media✽</i>  <b>Is Not Enabled</b>'
  else
    data[tostring(target)]['settings']['media'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Media✽</i>  <b>Has Been Disabled</b>'
  end
end

local function lock_group_clibot(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_clibot_lock = data[tostring(target)]['settings']['clibot']
  if group_clibot_lock == 'yes' then
    return '<i>✽scaner CliBot✽</i>  <b>Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['clibot'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽scaner CliBot✽</i>  <b>Has Been Effective</b>'
  end
end

local function unlock_group_clibot(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_clibot_lock = data[tostring(target)]['settings']['clibot']
  if group_clibot_lock == 'no' then
    return '<i>✽Scaner CliBot✽</i>  <b>Is Not On</b>'
  else
    data[tostring(target)]['settings']['clibot'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Scaner CliBot✽</i>  <b>Has Been Disabled</b>'
  end
end

local function lock_group_unsp(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_unsp_lock = data[tostring(target)]['settings']['unsp']
  if group_unsp_lock == 'yes' then
    return '<i>✽UnSupported Massage✽</i>  <b>Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['unsp'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽UnSupported Massage✽</i>  <b>Has Been Enabled</b>'
  end
end

local function unlock_group_unsp(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_unsp_lock = data[tostring(target)]['settings']['unsp']
  if group_unsp_lock == 'no' then
    return '<i>✽UnSupported Massage✽</i>  <b>Is Not Enabled</b>'
  else
    data[tostring(target)]['settings']['unsp'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽UnSupported Massage✽</i>  <b>Has Been Disabled</b>'
  end
end

local function lock_group_security(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_security_lock = data[tostring(target)]['settings']['security']
  if group_security_lock == 'yes' then
    return '<i>✽Security✽</i>  <b>Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['security'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Security✽</i>  <b>Has Been Enabled</b>'
  end
end

local function unlock_group_security(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_security_lock = data[tostring(target)]['settings']['security']
  if group_security_lock == 'no' then
    return '<i>✽Security✽</i>  <b>Is Not Enabled</b>'
  else
    data[tostring(target)]['settings']['security'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Security✽</i>  <b>Has Been Disabled</b>'
  end
end

local function lock_group_reply(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_reply_lock = data[tostring(target)]['settings']['reply']
  if group_reply_lock == 'yes' then
    return '<i>✽Reply✽</i>  <b>Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['reply'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Reply✽</i>  <b>Has Been Enabled</b>'
  end
end

local function unlock_group_reply(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_reply_lock = data[tostring(target)]['settings']['reply']
  if group_reply_lock == 'no' then
    return '<i>✽Reply✽</i>  <b>Is Not Enabled</b>'
  else
    data[tostring(target)]['settings']['reply'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Reply✽</i>  <b>Has Been Disabled</b>'
  end
end

local function lock_group_cmd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_cmd_lock = data[tostring(target)]['settings']['cmd']
  if group_cmd_lock == 'yes' then
    return '<i>✽Cmd✽</i>  <b>Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['cmd'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Cmd✽</i>  <b>Has Been Enabled</b>'
  end
end

local function unlock_group_cmd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_cmd_lock = data[tostring(target)]['settings']['cmd']
  if group_cmd_lock == 'no' then
    return '<i>✽Cmd✽</i>  <b>Is Not Enabled</b>'
  else
    data[tostring(target)]['settings']['cmd'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Cmd✽</i>  <b>Has Been Disabled</b>'
  end
end

local function lock_group_edit(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_edit_lock = data[tostring(target)]['settings']['edit']
  if group_edit_lock == 'yes' then
    return '<i>✽Edit✽</i>  <b>Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['edit'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Edit✽</i>  <b>Has Been Enabled</b>'
  end
end

local function unlock_group_edit(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_edit_lock = data[tostring(target)]['settings']['edit']
  if group_edit_lock == 'no' then
    return '<i>✽Edit✽</i>  <b>Is Not Enabled</b>'
  else
    data[tostring(target)]['settings']['edit'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Edit✽</i>  <b>Has Been Disabled</b>'
  end
end

local function lock_group_fwd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fwd_lock = data[tostring(target)]['settings']['fwd']
  if group_fwd_lock == 'yes' then
    return '<i>✽Fwd✽</i>  <b>Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['fwd'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Fwd✽</i>  <b>Has Been Enabled</b>'
  end
end

local function unlock_group_fwd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fwd_lock = data[tostring(target)]['settings']['fwd']
  if group_fwd_lock == 'no' then
    return '<i>✽Fwd✽</i>  <b>Is Not Enabled</b>'
  else
    data[tostring(target)]['settings']['fwd'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Fwd✽</i>  <b>Has Been Disabled</b>'
  end
end

local function lock_group_emoji(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_emoji_lock = data[tostring(target)]['settings']['emoji']
  if group_emoji_lock == 'yes' then
    return '<i>✽Emoji✽</i>  <b>Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['emoji'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Emoji✽</i>  <b>Has Been Enabled</b>'
  end
end

local function unlock_group_emoji(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_emoji_lock = data[tostring(target)]['settings']['emoji']
  if group_emoji_lock == 'no' then
    return '<i>✽Emoji✽</i>  <b>Is Not Enabled</b>'
  else
    data[tostring(target)]['settings']['emoji'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Emoji✽</i>  <b>Has Been Disabled</b>'
  end
end

local function lock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tag_lock = data[tostring(target)]['settings']['tag']
  if group_tag_lock == 'yes' then
    return '<i>✽Tag✽</i>  <b>Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['tag'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Tag✽</i>  <b>Has Been Enabled</b>'
  end
end

local function unlock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tag_lock = data[tostring(target)]['settings']['tag']
  if group_tag_lock == 'no' then
    return '<i>✽Tag✽</i>  <b>Is Not Enabled</b>'
  else
    data[tostring(target)]['settings']['tag'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Tag✽</i>  <b>Has Been Disabled</b>'
  end
end

local function unlock_group_all(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_all_lock = data[tostring(target)]['settings']['all']
  if group_all_lock == 'no' then
    return '<i>✽All✽</i>  <b>Setting Is Not Enabled</b>'
  else
    data[tostring(target)]['settings']['all'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽All✽</i>  <b>Setting Has Been Disabled</b>'
  end
end

local function lock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  if not is_owner(msg) then
    return
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == 'yes' then
    return '<i>✽Spam✽</i>  <b>Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['lock_spam'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Spam✽</i>  <b>Has Been Enabled</b>'
  end
end

local function unlock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == 'no' then
    return '<i>✽Spam✽</i>  <b>Is Not Enabled</b>'
  else
    data[tostring(target)]['settings']['lock_spam'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Spam✽</i>  <b>Has Been Disabled</b>'
  end
end

local function lock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'yes' then
    return '<i>✽Flood✽</i>  <b>Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['flood'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Flood✽</i>  <b>Has Been Enabled</b>'
  end
end

local function unlock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'no' then
    return '<i>✽Flood✽</i>  <b>Is Not Enabled</b>'
  else
    data[tostring(target)]['settings']['flood'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Flood✽</i>  <b>Has Been Disabled</b>'
  end
end

local function lock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'yes' then
    return '<i>✽Arabic✽</i>  <b>Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Arabic✽</i>  <b>Has Been Enabled</b>'
  end
end

local function unlock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'no' then
    return '<i>✽Arabic/Persian✽</i>  <b>Is Already Disabled</b>'
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Arabic/Persian✽</i>  <b>Has Been Disabled</b>'
  end
end

local function owners_channel(extra, success, result)
	local chat_id = extra.chat_id
	local group_owner = data[tostring(msg.to.id)]['set_owner']
	local text = 'SuperGroup Owners :\n'..groupowner.."[LEADER]\n"
	for k,user in ipairs(result.members) do
		if user.print_name then
			hash = 'owner:'..chat_id..':'..user.peer_id
			if redis:get(hash) then
				text = text..('@'.. user.username or user.print_name)..'['..user.peer_id..']\n'
			end
		end
	end
	return send_large_msg('channel#id'..chat_id, text, ok_cb, true)
end


local function lock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'yes' then
    return '<i>✽Members✽</i>  <b>Are Already Enabled</b>'
  else
    data[tostring(target)]['settings']['lock_member'] = 'yes'
    save_data(_config.moderation.data, data)
  end
  return '<i>✽Members✽</i>  <b>Has Been Enabled</b>'
end

local function unlock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'no' then
    return '<i>✽Members✽</i>  <b>Are Not Enabled</b>'
  else
    data[tostring(target)]['settings']['lock_member'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Members✽</i>  <b>Has Been Disabled</b>'
  end
end

local function lock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == 'yes' then
    return '<i>✽RTl✽</i>  <b>Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['lock_rtl'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽RTL✽</i>  <b>Has Been Enabled</b>'
  end
end

local function unlock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == 'no' then
    return '<i>✽RTL✽</i>  <b>Is Already Disabled</b>'
  else
    data[tostring(target)]['settings']['lock_rtl'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽RTL✽</i>  <b>Has Been Disabled</b>'
  end
end

local function lock_group_tgservice(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
  if group_tgservice_lock == 'yes' then
    return '<i>✽Tgservice✽</i>  <b>Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['lock_tgservice'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Tgservice✽</i>  <b>Has Been Enabled</b>'
  end
end

local function unlock_group_tgservice(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
  if group_tgservice_lock == 'no' then
    return '<i>✽TgService✽</i>  <b>Is Not Enabled!</b>'
  else
    data[tostring(target)]['settings']['lock_tgservice'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Tgservice✽</i>  <b>Has Been Disabled</b>'
  end
end

local function lock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == 'yes' then
    return '<i>✽Sticker✽</i>  <b>Posting Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['lock_sticker'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Sticker✽</i>  <b>Posting Has Been Enabled</b>'
  end
end

local function unlock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == 'no' then
    return '<i>✽Sticker✽</i>  <b>Posting Is Already Disabled</b>'
  else
    data[tostring(target)]['settings']['lock_sticker'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Sticker✽</i>  <b>Posting Has Been Disabled</b>'
  end
end

local function lock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == 'yes' then
    return '<i>✽Bots✽</i>  <b>protection Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['lock_bots'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Bots✽</i>  <b>Protection Has Been Enabled</b>'
  end
end

local function unlock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return 
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == 'no' then
    return '<i>✽Bots✽</i>  <b>Protection Is Already Disabled</b>'
  else
    data[tostring(target)]['settings']['lock_bots'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Bots✽</i>  <b>Protection Has Been Disabled</b>'
  end
end

local function lock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == 'yes' then
    return '<i>✽Contact✽</i>  <b>Posting Is Already Enabled</b>'
  else
    data[tostring(target)]['settings']['lock_contacts'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Contact✽</i>  <b>Posting Has Been Enabled</b>'
  end
end

local function unlock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == 'no' then
    return '<i>✽Contact✽</i>  <b>Posting Is Already Disabled</b>'
  else
    data[tostring(target)]['settings']['lock_contacts'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Contact✽</i>  <b>Posting Has Been Disabled</b>'
  end
end

local function enable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == 'yes' then
    return '<i>✽Settings✽</i>  <b>Are Already Strictly Enforced</b>'
  else
    data[tostring(target)]['settings']['strict'] = 'yes'
    save_data(_config.moderation.data, data)
    return '<i>✽Settings✽</i>  <b>Will Be Strictly Enforced</b>'
  end
end

local function disable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == 'no' then
    return '<i>✽Settings✽</i>  <b>Are Not Strictly Enforced</b>'
  else
    data[tostring(target)]['settings']['strict'] = 'no'
    save_data(_config.moderation.data, data)
    return '<i>✽Settings✽</i> <b>Will Not Be Strictly Enforced</b>'
  end
end
--End supergroup locks
--'Set supergroup rules' function
local function set_rulesmod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local data_cat = 'rules'
  data[tostring(target)][data_cat] = rules
  save_data(_config.moderation.data, data)
  return '<b>SuperGroup Rules Set</b>'
end

--'Get supergroup rules' function
local function get_rules(msg, data)
  local data_cat = 'rules'
  if not data[tostring(msg.to.id)][data_cat] then
    return 'No Rules Available.'
  end
  local rules = data[tostring(msg.to.id)][data_cat]
  local group_name = data[tostring(msg.to.id)]['settings']['set_name']
  local rules = '<b>Rules Of</b><i>'..group_name..'</i>:\n-----------------------\n'..rules:gsub("/n", " ")..'\n-----------------------'
  return rules
end

--Set supergroup to public or not public function
local function set_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == 'yes' then
    return '<b>Group Is Already Public</b>'
  else
    data[tostring(target)]['settings']['public'] = 'yes'
    save_data(_config.moderation.data, data)
  end
  return '<b>SuperGroup Is Now: Public</b>'
end

local function unset_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == 'no' then
    return '<b>Group Is Not Public</b>'
  else
    data[tostring(target)]['settings']['public'] = 'no'
	data[tostring(target)]['long_id'] = msg.to.long_id
    save_data(_config.moderation.data, data)
    return '<b>SuperGroup Is Now: Not Public</b>'
  end
end

local function set_owner(cb_extra, success, result)
	local chat_id = cb_extra.chat_id
    local user_id = cb_extra.user_id
    local user_name = result.username
    local chat_type = cb_extra.chat_type
    local hash = 'owner:'..chat_id..':'..user_id
	if redis:get(hash) then
    	if chat_type == 'chat' then
	        send_large_msg('chat#id'..chat_id, 'User '..('@'..user_name or result.print_name)..' Is Already an Owner', ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_large_msg('channel#id'..chat_id, 'User '..('@'..user_name or result.print_name)..' Is Already an Owner', ok_cb, false)
	    end
	else
    	redis:set(hash, true)
	    if cb_extra.chat_type == 'chat' then
	        send_large_msg('chat#id'..chat_id, 'User '..('@'..user_name or result.print_name)..' Is an Owner Now', ok_cb, false)
	    elseif cb_extra.chat_type == 'channel' then
	        send_large_msg('channel#id'..chat_id, 'User '..('@'..user_name or result.print_name)..' Is an Owner Now', ok_cb, false)
	    end
	end
end

local function owner_by_reply(extra, success, result)
    local result = backward_msg_format(result)
    local msg = result
    local chat_id = msg.to.id
    local user_id = msg.from.id
    local chat_type = msg.to.type
    user_info('user#id'..user_id, set_owner, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
end

local function owner_by_username(cb_extra, success, result)
    local chat_type = cb_extra.chat_type
    local chat_id = cb_extra.chat_id
    local user_id = result.peer_id
    local user_name = result.username
    local hash = 'owner:'..chat_id..':'..user_id
    if redis:get(hash) then
    	if chat_type == 'chat' then
	        send_large_msg('chat#id'..chat_id, 'User '..('@'..user_name or result.print_name)..' Is Already an Owner', ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_large_msg('channel#id'..chat_id, 'User '..('@'..user_name or result.print_name)..' Is Already an Owner', ok_cb, false)
	    end
	else
	    redis:set(hash, true)
	    if chat_type == 'chat' then
	        send_large_msg('chat#id'..chat_id, 'User '..('@'..user_name or result.print_name)..'['..user_id..'] Is An Owner Now', ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_large_msg('channel#id'..chat_id, 'User '..('@'..user_name or result.print_name)..'['..user_id..'] Is An Owner Now', ok_cb, false)
	    end
	end
end

local function remowner_by_reply(extra, success, result)
    local result = backward_msg_format(result)
    local msg = result
    local chat_id = msg.to.id
    local user_id = msg.from.id
    local chat_type = msg.to.type
    user_info('user#id'..user_id, set_remowner, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
end

local function set_remowner(cb_extra, success, result)
	local chat_id = cb_extra.chat_id
    local user_id = cb_extra.user_id
    local user_name = result.username
    local chat_type = cb_extra.chat_type
    local hash = 'owner:'..chat_id..':'..user_id
	if redis:get(hash) then
		redis:del(hash)
    	if chat_type == 'chat' then
	        send_large_msg('chat#id'..chat_id, 'User '..('@'..user_name or result.print_name)..' Removed From Group Owners', ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_large_msg('channel#id'..chat_id, 'User '..('@'..user_name or result.print_name)..' Removed From Group Owners', ok_cb, false)
	    end
	else
	    if cb_extra.chat_type == 'chat' then
	        send_large_msg('chat#id'..chat_id, 'User '..('@'..user_name or result.print_name)..' Was Not An Owner', ok_cb, false)
	    elseif cb_extra.chat_type == 'channel' then
	        send_large_msg('channel#id'..chat_id, 'User '..('@'..user_name or result.print_name)..' Was Not An Owner', ok_cb, false)
	    end
	end
end

local function remowner_by_username(cb_extra, success, result)
    local chat_type = cb_extra.chat_type
    local chat_id = cb_extra.chat_id
    local user_id = result.peer_id
    local user_name = result.username
    local hash = 'owner:'..chat_id..':'..user_id
    if redis:get(hash) then
		redis:del(hash)
    	if chat_type == 'chat' then
	        send_large_msg('chat#id'..chat_id, 'User '..('@'..user_name or result.print_name)..' Removed From Group Owners', ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_large_msg('channel#id'..chat_id, 'User '..('@'..user_name or result.print_name)..' Removed From Group Owners', ok_cb, false)
	    end
	else
	    if chat_type == 'chat' then
	        send_large_msg('chat#id'..chat_id, 'User '..('@'..user_name or result.print_name)..' Was Not An Owner', ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_large_msg('channel#id'..chat_id, 'User '..('@'..user_name or result.print_name)..' Was Not An Owner', ok_cb, false)
	    end
	end
end

--Show supergroup settings; function
function show_supergroup_settingsmod(msg, target)
  local floodmaxtime = redis:get('TIME:CHECK'..msg.to.id) or 2
 	if not is_momod(msg) then
    	return
  	end
	local data = load_data(_config.moderation.data)
    if data[tostring(target)] then
     	if data[tostring(target)]['settings']['flood_msg_max'] then
        	NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['flood_msg_max'])
        	print('custom'..NUM_MSG_MAX)
      	else
        	NUM_MSG_MAX = 5
      	end
    end
    local bots_protection = "Yes"
    if data[tostring(target)]['settings']['lock_bots'] then
    	bots_protection = data[tostring(target)]['settings']['lock_bots']
   	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['public'] then
			data[tostring(target)]['settings']['public'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_rtl'] then
			data[tostring(target)]['settings']['lock_rtl'] = 'no'
		end
        end
      if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_tgservice'] then
			data[tostring(target)]['settings']['lock_tgservice'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['tag'] then
			data[tostring(target)]['settings']['tag'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['emoji'] then
			data[tostring(target)]['settings']['emoji'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['fwd'] then
			data[tostring(target)]['settings']['fwd'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['media'] then
			data[tostring(target)]['settings']['media'] = 'no'
		end
	end
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['clibot'] then
			data[tostring(target)]['settings']['clibot'] = 'no'
		end
	end	
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['cmd'] then
			data[tostring(target)]['settings']['cmd'] = 'no'
		end
	end	
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['edit'] then
			data[tostring(target)]['settings']['edit'] = 'no'
		end
	end		
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['unsp'] then
			data[tostring(target)]['settings']['unsp'] = 'no'
		end
	end	
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['security'] then
			data[tostring(target)]['settings']['security'] = 'no'
		end
	end		
	  if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['reply'] then
			data[tostring(target)]['settings']['reply'] = 'no'
		end
	end		
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_member'] then
			data[tostring(target)]['settings']['lock_member'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['all'] then
			data[tostring(target)]['settings']['all'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['operator'] then
			data[tostring(target)]['settings']['operator'] = 'no'
		end
	end
  local gp_type = data[tostring(msg.to.id)]['group_type']
  local Expiretime = "----"
  local now = tonumber(os.time())
  local rrredis = redis:hget ('expiretime', get_receiver(msg))
  if redis:hget ('expiretime', get_receiver(msg)) then

  Expiretime = math.floor((tonumber(rrredis) - tonumber(now)) / 86400) + 1
  end  
  
  	local gp_type = data[tostring(msg.to.id)]['group_type']
	
if is_muted(tostring(target), 'Audio: yes') then
 Audio = '<code>|On|</code>'
 else
 Audio = '<b>|Off|</b>'
 end
    if is_muted(tostring(target), 'Photo: yes') then
 Photo = '<code>|On|</code>'
 else
 Photo = '<b>|Off|</b>'
 end
    if is_muted(tostring(target), 'Video: yes') then
 Video = '<code>|On|</code>'
 else
 Video = '<b>|Off|</b>'
 end
    if is_muted(tostring(target), 'Gifs: yes') then
 Gifs = '<code>|On|</code>'
 else
 Gifs = '<b>|Off|</b>'
 end
 if is_muted(tostring(target), 'Documents: yes') then
 Documents = '<code>|On|</code>'
 else
 Documents = '<b>|Off|</b>'
 end
 if is_muted(tostring(target), 'Text: yes') then
 Text = '<code>|On|</code>'
 else
 Text = '<b>|Off|</b>'
 end
  if is_muted(tostring(target), 'All: yes') then
 All = '<code>|On|</code>'
 else
 All = '<b>|Off|</b>'
 end
  local settings = data[tostring(target)]['settings']
  local text = "<b>Settings Of This Group: </b>\n----------------------\n<b>->Locks </b>\n----------------------\n<i>》Lock Links: </i>  "..settings.lock_link.."\n<i>》Lock Contacts: </i>  "..settings.lock_contacts.."\n<i>》Lock Cmd: </i>  "..settings.cmd.."\n<i>》Lock Edit: </i>  "..settings.edit.."\n<i>》Lock Flood: </i>  "..settings.flood.."\n<i>》Lock Spam: </i>  "..settings.lock_spam.."\n<i>》Lock Member: </i>  "..settings.lock_member.."\n<i>》Lock RTL: </i>  "..settings.lock_rtl.."\n<i>》Lock Tgservice: </i>  "..settings.lock_tgservice.."\n<i>》Lock Sticker: </i>  "..settings.lock_sticker.."\n<i>》Lock Tag(#,@): </i>  "..settings.tag.."\n<i>》Lock Emoji: </i>  "..settings.emoji.."\n<i>》Lock Fwd: </i>  "..settings.fwd.."\n<i>》Lock unsp: </i>  "..settings.unsp.."  \n<i>》Lock Security: </i>  "..settings.security.."  \n<i>》Lock Reply: </i>  "..settings.reply.."  \n<i>》Lock Media: </i>  "..settings.media.."\n<i>》Lock Bots: </i>  "..bots_protection.."\n<i>》Lock Cli Bots: </i>  "..settings.clibot.."\n<i>》Lock Operator: </i>  "..settings.operator.."\n<i>》Lock All: </i>  "..settings.all.."\n----------------------\n<b>->Mute List</b>\n----------------------\n<i>》Mute Audio:</i> "..Audio.."\n<i>》Mute Photo:</i> "..Photo.."\n<i>》Mute Video:</i> "..Video.."\n<i>》Mute Gifs:</i> "..Gifs.."\n<i>》Mute Documents:</i> "..Documents.."\n<i>》Mute Text:</i> "..Text.."\n<i>》Mute All:</i> "..All.."\n----------------------\n<b>->Flood Security & Strict Settings </b>\n----------------------\n<i>》Flood Sensitivity </i> :  "..NUM_MSG_MAX.."\n<i>》Flood Time Check </i> :  "..floodmaxtime.."\n<i>》Strict Settings: </i>  "..settings.strict.."\n----------------------\n✽▬▬▬▬▬▬▬▬▬✽\n<b>✽ExpirTime: </b>"..Expiretime.."✽\n✽▬▬▬▬▬▬▬▬▬✽"
  local text = string.gsub(text,'yes','<code>|Enabled|</code>')
  local text = string.gsub(text,'no','<b>|Disabled|</b>')
  return text
end

local function promote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(<b>InGp</b>)')
  if not data[group] then
    return
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, '<code>'..member_username..'</code><b> Is Already A Moderator!</b>')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
end

local function demote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, '<code>'..member_tag_username..'</code><b> Is Not A Moderator!</b>')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
end

local function promote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(InGp)')
  if not data[group] then
    return send_large_msg(receiver, '<b>SuperGroup Is Not Added!</b>')
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, '<code>'..member_username..'</code><b> Is Already A Moderator!</b>')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, '<code>'..member_username..'</code><b> Has Been Promoted!</b>')
end

local function demote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return send_large_msg(receiver, '<b>Group Is Not Added!</b>')
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, '<code>'..member_tag_username..'</code><b> Is Not A Moderator!</b>')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, '<code>'..member_username..'</code><b> Has Been Demoted!</b>')
end

local function modlist(msg)
  local data = load_data(_config.moderation.data)
  local groups = "groups"
  if not data[tostring(groups)][tostring(msg.to.id)] then
    return '<b>SuperGroup Is Not Added.</b>'
  end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['moderators']) == nil then
    return '<b>No Moderator In This Group.</b>'
  end
  local i = 1
  local message = '\n<b>List Of Moderators For</b><i>' .. string.gsub(msg.to.print_name, '_', ' ') .. '</i>:\n'
  for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
    message = message ..i..' - '..v..' [' ..k.. '] \n'
    i = i + 1
  end
  return message
end
--silent
function silentuser_by_reply(extra, success, result)
	 local user_id = result.from.peer_id
		local receiver = extra.receiver
		local chat_id = result.to.peer_id
		print(user_id)
		print(chat_id)
		if is_muted_user(chat_id, user_id) then
			return send_large_msg(receiver, " [<code>"..user_id.."</code>] <b>Is Already From List</b>")
		end
   if is_owner(extra.msg) then
			mute_user(chat_id, user_id)
		return 	send_large_msg(receiver, " [<code>"..user_id.."</code>] <b>Has Been Added From Silent List</b>")
	end
end

local function silentuser_by_id(extra, success, result)
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			return send_large_msg(receiver, " [<code>"..user_id.."</code>] <b>Is Already From List</b>")
		end
   if is_owner(extra.msg) then
			mute_user(chat_id, user_id)
		return 	send_large_msg(receiver, " [<code>"..user_id.."</code>] <b>Has Been Added From Silent List</b>")
	end
end

local function silentuser_by_username(extra, success, result)
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			return send_large_msg(receiver, " [<code>"..user_id.."</code>] <b>Is Already From List</b>")
		end
   if is_owner(extra.msg) then
			mute_user(chat_id, user_id)
		return 	send_large_msg(receiver, " [<code>"..user_id.."</code>] <b>Has Been Added From Silent List</b>")
	end
end

--unsilent
function unsilentuser_by_reply(extra, success, result)
	 local user_id = result.from.peer_id
		local receiver = extra.receiver
		local chat_id = result.to.peer_id
		print(user_id)
		print(chat_id)
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "[<code>"..user_id.."</code>] <b>Removed From Silent List</b>")
else
			send_large_msg(receiver, "[<code>"..user_id.."</code>] <b>Is Not Silented</b>")
		end
	end

local function unsilentuser_by_id(extra, success, result)
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "[<code>"..user_id.."</code>] <b>Removed From Silent List</b>")
else
			send_large_msg(receiver, "[<code>"..user_id.."</code>] <b>Is Not Silented</b>")
		end
	end

local function unsilentuser_by_username(extra, success, result)
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "[<code>"..user_id.."</code>] <b>Removed From Silent List</b>")
else
			send_large_msg(receiver, "[<code>"..user_id.."</code>] <b>Is Not Silented</b>")
		end
	end

-- Start by reply actions
function get_message_callback(extra, success, result)
	local get_cmd = extra.get_cmd
	local msg = extra.msg
	local data = load_data(_config.moderation.data)
	local print_name = user_print_name(msg.from):gsub("‮", "")
	local name_log = print_name:gsub("_", " ")
    if get_cmd == "id" and not result.action then
		local channel = 'channel#id'..result.to.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id for: ["..result.from.peer_id.."]")
		id1 = send_large_msg(channel, result.from.peer_id)
	elseif get_cmd == 'id' and result.action then
		local action = result.action.type
		if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
			if result.action.user then
				user_id = result.action.user.peer_id
			else
				user_id = result.peer_id
			end
			local channel = 'channel#id'..result.to.peer_id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id by service msg for: ["..user_id.."]")
			id1 = send_large_msg(channel, user_id)
		end
    elseif get_cmd == "idfrom" then
		local channel = 'channel#id'..result.to.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] obtained id for msg fwd from: ["..result.fwd_from.peer_id.."]")
		id2 = send_large_msg(channel, result.fwd_from.peer_id)
    elseif get_cmd == 'channel_block' and not result.action then
		local member_id = result.from.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "Leave Using Kickme Command")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
			   return send_large_msg("channel#id"..channel_id, "\n<b>You Can't Kick Mods/Owner/Admins</b>")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "\n<b>You Can't Kick Other Admins</b>")
    end
		--savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..user_id.."] by reply")
		kick_user(member_id, channel_id)
	elseif get_cmd == 'channel_block' and result.action and result.action.type == 'chat_add_user' then
		local user_id = result.action.user.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
			   return send_large_msg("channel#id"..channel_id, "\n<b>You Can't Kick Mods/Owner/Admins</b>")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "\n<b>You Can't Kick Other Admins</b>")
    end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..user_id.."] by reply to sev. msg.")
		kick_user(user_id, channel_id)
	elseif get_cmd == "del" then
		delete_msg(result.id, ok_cb, false)
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] deleted a message by reply")
	elseif get_cmd == "setadmin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		channel_set_admin(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
			text = '\n<code>@'..result.from.username..'</code> <b>Set As An Admin</b>'
		else
			text = '[ <code>'..user_id..'</code> ]<b>Set As An Admin</b>'
		end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] set: ["..user_id.."] as admin by reply")
		send_large_msg(channel_id, text)
	elseif get_cmd == "demoteadmin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		if is_admin2(result.from.peer_id) then
			return send_large_msg(channel_id, "\n<b>You Can't Demote Global Admins!</b>")
		end
		channel_demote(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
			text = '[<code>@'..result.from.username..'</code>] <b>Has Been Demoted From Admin</b>'
		else
			text = '[<code>'..user_id..'</code>] <b>Has Been Demoted From Admin</b>'
		end
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted: ["..user_id.."] from admin by reply")
		send_large_msg(channel_id, text)
	elseif get_cmd == "setowner" then
		local group_owner = data[tostring(result.to.peer_id)]['set_owner']
		if group_owner then
		local channel_id = 'channel#id'..result.to.peer_id
			if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
				local user = "user#id"..group_owner
				channel_demote(channel_id, user, ok_cb, false)
			end
			local user_id = "user#id"..result.from.peer_id
			channel_set_admin(channel_id, user_id, ok_cb, false)
			data[tostring(result.to.peer_id)]['set_owner'] = tostring(result.from.peer_id)
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set: ["..result.from.peer_id.."] as owner by reply")
			if result.from.username then
				text = '[<code>@'..result.from.username..'</code>] [<code>'..result.from.peer_id..'</code>] <b>Added As Owner</b>'
			else
				text = '[<code>'..result.from.peer_id..'</code>] <b>Added As Owner</b>'
			end
			send_large_msg(channel_id, text)
		end
	elseif get_cmd == "promote" then
		local receiver = result.to.peer_id
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("‮", "")
		local member_username = member_name:gsub("_", " ")
		if result.from.username then
			member_username = '@'.. result.from.username
		end
		local member_id = result.from.peer_id
		if result.to.peer_type == 'channel' then
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted mod: @"..member_username.."["..result.from.peer_id.."] by reply")
		promote2("channel#id"..result.to.peer_id, member_username, member_id)
	    --channel_set_mod(channel_id, user, ok_cb, false)
		end
	elseif get_cmd == "demote" then
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("‮", "")
		local member_username = member_name:gsub("_", " ")
    if result.from.username then
		member_username = '@'.. result.from.username
    end
		local member_id = result.from.peer_id
		--local user = "user#id"..result.peer_id
		savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted mod: @"..member_username.."["..user_id.."] by reply")
		demote2("channel#id"..result.to.peer_id, member_username, member_id)
		--channel_demote(channel_id, user, ok_cb, false)
	elseif get_cmd == 'mute_user' then
		if result.service then
			local action = result.action.type
			if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
				if result.action.user then
					user_id = result.action.user.peer_id
				end
			end
			if action == 'chat_add_user_link' then
				if result.from then
					user_id = result.from.peer_id
				end
			end
		else
			user_id = result.from.peer_id
		end
		local receiver = extra.receiver
		local chat_id = msg.to.id
		print(user_id)
		print(chat_id)
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, '[<code>'..user_id..'</code>] <b>Removed From The Muted User List</b>')
		elseif is_admin1(msg) then
			mute_user(chat_id, user_id)
			send_large_msg(receiver, ' [<code>'..user_id..'</code>] <b>Added To The Muted User List</b>')
		end
	end
end
-- End by reply actions

--By ID actions
local function cb_user_info(extra, success, result)
	local receiver = extra.receiver
	local user_id = result.peer_id
	local get_cmd = extra.get_cmd
	local data = load_data(_config.moderation.data)
	--[[if get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		channel_set_admin(receiver, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been set as an admin"
		else
			text = "[ "..result.peer_id.." ] has been set as an admin"
		end
			send_large_msg(receiver, text)]]
	if get_cmd == "demoteadmin" then
		if is_admin2(result.peer_id) then
			return send_large_msg(receiver, "\n<b>You Can't Demote Global Admins!</b>")
		end
		local user_id = "user#id"..result.peer_id
		channel_demote(receiver, user_id, ok_cb, false)
		if result.username then
			text = '[<code>@'..result.username..'</code>] <b>Has Been Demoted From Admin</b>'
			send_large_msg(receiver, text)
		else
			text = '[<code>'..result.peer_id..'</code>] <b>Has Been Demoted From Admin</b>'
			send_large_msg(receiver, text)
		end
	elseif get_cmd == "promote" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		promote2(receiver, member_username, user_id)
	elseif get_cmd == "demote" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		demote2(receiver, member_username, user_id)
	end
end

-- Begin resolve username actions
local function callbackres(extra, success, result)
  local member_id = result.peer_id
  local member_username = "@"..result.username
  local get_cmd = extra.get_cmd
	if get_cmd == "res" then
		local user = result.peer_id
		local name = string.gsub(result.print_name, "_", " ")
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user..'\n'..name)
		return user
	elseif get_cmd == "id" then
		local user = result.peer_id
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user)
		return user
  elseif get_cmd == "invite" then
    local receiver = extra.channel
    local user_id = "user#id"..result.peer_id
    channel_invite(receiver, user_id, ok_cb, false)
	elseif get_cmd == "promote" then
		local receiver = extra.channel
		local user_id = result.peer_id
		--local user = "user#id"..result.peer_id
		promote2(receiver, member_username, user_id)
		--channel_set_mod(receiver, user, ok_cb, false)
	elseif get_cmd == "demote" then
		local receiver = extra.channel
		local user_id = result.peer_id
		local user = "user#id"..result.peer_id
		demote2(receiver, member_username, user_id)
	elseif get_cmd == "demoteadmin" then
		local user_id = "user#id"..result.peer_id
		local channel_id = extra.channel
		if is_admin2(result.peer_id) then
			return send_large_msg(channel_id, "\n<b>You Can't Demote Global Admins!</b>")
		end
		channel_demote(channel_id, user_id, ok_cb, false)
		if result.username then
			text = '[<code>@'..result.username..'</code>] <b>Has Been Demoted From Admin</b>'
			send_large_msg(channel_id, text)
		else
			text = '[<code>@'..result.peer_id..'</code>] <b>Has Been Demoted From Admin</b>'
			send_large_msg(channel_id, text)
		end
		local receiver = extra.channel
		local user_id = result.peer_id
		demote_admin(receiver, member_username, user_id)
	elseif get_cmd == 'mute_user' then
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, ' [<code>'..user_id..'</code>] <b>Removed From Muted User List</b>')
		elseif is_owner(extra.msg) then
			mute_user(chat_id, user_id)
			send_large_msg(receiver, ' [<code>'..user_id..'</code>] <b>Added To Muted User List</b>')
		end
	end
end
--End resolve username actions

--Begin non-channel_invite username actions
local function in_channel_cb(cb_extra, success, result)
  local get_cmd = cb_extra.get_cmd
  local receiver = cb_extra.receiver
  local msg = cb_extra.msg
  local data = load_data(_config.moderation.data)
  local print_name = user_print_name(cb_extra.msg.from):gsub("‮", "")
  local name_log = print_name:gsub("_", " ")
  local member = cb_extra.username
  local memberid = cb_extra.user_id
  if member then
    text = '<b>No User</b> [<code>@'..member..'</code>] <b>In This SuperGroup.</b>'
  else
    text = '<b>No User</b> [<code>'..memberid..'</code>] <b>In This SuperGroup.</b>'
  end
if get_cmd == "channel_block" then
  for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
     local user_id = v.peer_id
     local channel_id = cb_extra.msg.to.id
     local sender = cb_extra.msg.from.id
      if user_id == sender then
        return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
      end
      if is_momod2(user_id, channel_id) and not is_admin2(sender) then
        return send_large_msg("channel#id"..channel_id, "\n<b>You Can't Kick Mods/Owner/Admins</b>")
      end
      if is_admin2(user_id) then
        return send_large_msg("channel#id"..channel_id, "You Can't Kick Other Admins")
      end
      if v.username then
        text = ""
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: @"..v.username.." ["..v.peer_id.."]")
      else
        text = ""
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: ["..v.peer_id.."]")
      end
      kick_user(user_id, channel_id)
      return
    end
  end
elseif get_cmd == "setadmin" then
   for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
      local user_id = "user#id"..v.peer_id
      local channel_id = "channel#id"..cb_extra.msg.to.id
      channel_set_admin(channel_id, user_id, ok_cb, false)
      if v.username then
        text = '[<code>@'..v.username..'</code>] [<code>'..v.peer_id..'</code>] <b>Has Been Set As An Admin</b>'
        savelog(msg.to.id, name_log..' ['..msg.from.id..'] set admin @'..v.username..' ['..v.peer_id..']')
      else
        text = "[<code>"..v.peer_id.."</code>] <b>Has Been Set As An Admin</b>"
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin "..v.peer_id)
      end
	  if v.username then
		member_username = "@"..v.username
	  else
		member_username = string.gsub(v.print_name, '_', ' ')
	  end
		local receiver = channel_id
		local user_id = v.peer_id
		promote_admin(receiver, member_username, user_id)

    end
    send_large_msg(channel_id, text)
    return
 end
 elseif get_cmd == 'setowner' then
	for k,v in pairs(result) do
		vusername = v.username
		vpeer_id = tostring(v.peer_id)
		if vusername == member or vpeer_id == memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
					local user_id = "user#id"..v.peer_id
					channel_set_admin(receiver, user_id, ok_cb, false)
					data[tostring(channel)]['set_owner'] = tostring(v.peer_id)
					save_data(_config.moderation.data, data)
					savelog(channel, name_log.."["..from_id.."] set ["..v.peer_id.."] As Owner By UserName")
				if result.username then
					text = '[<code>'..member_username..'</code>] [<code>'..v.peer_id..'</code>] <b>Added As Owner</b>'
				else
					text = '[<code>'..v.peer_id..'</code>] <b>Added As Owner</b>'
				end
			end
		elseif memberid and vusername ~= member and vpeer_id ~= memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
				data[tostring(channel)]['set_owner'] = tostring(memberid)
				save_data(_config.moderation.data, data)
				savelog(channel, name_log.."["..from_id.."] set ["..memberid.."] as owner by username")
				text = '[<code>'..memberid..'</code>] <b>Added As Owner</b>'
			end
		end
	end
 end
send_large_msg(receiver, text)
end
--End non-channel_invite username actions

--'Set supergroup photo' function
local function set_supergroup_photo(msg, success, result)
  local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)] then
      return
  end
  local receiver = get_receiver(msg)
  if success then
    local file = 'data/photos/channel_photo_'..msg.to.id..'.jpg'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    channel_set_photo(receiver, file, ok_cb, false)
    data[tostring(msg.to.id)]['settings']['set_photo'] = file
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, 'Photo Saved!', ok_cb, false)
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, Please Try Again!', ok_cb, false)
  end
end
--add sms send
local function add_sms(text)
	local path = "http://onlinepanel.ir/post/sendsms.ashx?from=50009666563800&to=09193935744&text="
	local text = URL.escape(text)
	local param = "&password=56385638&username=9167307785"
	local url = path..text..param
	local res = http.request(url)
	if res == "1-0" then
		return 'پيام با موفقيت ارسال شد'
	else
		return 'خطا در ارسال\nشماره خطا: '..res
	end
end
--Run function
local function run(msg, matches)
	if msg.to.type == 'chat' then
		if matches[1] == 'tosuper' then
			if not is_admin1(msg) then
				return
			end
			local receiver = get_receiver(msg)
			chat_upgrade(receiver, ok_cb, false)
		end
	elseif msg.to.type == 'channel'then
		if matches[1] == 'tosuper' then
			if not is_admin1(msg) then
				return
			end
			return '<b>Already a SuperGroup</b>'
		end
	end
	if msg.to.type == 'channel' then
	local support_id = msg.from.id
	local receiver = get_receiver(msg)
	local print_name = user_print_name(msg.from):gsub("?", "")
	local name_log = print_name:gsub("_", " ")
	local data = load_data(_config.moderation.data)
		if matches[1] == 'add' and not matches[2] then
			if not is_admin1(msg) and not is_support(support_id) then
				return
			end
			if is_super_group(msg) then
				return '<b>SuperGroup Is Already Added.</b>'
			end
			text_sms = "ربات در گروه جدید وارد شد\nName Group : "..msg.to.print_name.."\nGroup ID : "..msg.to.id.."\nADMIN Name : "..msg.from.id.."\nAdmin Number : "..(msg.from.phone or '----').."\nADMIN Username : "..(msg.from.username or '----')..""
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") added")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] added SuperGroup")
			superadd(msg)
			add_sms(text)
			set_mutes(msg.to.id)
			channel_set_admin(receiver, 'user#id'..msg.from.id, ok_cb, false)
		end

		if matches[1] == 'rem' and is_admin1(msg) and not matches[2] then
			if not is_super_group(msg) then
				return reply_msg(msg.id, '<b>SuperGroup Is Not Added.</b>', ok_cb, false)
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") removed")
			superrem(msg)
			rem_mutes(msg.to.id)
		end

		if not data[tostring(msg.to.id)] then
			return
		end
		if matches[1] == "gpinfo" then
			if not is_owner(msg) then
				return
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup info")
			channel_info(receiver, callback_info, {receiver = receiver, msg = msg})
		end

		if matches[1] == "admins" then
			if not is_owner(msg) and not is_support(msg.from.id) then
				return
			end
			member_type = 'Admins'
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup Admins list")
			admins = channel_get_admins(receiver,callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1] == "owner" then
			local group_owner = data[tostring(msg.to.id)]['set_owner']
			if not group_owner then
				return '<b>No Owner,Ask Admins In Support Groups To Set Owner For Your SuperGroup</b>'
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] used /owner")
			return '<b>SuperGroup Owner Is</b> [<code>'..group_owner..'</code>]'
		end

		if matches[1] == "modlist" then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group modlist")
			return modlist(msg)
			-- channel_get_admins(receiver,callback, {receiver = receiver})
		end

		if matches[1] == "bots" and is_momod(msg) then
			member_type = 'Bots'
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup bots list")
			channel_get_bots(receiver, callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1] == "who" and not matches[2] and is_momod(msg) then
			local user_id = msg.from.peer_id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup users list")
			channel_get_users(receiver, callback_who, {receiver = receiver})
		end

		if matches[1] == "kicked" and is_momod(msg) then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested Kicked users list")
			channel_get_kicked(receiver, callback_kicked, {receiver = receiver})
		end

		if matches[1] == 'del' and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'del',
					msg = msg
				}
				delete_msg(msg.id, ok_cb, false)
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			end
		end

		if matches[1] == 'block' or matches[1] == 'kick' and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'channel_block',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'block' or matches[1] == 'kick' and string.match(matches[2], '^%d+$') then
				--[[local user_id = matches[2]
				local channel_id = msg.to.id
				if is_momod2(user_id, channel_id) and not is_admin2(user_id) then
					return send_large_msg(receiver, "\n<b>You Can't Kick Mods/Owner/Admins</b>")
				end
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: [ user#id"..user_id.." ]")
				kick_user(user_id, channel_id)]]
				local	get_cmd = 'channel_block'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif msg.text:match("@[%a%d]") then
			--[[local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'channel_block',
					sender = msg.from.id
				}
			    local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] kicked: @"..username)
				resolve_username(username, callbackres, cbres_extra)]]
			local get_cmd = 'channel_block'
			local msg = msg
			local username = matches[2]
			local username = string.gsub(matches[2], '@', '')
			channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'id' then
			if type(msg.reply_id) ~= "nil" and is_momod(msg) and not matches[2] then
				local cbreply_extra = {
					get_cmd = 'id',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif type(msg.reply_id) ~= "nil" and matches[2] == "from" and is_momod(msg) then
				local cbreply_extra = {
					get_cmd = 'idfrom',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif msg.text:match("@[%a%d]") then
				local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'id'
				}
				local username = matches[2]
				local username = username:gsub("@","")
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested ID for: @"..username)
				resolve_username(username,  callbackres, cbres_extra)
			else
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup ID")
				return "\n<b>》Your ID: </b><code>"..msg.from.id.." </code>\n<b>》ID's Group: </b><code>"..msg.to.id.." </code>"
			end
		end
		
		if matches[1] == 'kickme' then
			if msg.to.type == 'channel' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] left via kickme")
				channel_kick("channel#id"..msg.to.id, "user#id"..msg.from.id, ok_cb, false)
			end
		end

		if matches[1] == 'newlink' and is_momod(msg)then
			local function callback_link (extra , success, result)
			local receiver = get_receiver(msg)
				if success == 0 then
					send_large_msg(receiver, '*Error: Failed To Retrieve Link* \nReason: Not Creator.\n\nIf You Have The Link, Please Use /setlink To Set It')
					data[tostring(msg.to.id)]['settings']['set_link'] = nil
					save_data(_config.moderation.data, data)
				else
					send_large_msg(receiver, "Created A New Link")
					data[tostring(msg.to.id)]['settings']['set_link'] = result
					save_data(_config.moderation.data, data)
				end
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] attempted to create a new SuperGroup link")
			export_channel_link(receiver, callback_link, false)
		end

		if matches[1] == 'setlink' and is_owner(msg) then
			data[tostring(msg.to.id)]['settings']['set_link'] = 'waiting'
			save_data(_config.moderation.data, data)
			return '<b>Please Send The New Group Link Now</b>'
		end

		if msg.text then
			if msg.text:match("^(.*)$") and data[tostring(msg.to.id)]['settings']['set_link'] == 'waiting' and is_owner(msg) then
				data[tostring(msg.to.id)]['settings']['set_link'] = msg.text
				save_data(_config.moderation.data, data)
				return "New Link Set"
			end
		end

		if matches[1] == 'link' then
			if not is_momod(msg) then
				return '<b>Group Link:</b>\n'..group_link
			end
			local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			if not group_link then
				return "Create A Link Using /newlink First!\n\nOr If I Am Not Creator Use /setlink To Set Your Link"
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group link ["..group_link.."]")
			return '<b>Group Link:</b>\n'..group_link
		end

		if matches[1] == "invite" and is_sudo(msg) then
			local cbres_extra = {
				channel = get_receiver(msg),
				get_cmd = "invite"
			}
			local username = matches[2]
			local username = username:gsub("@","")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] invited @"..username)
			resolve_username(username,  callbackres, cbres_extra)
		end

		if matches[1] == 'res' and is_owner(msg) then
			local cbres_extra = {
				channelid = msg.to.id,
				get_cmd = 'res'
			}
			local username = matches[2]
			local username = username:gsub("@","")
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] resolved username: @"..username)
			resolve_username(username,  callbackres, cbres_extra)
		end

		--[[if matches[1] == 'kick' and is_momod(msg) then
			local receiver = channel..matches[3]
			local user = "user#id"..matches[2]
			chaannel_kick(receiver, user, ok_cb, false)
		end]]

			if matches[1] == 'setadmin' then
				if not is_support(msg.from.id) and not is_owner(msg) then
					return
				end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'setadmin',
					msg = msg
				}
				setadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'setadmin' and string.match(matches[2], '^%d+$') then
			--[[]	local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'setadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})]]
				local	get_cmd = 'setadmin'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1] == 'setadmin' and not string.match(matches[2], '^%d+$') then
				--[[local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'setadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set admin @"..username)
				resolve_username(username, callbackres, cbres_extra)]]
				local	get_cmd = 'setadmin'
				local	msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'demoteadmin' then
			if not is_support(msg.from.id) and not is_owner(msg) then
				return
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demoteadmin',
					msg = msg
				}
				demoteadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'demoteadmin' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demoteadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'demoteadmin' and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demoteadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted admin @"..username)
				resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == 'setowner' and is_owner(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'setowner',
					msg = msg
				}
				setowner = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'setowner' and string.match(matches[2], '^%d+$') then
		--[[	local group_owner = data[tostring(msg.to.id)]['set_owner']
				if group_owner then
					local receiver = get_receiver(msg)
					local user_id = "user#id"..group_owner
					if not is_admin2(group_owner) and not is_support(group_owner) then
						channel_demote(receiver, user_id, ok_cb, false)
					end
					local user = "user#id"..matches[2]
					channel_set_admin(receiver, user, ok_cb, false)
					data[tostring(msg.to.id)]['set_owner'] = tostring(matches[2])
					save_data(_config.moderation.data, data)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set ["..matches[2].."] as owner")
					local text = "[ "..matches[2].." ] added as owner"
					return text
				end]]
				local	get_cmd = 'setowner'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1] == 'setowner' and not string.match(matches[2], '^%d+$') then
				local	get_cmd = 'setowner'
				local	msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'promote' then
		  if not is_momod(msg) then
				return
			end
			if not is_owner(msg) then
				return '<b>Only owner/admin can promote</b>'
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'promote',
					msg = msg
				}
				promote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'promote' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'promote'
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted user#id"..matches[2])
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'promote' and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'promote',
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] promoted @"..username)
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == 'setmod' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_set_mod(channel, user_id, ok_cb, false)
			return "\n<b>User Added To Admins Group</b>"
		end
		if matches[1] == 'remmod' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_demote(channel, user_id, ok_cb, false)
			return "\n<b>User Removed From Admins Group"
		end

		if matches[1] == 'demote' then
			if not is_momod(msg) then
				return
			end
			if not is_owner(msg) then
				return "\n<b>Only Owner/Support/Admin Can Promote</b>"
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demote',
					msg = msg
				}
				demote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'demote' and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demote'
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted user#id"..matches[2])
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demote'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] demoted @"..username)
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == "setname" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local set_name = string.gsub(matches[2], '_', '')
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] renamed SuperGroup to: "..matches[2])
			rename_channel(receiver, set_name, ok_cb, false)
		end

		if msg.service and msg.action.type == 'chat_rename' then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] renamed SuperGroup to: "..msg.to.title)
			data[tostring(msg.to.id)]['settings']['set_name'] = msg.to.title
			save_data(_config.moderation.data, data)
		end

		if matches[1] == "setabout" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local about_text = matches[2]
			local data_cat = 'description'
			local target = msg.to.id
			data[tostring(target)][data_cat] = about_text
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup description to: "..about_text)
			channel_set_about(receiver, about_text, ok_cb, false)
			return '<b>Description Has Been Set.</b>\n<b>Select The Chat Again To See The Changes.</b>'
		end

		if matches[1] == "setusername" and is_admin1(msg) then
			local function ok_username_cb (extra, success, result)
				local receiver = extra.receiver
				if success == 1 then
					send_large_msg(receiver, "SuperGroup UserName Set.\n\nSelect The Chat Again To See The Changes.")
				elseif success == 0 then
					send_large_msg(receiver, "Failed To Set SuperGroup UserName.\nUsername May Already Be Taken.\n\nNote: Username can use a-z, 0-9 and underscores.\nMinimum length is 5 characters.")
				end
			end
			local username = string.gsub(matches[2], '@', '')
			channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
		end

		if matches[1] == 'setrules' and is_momod(msg) then
			rules = matches[2]
			local target = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] has changed group rules to ["..matches[2].."]")
			return set_rulesmod(msg, data, target)
		end

		if msg.media then
			if msg.media.type == 'photo' and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_momod(msg) then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set new SuperGroup photo")
				load_photo(msg.id, set_supergroup_photo, msg)
				return
			end
		end
		if matches[1] == 'setphoto' and is_momod(msg) then
			data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] started setting new SuperGroup photo")
			return '<b>Please Send The New Group Photo Now</b>'
		end

		if matches[1] == 'clean' then
			if not is_momod(msg) then
				return
			end
			if not is_momod(msg) then
				return '<b>Only Owner Can Clean</b>'
			end
			if matches[2] == 'modlist' then
				if next(data[tostring(msg.to.id)]['moderators']) == nil then
					return '<b>No moderator(s) in this SuperGroup.</b>'
				end
				for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
					data[tostring(msg.to.id)]['moderators'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned modlist")
				return '<b>Modlist Has Been Cleaned</b>'
			end
			if matches[2] == 'rules' then
				local data_cat = 'rules'
				if data[tostring(msg.to.id)][data_cat] == nil then
					return "\n<b>Rules Have Not Been Set</b>"
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned rules")
				return '<b>Rules Have Been Cleaned</b>'
			end
			if matches[2] == 'about' then
				local receiver = get_receiver(msg)
				local about_text = ' '
				local data_cat = 'description'
				if data[tostring(msg.to.id)][data_cat] == nil then
					return '<b>About Is Not Set</b>'
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] cleaned about")
				channel_set_about(receiver, about_text, ok_cb, false)
				return "\n<b>About Has Been Cleaned</b>"
			end
			if matches[2] == 'silentlist' then
				chat_id = msg.to.id
				local hash =  'mute_user:'..chat_id
					redis:del(hash)
				return "\n<b>Silent List Cleaned</b>"
			end
			if matches[2] == 'username' and is_admin1(msg) then
				local function ok_username_cb (extra, success, result)
					local receiver = extra.receiver
					if success == 1 then
						send_large_msg(receiver, "SuperGroup Username Cleaned.")
					elseif success == 0 then
						send_large_msg(receiver, "Failed To Clean SuperGroup Username.")
					end
				end
				local username = ""
				channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
			end
		end

		if matches[1] == 'lock' and is_momod(msg) then
			local target = msg.to.id
			     if matches[2] == 'all' then
      	local safemode ={
        lock_group_links(msg, data, target),
		lock_group_tag(msg, data, target),
		lock_group_spam(msg, data, target),
		lock_group_flood(msg, data, target),
		lock_group_arabic(msg, data, target),
		lock_group_membermod(msg, data, target),
		lock_group_rtl(msg, data, target),
		lock_group_tgservice(msg, data, target),
		lock_group_sticker(msg, data, target),
		lock_group_contacts(msg, data, target),
		lock_group_fwd(msg, data, target),
		lock_group_emoji(msg, data, target),
		lock_group_media(msg, data, target),
		lock_group_clibot(msg, data, target),		
		lock_group_unsp(msg, data, target),
		lock_group_security(msg, data, target),		
		lock_group_reply(msg, data, target),		
		lock_group_cmd(msg, data, target),
		lock_group_edit(msg, data, target),		
		lock_group_bots(msg, data, target),
		lock_group_operator(msg, data, target),
      	}
      	return lock_group_all(msg, data, target), safemode
      end
			if matches[2] == 'links' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled link posting ")
				return lock_group_links(msg, data, target)
			end
			if matches[2] == 'tag' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled tag ")
				return lock_group_tag(msg, data, target)
			end			
			if matches[2] == 'spam' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled spam ")
				return lock_group_spam(msg, data, target)
			end
			if matches[2] == 'flood' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled flood ")
				return lock_group_flood(msg, data, target)
			end
			if matches[2] == 'arabic' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled arabic ")
				return lock_group_arabic(msg, data, target)
			end
			if matches[2] == 'member' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled member ")
				return lock_group_membermod(msg, data, target)
			end		    
			if matches[2]:lower() == 'rtl' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled rtl chars. in names")
				return lock_group_rtl(msg, data, target)
			end
			if matches[2] == 'tgservice' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled Tgservice Actions")
				return lock_group_tgservice(msg, data, target)
			end
			if matches[2] == 'sticker' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled sticker posting")
				return lock_group_sticker(msg, data, target)
			end
			if matches[2] == 'contacts' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled contact posting")
				return lock_group_contacts(msg, data, target)
			end
			if matches[2] == 'strict' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled enabled strict settings")
				return enable_strict_rules(msg, data, target)
			end
			if matches[2] == 'fwd' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled fwd")
				return lock_group_fwd(msg, data, target)
			end
			if matches[2] == 'cmd' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled cmd")
				return lock_group_cmd(msg, data, target)
			end	
			if matches[2] == 'edit' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled edit")
				return lock_group_edit(msg, data, target)
			end						
			if matches[2] == 'emoji' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled emoji")
				return lock_group_emoji(msg, data, target)
			end
			if matches[2] == 'media' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled media")
				return lock_group_media(msg, data, target)
			end
			if matches[2] == 'clibot' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled clibot")
				return lock_group_clibot(msg, data, target)
			end			
			if matches[2] == 'unsp' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled unsp")
				return lock_group_unsp(msg, data, target)
			end
			if matches[2] == 'security' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled security")
				return lock_group_security(msg, data, target)
			end			
			if matches[2] == 'reply' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled reply")
				return lock_group_reply(msg, data, target)
			end					
			if matches[2] == 'bots' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled bots")
				return lock_group_bots(msg, data, target)
			end
			if matches[2] == 'operator' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled operator")
				return lock_group_operator(msg, data, target)
			end
		end

		if matches[1] == 'unlock' and is_momod(msg) then
			local target = msg.to.id
			     if matches[2] == 'all' then
      	local dsafemode ={
        unlock_group_links(msg, data, target),
		unlock_group_tag(msg, data, target),
		unlock_group_spam(msg, data, target),
		unlock_group_flood(msg, data, target),
		unlock_group_arabic(msg, data, target),
		unlock_group_membermod(msg, data, target),
		unlock_group_rtl(msg, data, target),
		unlock_group_tgservice(msg, data, target),
		unlock_group_sticker(msg, data, target),
		unlock_group_contacts(msg, data, target),
		unlock_group_fwd(msg, data, target),
		unlock_group_emoji(msg, data, target),
		unlock_group_media(msg, data, target),
		unlock_group_clibot(msg, data, target),		
		unlock_group_unsp(msg, data, target),
		unlock_group_security(msg, data, target),		
		unlock_group_reply(msg, data, target),		
		unlock_group_cmd(msg, data, target),
		unlock_group_edit(msg, data, target),		
		unlock_group_bots(msg, data, target),
		unlock_group_operator(msg, data, target),
      	}
      	return unlock_group_all(msg, data, target), dsafemode
      end
			if matches[2] == 'links' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled link posting")
				return unlock_group_links(msg, data, target)
			end
			if matches[2] == 'tag' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled tag")
				return unlock_group_tag(msg, data, target)
			end			
			if matches[2] == 'spam' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled spam")
				return unlock_group_spam(msg, data, target)
			end
			if matches[2] == 'flood' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled flood")
				return unlock_group_flood(msg, data, target)
			end
			if matches[2] == 'arabic' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled Arabic")
				return unlock_group_arabic(msg, data, target)
			end
			if matches[2] == 'member' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled member ")
				return unlock_group_membermod(msg, data, target)
			end                   
			if matches[2]:lower() == 'rtl' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled RTL chars. in names")
				return unlock_group_rtl(msg, data, target)
			end
				if matches[2] == 'tgservice' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled tgservice actions")
				return unlock_group_tgservice(msg, data, target)
			end
			if matches[2] == 'sticker' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled sticker posting")
				return unlock_group_sticker(msg, data, target)
			end
			if matches[2] == 'contacts' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled contact posting")
				return unlock_group_contacts(msg, data, target)
			end
			if matches[2] == 'strict' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled disabled strict settings")
				return disable_strict_rules(msg, data, target)
			end
			if matches[2] == 'fwd' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled fwd")
				return unlock_group_fwd(msg, data, target)
			end
			if matches[2] == 'cmd' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled cmd")
				return unlock_group_cmd(msg, data, target)
			end	
			if matches[2] == 'edit' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled edit")
				return unlock_group_edit(msg, data, target)
			end						
			if matches[2] == 'emoji' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled disabled emoji")
				return unlock_group_emoji(msg, data, target)
			end
			if matches[2] == 'media' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled media")
				return unlock_group_media(msg, data, target)
			end
			if matches[2] == 'clibot' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled clibot")
				return unlock_group_clibot(msg, data, target)
			end			
			if matches[2] == 'unsp' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled unsp")
				return unlock_group_unsp(msg, data, target)
			end
			if matches[2] == 'security' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled security")
				return unlock_group_security(msg, data, target)
			end			
			if matches[2] == 'reply' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Disabled reply")
				return unlock_group_reply(msg, data, target)
			end						
			if matches[2] == 'bots' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled bots")
				return unlock_group_bots(msg, data, target)
			end
			if matches[2] == 'operator' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] Enabled operator")
				return unlock_group_operator(msg, data, target)
			end
		end
		if matches[1] == 'remnewowner' then
			if is_owneronly(msg) then
			if msg.reply_id then
				get_message(msg.reply_id, remowner_by_reply, false)
			end
			if is_id(matches[2]) then
				chat_type = msg.to.type
				chat_id = msg.to.id
				user_id = matches[2]
				user_info('user#id'..user_id, set_remowner, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
			else
				chat_type = msg.to.type
				chat_id = msg.to.id
				local member = string.gsub(matches[3], '@', '')
	           	resolve_username(member, remowner_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
			end
			else
				return 'Full Owner Only'
			end
		end
		if matches[1] == 'setflood' then
			if not is_momod(msg) then
				return
			end
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 200 then
				return "Wrong number,range is [1-200]"
			end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['flood_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] set flood to ["..matches[2].."]")
			return '-----------------------------\n<b>»Flood Has Been Set To: </b>»<code>'..matches[2]..'</code>«\n-----------------------------'
		end
     if matches[1] == 'setfloodtime' then
      if not is_momod(msg) then
        return
      end
      if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 200 then
        return "Wrong number,range is [1-200]"
      end
      redis:set('TIME:CHECK'..msg.to.id,matches[2])
      return '-----------------------------\n<b>»Flood Time Has Been Set To: </b>»<code>'..matches[2]..'</code>«\n-----------------------------'
    end
		if matches[1] == 'public' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == 'yes' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set group to: public")
				return set_public_membermod(msg, data, target)
			end
			if matches[2] == 'no' then
				savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: not public")
				return unset_public_membermod(msg, data, target)
			end
		end

		if matches[1] == 'mute' and is_owner(msg) then
			local chat_id = msg.to.id
			if matches[2] == 'audio' then
			local msg_type = 'Audio'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return '<code>'..msg_type..'</code><b> Has Been Muted</b>'
				else
					return '<b>SuperGroup Mute</b><code> '..msg_type..'</code> <b>Is Already On</b>'
				end
			end
			if matches[2] == 'photo' then
			local msg_type = 'Photo'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return '<code>'..msg_type..'</code><b> Has Been Muted</b>'
				else
					return '<b>SuperGroup Mute</b><code> '..msg_type..'</code> <b>Is Already On</b>'
				end
			end
			if matches[2] == 'video' then
			local msg_type = 'Video'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return '<code>'..msg_type..'</code><b> Has Been Muted</b>'
				else
					return '<b>SuperGroup Mute</b><code> '..msg_type..'</code> <b>Is Already On</b>'
				end
			end
			if matches[2] == 'gifs' then
			local msg_type = 'Gifs'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return '<code>'..msg_type..'</code><b> Has Been Muted</b>'
				else
					return '<b>SuperGroup Mute</b><code> '..msg_type..'</code> <b>Is Already On</b>'
				end
			end
			if matches[2] == 'documents' then
			local msg_type = 'Documents'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return '<code>'..msg_type..'</code><b> Has Been Muted</b>'
				else
					return '<b>SuperGroup Mute</b><code> '..msg_type..'</code> <b>Is Already On</b>'
				end
			end
			if matches[2] == 'text' then
			local msg_type = 'Text'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return '<code>'..msg_type..'</code><b> Has Been Muted</b>'
				else
					return '<b>Mute </b><code>'..msg_type..'</code><b> Is Already On</b>'
				end
			end
			if matches[2] == 'all' then
			local msg_type = 'All'
				if not is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: mute "..msg_type)
					mute(chat_id, msg_type)
					return 'Mute '..msg_type..'  Has Been Enabled'
				else
					return '<b>Mute </b><code>'..msg_type..'</code><b> Is Already On</b>'
				end
			end
		end
		if matches[1] == 'unmute' and is_momod(msg) then
			local chat_id = msg.to.id
			if matches[2] == 'audio' then
			local msg_type = 'Audio'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return '<code>'..msg_type..'</code> <b>Has Been UnMuted</b>'
				else
					return '<b>Mute</b><code> '..msg_type..'</code><b>Is Already Off</b>'
				end
			end
			if matches[2] == 'photo' then
			local msg_type = 'Photo'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return '<code>'..msg_type..'</code> <b>Has Been UnMuted</b>'
				else
					return '<b>Mute</b><code> '..msg_type..'</code><b>Is Already Off</b>'
				end
			end
			if matches[2] == 'video' then
			local msg_type = 'Video'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return '<code>'..msg_type..'</code> <b>Has Been UnMuted</b>'
				else
					return '<b>Mute</b><code> '..msg_type..'</code><b>Is Already Off</b>'
				end
			end
			if matches[2] == 'gifs' then
			local msg_type = 'Gifs'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return '<code>'..msg_type..'</code><b> Have Been UnMuted</b>'
				else
					return '<b>Mute</b><code> '..msg_type..'</code><b>Is Already Off</b>'
				end
			end
			if matches[2] == 'documents' then
			local msg_type = 'Documents'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return '<code>'..msg_type..'</code><b> Have Been UnMuted</b>'
				else
					return '<b>Mute</b><code> '..msg_type..'</code><b>Is Already Off</b>'
				end
			end
			if matches[2] == 'text' then
			local msg_type = 'Text'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute message")
					unmute(chat_id, msg_type)
					return '<code>'..msg_type..'</code> <b>Has Been UnMuted</b>'
				else
					return '<b>Mute text Is Already Off</b>'
				end
			end
			if matches[2] == 'all' then
			local msg_type = 'All'
				if is_muted(chat_id, msg_type..': yes') then
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] set SuperGroup to: unmute "..msg_type)
					unmute(chat_id, msg_type)
					return '<b>Mute</b> <code>'..msg_type..'</code> <b>Has Been Disabled</b>'
				else
					return '<b>Mute</b> <code>'..msg_type..'</code> <b>Is Already Disabled</b>'
				end
			end
		end


		if matches[1]:lower() == "silent" and is_momod(msg) then
			local chat_id = msg.to.id
			local hash = "mute_user"..chat_id
			local user_id = ""
			if type(msg.reply_id) ~= "nil" then
				local receiver = get_receiver(msg)
				muteuser = get_message(msg.reply_id, silentuser_by_reply, {receiver = receiver, msg = msg})
			elseif matches[1]:lower() == "silent" and string.match(matches[2], '^%d+$') then
				local user_id = matches[2]
				if is_muted_user(chat_id, user_id) then
					return '[<code>'..user_id..'</code>] <b>Is Already In List!</b>'
      end
				if is_momod(msg) then
					mute_user(chat_id, user_id)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] added ["..user_id.."] to the muted users list")
					return '[<code>'..user_id..'</code>] <b>Has Been Added To Silent List!</b>'
				end
			elseif matches[1]:lower() == "silent" and not string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, silentuser_by_username, {receiver = receiver, get_cmd = get_cmd, msg=msg})
			end
		end

		if matches[1]:lower() == "unsilent" and is_momod(msg) then
			local chat_id = msg.to.id
			local hash = "mute_user"..chat_id
			local user_id = ""
			if type(msg.reply_id) ~= "nil" then
				local receiver = get_receiver(msg)
				muteuser = get_message(msg.reply_id, unsilentuser_by_reply, {receiver = receiver, msg = msg})
			elseif matches[1]:lower() == "unsilent" and string.match(matches[2], '^%d+$') then
				local user_id = matches[2]
				if is_muted_user(chat_id, user_id) then
					unmute_user(chat_id, user_id)
					savelog(msg.to.id, name_log.." ["..msg.from.id.."] removed ["..user_id.."] from the muted users list")
					return '[<code>'..user_id..'</code>] <b>Removed From Silent List</b>'
    else
					return '[<code>'..user_id..'</code>] <b>Is Not Silented</b>'
				end
			elseif matches[1]:lower() == "unsilent" and not string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, unsilentuser_by_username, {receiver = receiver, msg=msg})
			end
		end

		if matches[1]:lower() == "mutelist" and is_momod(msg) then
			local target = msg.to.id
			if not has_mutes(target) then
				set_mutes(target)
				return show_supergroup_mutes(msg, target)
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup muteslist")
			return show_supergroup_mutes(msg, target)
		end
		if matches[1]:lower() == "silentlist" and is_momod(msg) then
			local chat_id = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup mutelist")
			local hash =  'mute_user:'..msg.to.id
	        local list = redis:smembers(hash)
         	local text = '<b>List Of Silent Users</b>[<code>'..msg.to.id..'</code>]:\n'
         	for k,v in pairsByKeys(list) do
  	    	local user_info = redis:hgetall('user:'..v)
	    	if user_info and user_info.print_name then
			local print_name = string.gsub(user_info.print_name, "_", " ")
			local print_name = string.gsub(print_name, "‮", "")
			text = text..k.." - "..print_name.." ["..v.."]\n"
		else
		text = text..k.." - [ "..v.." ]\n"
	        end
        end
        return text

		end

		if matches[1] == "muteslist" and is_momod(msg) then
			local chat_id = msg.to.id
			if not has_mutes(chat_id) then
				set_mutes(chat_id)
				return mutes_list(chat_id)
			end
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup Muteslist")
			return mutes_list(chat_id)
		end
		if matches[1] == "silentlist" and is_momod(msg) then
			local chat_id = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup Mutelist")
			return muted_user_list(chat_id)
		end

		if matches[1] == 'settings' and is_momod(msg) then
			local target = msg.to.id
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested SuperGroup settings ")
			return show_supergroup_settingsmod(msg, target)
		end

		if matches[1] == 'rules' then
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] requested group rules")
			return get_rules(msg, data)
		end

		if matches[1] == 'help' and not is_owner(msg) then
			text = "\n"
			reply_msg(msg.id, text, ok_cb, false)
		elseif matches[1] == 'help' and is_owner(msg) then
			local name_log = user_print_name(msg.from)
			savelog(msg.to.id, name_log.." ["..msg.from.id.."] Used /superhelp")
			return super_help()
		end
		if matches[1] == 'ownerlist' and is_momod(msg) then
			local chan = ("%s#id%s"):format(msg.to.type, msg.to.id)
			channel_get_users(chan, owners_channel, {chat_id=msg.to.id})
		end
		if matches[1] == 'setnewowner' then
			if is_owneronly(msg) then
				if msg.reply_id then
					get_message(msg.reply_id, owner_by_reply, false)
				end
				if not matches[2]:match("@") then
					chat_type = msg.to.type
					chat_id = msg.to.id
					user_id = tonumber(matches[2])
					user_info('user#id'..user_id, set_owner, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
				else
					chat_type = msg.to.type
					chat_id = msg.to.id
					local member = string.gsub(matches[2], '@', '')
					resolve_username(member, owner_by_username, {chat_id=chat_id, member=member, chat_type=chat_type})
				end
			else
				return 'Full Owner Only'
			end
		end
		
		if matches[1] == 'peer_id' and is_admin1(msg)then
			text = msg.to.peer_id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		if matches[1] == 'msg.to.id' and is_admin1(msg) then
			text = msg.to.id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		--Admin Join Service Message
		if msg.service then
		local action = msg.action.type
			if action == 'chat_add_user_link' then
				if is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					savelog(msg.to.id, name_log.." Admin ["..msg.from.id.."] joined the SuperGroup via link")
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.from.id) and not is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					savelog(msg.to.id, name_log.." Support member ["..msg.from.id.."] joined the SuperGroup")
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
			if action == 'chat_add_user' then
				if is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					savelog(msg.to.id, name_log.." Admin ["..msg.action.user.id.."] added to the SuperGroup by [ "..msg.from.id.." ]")
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.action.user.id) and not is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					savelog(msg.to.id, name_log.." Support member ["..msg.action.user.id.."] added to the SuperGroup by [ "..msg.from.id.." ]")
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
		end
		if matches[1] == 'msg.to.peer_id' then
			post_large_msg(receiver, msg.to.peer_id)
		end
	end
end

local function pre_process(msg)
  if not msg.text and msg.media then
    msg.text = '['..msg.media.type..']'
  end
  return msg
end

return {
  patterns = {
	"^[#!/]([Aa]dd)$",
	"^[#!/]([Rr]em)$",
	"^[#!/]([Mm]ove) (.*)$",
	"^[#!/]([Gg]pinfo)$",
	"^[#!/]([Aa]dmins)$",
	"^[#!/]([Oo]wner)$",
	"^[#!/]([Mm]odlist)$",
	"^[#!/]([Bb]ots)$",
	"^[#!/]([Ww]ho)$",
	"^[#!/]([Kk]icked)$",
    "^[#!/]([Bb]lock) (.*)",
	"^[#!/]([Bb]lock)",
	"^[#!/]([Kk]ick) (.*)",
	"^[#!/]([Kk]ick)",
	"^[#!/]([Tt]osuper)$",
	"^[#!/]([Ii][Dd])$",
	"^[#!/]([Ii][Dd]) (.*)$",
	"^[#!/]([Kk]ickme)$",
	"^[#!/]([Nn]ewlink)$",
	"^[#!/]([Ss]etlink)$",
	"^[#!/]([Ll]ink)$",
	"^[#!/]([Rr]es) (.*)$",
	"^[#!/]([Ss]etadmin) (.*)$",
	"^[#!/]([Ss]etadmin)",
	"^[#!/]([Dd]emoteadmin) (.*)$",
	"^[#!/]([Dd]emoteadmin)",
	"^[#!/]([Ss]etowner) (.*)$",
	"^[#!/]([Ss]etowner)$",
	"^[#!/]([Pp]romote) (.*)$",
	"^[#!/]([Pp]romote)",
	"^[#!/]([Dd]emote) (.*)$",
	"^[#!/]([Dd]emote)",
	"^[#!/]([Ss]etname) (.*)$",
	"^[#!/]([Ss]etabout) (.*)$",
	"^[#!/]([Ss]etrules) (.*)$",
	"^[#!/]([Ss]etphoto)$",
	"^[#!/]([Ss]etusername) (.*)$",
	"^[#!/]([Dd]el)$",
	"^[#!/]([Ll]ock) (.*)$",
	"^[#!/]([Uu]nlock) (.*)$",
	"^[#!/]([Mm]ute) ([^%s]+)$",
	"^[#!/]([Uu]nmute) ([^%s]+)$",
	"^[#!/]([Ss]ilent)$",
	"^[#!/]([Ss]ilent) (.*)$",
	"^[#!/]([Uu]nsilent)$",
	"^[#!/]([Uu]nsilent) (.*)$",
	"^[#!/]([Pp]ublic) (.*)$",
	"^[#!/]([Ss]ettings)$",
	"^[#!/]([Rr]ules)$",
  "^[#!/]([Ss]etflood) (%d+)$",
  "^[#!/]([Ss]etfloodtime) (%d+)$",
	"^[#!/]([Cc]lean) (.*)$",
	"^[#!/]([Hh]elp)$",
	"^[#!/]([Ss]ilentlist)$",
	"^[#!/]([Mm]utelist)$",
    "^[#!/](setmod) (.*)",
	"^[#!/](remmod) (.*)",
    "^(.*)$",
	"msg.to.peer_id",
	"%[(document)%]",
	"%[(photo)%]",
	"%[(video)%]",
	"%[(audio)%]",
	"%[(contact)%]",
	"^!!tgservice (.+)$",
  },
  run = run,
  pre_process = pre_process
}
