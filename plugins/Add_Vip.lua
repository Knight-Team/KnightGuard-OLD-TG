function run(msg,matches)
  if is_admin1(msg) and matches[1] == 'adding' then
    redis:sadd("VIP:GROUPS",msg.to.id)
    return "VIP Group Added"
  end
  if is_admin1(msg) and matches[1] == 'reming' then
     redis:del("VIP:GROUPS",msg.to.id)
    return "VIP Group Removed"
  end
end
return {
  patterns = {
    "^[!/#]([Aa]dding) ([Vv]ip)$",
    "^[!/#]([Rr]eming) ([Vv]ip)$",
  },
  run = run
}