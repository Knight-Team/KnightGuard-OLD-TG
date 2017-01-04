do
    local function run(msg, matches)
    local support = '1054786249' -- آیدی ساپورت بات رو اینجا قرار دهید
    local data = load_data(_config.moderation.data)
    local name_log = user_print_name(msg.from)
        if matches[1] == 'sup' then
        local group_link = data[tostring(support)]['settings']['set_link']
    return "⚜ساپورت تیم Knight⚜:\n"..group_link
    end
end
return {
    patterns = {
    "^[!/#](sup)$",
    "^(sup)$",
     },
    run = run
}
end