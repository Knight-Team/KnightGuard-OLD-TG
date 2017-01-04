local function is_id(name_id)
	local var = tonumber(name_id)
	if var then
		return true
	else
		return false
	end
end
local function owner_by_username(cb_extra, success, result)
    local chat_type = cb_extra.chat_type
    local chat_id = cb_extra.chat_id
    local user_id = result.peer_id
    local user_name = result.username
    local hash = 'owner:'..chat_id..':'..user_id
    if redis:get(hash) then
    	if chat_type == 'chat' then
	        send_large_msg('chat#id'..chat_id, '<b>User </b><code>'..user_id..' </code><b>Is Already an Owner</b>', ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_large_msg('channel#id'..chat_id, '<b>User </b><code>'..user_id..'</code> <b>Is Already an Owner</b>', ok_cb, false)
	    end
	else
	    redis:set(hash, true)
	    if chat_type == 'chat' then
	        send_large_msg('chat#id'..chat_id, '<b>User </b> [<code>'..user_id..'</code>] <b>Is An Owner Now</b>', ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_large_msg('channel#id'..chat_id, '<b>User </b> [<code>'..user_id..'</code>] <b>Is An Owner Now</b>', ok_cb, false)
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
	        send_large_msg('chat#id'..chat_id, '<b>User </b><code>'..user_name..' </code><b>Removed From Group Owners</b>', ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_large_msg('channel#id'..chat_id, '<b>User </b><code>'..user_name..' </code><b>Removed From Group Owners</b>', ok_cb, false)
	    end
	else
	    if chat_type == 'chat' then
	        send_large_msg('chat#id'..chat_id, '<b>User </b><code>'..user_name..' </code><b>Was Not An Owner</b>', ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_large_msg('channel#id'..chat_id, '<b>User </b><code>'..user_name..' </code><b>Was Not An Owner</b>', ok_cb, false)
	    end
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
	        send_large_msg('chat#id'..chat_id, '<b>User </b><code>'..user_id..' </code><b>Is Already an Owner</b>', ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_large_msg('channel#id'..chat_id, '<b>User </b><code>'..user_id..' </code><b>Is Already an Owner</b>', ok_cb, false)
	    end
	else
    	redis:set(hash, true)
	    if cb_extra.chat_type == 'chat' then
	        send_large_msg('chat#id'..chat_id, '<b>User </b><code>'..user_id..' </code><b>Is an Owner Now</b>', ok_cb, false)
	    elseif cb_extra.chat_type == 'channel' then
	        send_large_msg('channel#id'..chat_id, '<b>User </b><code>'..user_id..' </code><b>Is an Owner Now</b>', ok_cb, false)
	    end
	end
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
	        send_large_msg('chat#id'..chat_id, '<b>User </b><code>'..result.print_name..' </code><b>Removed From Group Owners</b>', ok_cb, false)
	    elseif chat_type == 'channel' then
	        send_large_msg('channel#id'..chat_id, '<b>User </b><code>'..result.print_name..' </code><b>Removed From Group Owners</b>', ok_cb, false)
	    end
	else
	    if cb_extra.chat_type == 'chat' then
	        send_large_msg('chat#id'..chat_id, '<b>User </b><code>'..result.print_name..' </code><b>Was Not An Owner</b>', ok_cb, false)
	    elseif cb_extra.chat_type == 'channel' then
	        send_large_msg('channel#id'..chat_id, '<b>User </b><code>'..result.print_name..' </code><b>Was Not An Owner</b>', ok_cb, false)
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

local function remowner_by_reply(extra, success, result)
    local result = backward_msg_format(result)
    local msg = result
    local chat_id = msg.to.id
    local user_id = msg.from.id
    local chat_type = msg.to.type
    user_info('user#id'..user_id, set_remowner, {chat_type=chat_type, chat_id=chat_id, user_id=user_id})
end

local function owners_channel(extra, success, result)
	local chat_id = extra.chat_id
	local text = '<b>Group Owners:</b>\n'
	local compare = text
	for k,user in pairs(result) do
		if user.print_name then
			hash = 'owner:'..chat_id..':'..user.peer_id
			if redis:get(hash) then
				text = text..'●<b>|'..user.print_name..'| </b> <code>['..(user.username or 'Not Have')..'] </code> <i>['..user.peer_id..'] </i>\n'
			end
		end
	end
	if text == compare then
		text = text..'<i>No Owners Here</i>'
	end
	return send_large_msg('channel#id'..chat_id, text, ok_cb, true)
end

local function owners_chat(extra, success, result)
	local chat_id = extra.chat_id
	local text = '<b>Group Owners:</b>\n'
	local compare = text
	for k,user in pairs(result) do
		if user.print_name then
			hash = 'owner:'..chat_id..':'..user.peer_id
			if redis:get(hash) then
				text = text..'●<b>|'..user.print_name..'| </b> <code>['..(user.username or 'Not Have')..'] </code> <i>['..user.peer_id..'] </i>\n'
			end
		end
	end
	if text == compare then
		text = text..'<i>No Owners Here</i>'
	end
	return send_large_msg('chat#id'..chat_id, text, ok_cb, true)
end

local function run(msg, matches)
	user_id = msg.from.id
	chat_id = msg.to.id
	if matches[1] == 'setnewowner' then
		if is_owneronly(msg) then
			if msg.reply_id and not matches[2] then
				get_message(msg.reply_id, owner_by_reply, false)
			end
			if is_id(matches[2]) then
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
			return 'Leader Only'
		end
	elseif matches[1] == 'remowner' then
		if is_owneronly(msg) then
			if msg.reply_id and not matches[2] then
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
			return 'Leader Only'
		end
	elseif matches[1] == 'ownerlist' and is_momod(msg) then
		local chat_id = msg.to.id
		if msg.to.type == 'chat' then
			local receiver = 'chat#id'..msg.to.id
		    chat_info(receiver, owners_chat, {chat_id=chat_id})
		else
			local chan = ("%s#id%s"):format(msg.to.type, msg.to.id)
		    channel_get_users(chan, owners_channel, {chat_id=chat_id})
		end
    end
end



return {
  patterns = {
    "^[!/#](setnewowner)$",
	"^[!/#](remowner)$",
	"^[!/#](setnewowner) (.*)$",
	"^[!/#](remowner) (.*)$",
	"^[!/#](ownerlist)$",
  },
  run = run
}
