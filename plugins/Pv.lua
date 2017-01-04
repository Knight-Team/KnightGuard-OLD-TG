do   

local fwd_to = 1061877515  -- id realm chat or group normaly

local function callback_message(extra,success,result)
local receiver = result.to.id
local msg = extra
  if result.fwd_from and msg.text then
  fwd_msg(result.fwd_from.id, msg.id, ok_cb,false)
  else
    return nil
      end
  end
function run(msg, matches) 
  if msg.to.type == "user" and msg.text then
      if not msg.text then
    return "\nHi Welcom To"
	.."\n🔰Knight Guard🔰\n✽For See Super Group Help Send:\n/superhelp\n✽And For Contact Managers:\n》@KnightGuardBot\n->[MohammadWH @GodOfDevelopers]\n》@payamre3an_bot\n->[Reza Poker @P_u_k_e_r_a_m]\n✽For Get Support Link:\n/sup\n------------------------------------------------------\nسلام به ربات 🔰گارد شوالیه🔰 خوش امدید\n✽برای دیدن لیست دستورات سوپر گروه دستور زیر را ارسال کنید:\n/superhelp\n✽و برای تماس با مدیران:\n》@KnightGuardBot\n->[MohammadWH @GodOfDevelopers]\n》@payamre3an_bot\n->[Reza Poker @P_u_k_e_r_a_m]✽\nبرای دریافت لینک ساپورت دستور زیر را ارسال کنید:\n/sup\n------------------------------------------------------\nAbout Bot:\nدرباره ربات:\nNow You Talk To One Cli Bot\nFor More know About Cli Bot Open This Link:\nhttps://fa.wikipedia.org/wiki/Command-line_interface\nدر حال حاضر شما در حال صحبت با یک ربات  سی ال ای هستید\nبرای اطلاعات بیشتر درباره ربات های سی ال ای لینک زیر را باز کنید:\nhttps://fa.wikipedia.org/wiki/واسط_خط_فرمان"
      end
    fwd_msg("chat#id"..tonumber(fwd_to), msg.id,ok_cb,false)
return "\nHi Welcom To"
	.."\n🔰Knight Guard🔰\n✽For See Super Group Help Send:\n/superhelp\n✽And For Contact Managers:\n》@KnightGuardBot\n->[MohammadWH @GodOfDevelopers]\n》@payamre3an_bot\n->[Reza Poker @P_u_k_e_r_a_m]\n✽For Get Support Link:\n/sup\n------------------------------------------------------\nسلام به ربات 🔰گارد شوالیه🔰 خوش امدید\n✽برای دیدن لیست دستورات سوپر گروه دستور زیر را ارسال کنید:\n/superhelp\n✽و برای تماس با مدیران:\n》@KnightGuardBot\n->[MohammadWH @GodOfDevelopers]\n》@payamre3an_bot\n->[Reza Poker @P_u_k_e_r_a_m]✽\nبرای دریافت لینک ساپورت دستور زیر را ارسال کنید:\n/sup\n------------------------------------------------------\nAbout Bot:\nدرباره ربات:\nNow You Talk To One Cli Bot\nFor More know About Cli Bot Open This Link:\nhttps://fa.wikipedia.org/wiki/Command-line_interface\nدر حال حاضر شما در حال صحبت با یک ربات  سی ال ای هستید\nبرای اطلاعات بیشتر درباره ربات های سی ال ای لینک زیر را باز کنید:\nhttps://fa.wikipedia.org/wiki/واسط_خط_فرمان"
elseif msg.text and msg.reply_id and tonumber(msg.to.id) == fwd_to then
    if not msg.text then
    return "\nHi Welcom To"
	.."\n🔰Knight Guard🔰\n✽For See Super Group Help Send:\n/superhelp\n✽And For Contact Managers:\n》@KnightGuardBot\n->[MohammadWH @GodOfDevelopers]\n》@payamre3an_bot\n->[Reza Poker @P_u_k_e_r_a_m]\n✽For Get Support Link:\n/sup\n------------------------------------------------------\nسلام به ربات 🔰گارد شوالیه🔰 خوش امدید\n✽برای دیدن لیست دستورات سوپر گروه دستور زیر را ارسال کنید:\n/superhelp\n✽و برای تماس با مدیران:\n》@KnightGuardBot\n->[MohammadWH @GodOfDevelopers]\n》@payamre3an_bot\n->[Reza Poker @P_u_k_e_r_a_m]✽\nبرای دریافت لینک ساپورت دستور زیر را ارسال کنید:\n/sup\n------------------------------------------------------\nAbout Bot:\nدرباره ربات:\nNow You Talk To One Cli Bot\nFor More know About Cli Bot Open This Link:\nhttps://fa.wikipedia.org/wiki/Command-line_interface\nدر حال حاضر شما در حال صحبت با یک ربات  سی ال ای هستید\nبرای اطلاعات بیشتر درباره ربات های سی ال ای لینک زیر را باز کنید:\nhttps://fa.wikipedia.org/wiki/واسط_خط_فرمان"
      end
    get_message(msg.reply_id, callback_message, msg)
    end
end
return {               
patterns = {
"^(.*)$",
 }, 
run = run,
}
end