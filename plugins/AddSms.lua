local function reload_plugins()
  plugins = {}
  load_plugins()
end
function is_botowner(msg)
  local var = false
  local admins = {161141712}
  for k,v in pairs(admins) do
    if msg.from.id == v then
      var = true
    end
  end
  return var
end
local function is_sudouser( id )
  for k,v in pairs(_config.sms_users) do
    if id == v then
      return k
    end
  end
 -- If not found
  return false
  end
local function run(msg, matches)
  if is_botowner(msg) then
    local user = tonumber(matches[2])
    if is_sms_user(user) then
      return "Already is sms users"
    else
      if matches[1]:lower() == "addsms" then
        table.insert(_config.sms_users, user)
        print(matches[2]..' added to sms users')
        save_config()
        reload_plugins(true)
        return matches[2]..' added to sms users'
      elseif matches[1]:lower() == "remsms" then
        table.remove(_config.sms_users, user)
        print(matches[2]..' removed from sms users')
        save_config()
        reload_plugins(true)
        return matches[2]..' removed from sms users'
      end
    end
  end
end
return {
patterns = {
"^[!/#]([Aa]ddsms) (%d+)$",
"^[!/#]([Rr]emsms) (%d+)$"
  },
  run = run
}