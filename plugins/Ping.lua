local function run(msg, matches)
  if matches[1]:lower() == 'ping' and is_sudo(msg) then
     send_document(get_receiver(msg), "./stickers/Power.webp", ok_cb, false)
    return '\n●▬▬▬▬▬▬ᵏᶰᶤᵍʰᵗ ᵍᵘᵃʳᵈ▬▬▬▬▬▬●\n<b>Now Knight Guard Is Powerful </b>\n●▬▬▬▬▬▬ᶤˢ ᵖᵒʷᵉʳᶠᵘˡ▬▬▬▬▬▬●'
  end
end
return {
  patterns = {
    "^[#!/]([Pp]ing)$",
    "^([Pp]ing)$",
  }, 
  run = run 
}
--edited by mohammadwh
--@Sudo_Knight_Guard
--my channel bot:@Knight_Team