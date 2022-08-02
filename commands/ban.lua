-- Return the command function for the bot to run so it can be called by the bot
return {
    Run = function(env, message, args, client)
        if not message.guild.me:hasPermission('banMembers') then
            return '❌ I can\'t ban members!';
        end
        local author = message.guild:getMember(message.author.id)
        if not message.mentionedUsers.first then return "❌ You must provide a user to ban!" end;
        local user = message.guild:getMember(message.mentionedUsers.first.id)
        if user == nil then return "❌ You must provide a user to ban!" end;
        
        if author.highestRole.position <= user.highestRole.position and author.guild.owner.id ~= author.id then -- Skip the role check if the author is the owner of the server or if the author is the same role as the user
            message:reply('❌ You are unable to ban '..user.mentionString..' as their role is higher than or equals to yours!')
            return
        end

        if message.guild.me.highestRole.position <= user.highestRole.position then -- Same as above, but for the bot (no point in attempting to kick the user if the bot is unable to do so in the first place)
            message:reply('❌ I am unable to ban '..user.mentionString..' as their role is higher than or equals to mine!')
            return
        end
        
        local reason = "No reason provided was provided.";
        if #args > 3 then
            if tonumber(args[3]) then
                reason = table.concat(args, " ", 4);
            else
                reason = table.concat(args, " ", 3);
            end
        end

        if not tonumber(args[3]) then
            user:ban(reason.." | Banned by "..author.user.tag);
        else
            user:ban(reason.." | Banned by "..author.user.tag, tonumber(args[3]));
        end

        return {
            embed = {
                title = "✅ Successfully banned "..user.user.tag,
                fields = {
                    {name = "Ban invoker", value = author.user.tag, inline = true},
                    {name = "Ban reason", value = reason, inline = true},
                    {name = "Ban time", value = args[3], inline = true},
                    {name = "Target", value = user.user.tag, inline = true},
                },
                color = env.config.successColor,
                timestamp = env.discordia.Date():toISO('T', 'Z'),
                footer = {
                    text = "Case #"..env.AssignCase(message.guild, author.user.tag.." banned "..user.user.tag .." for "..reason..", for "..args[3].." days.");
                }
            }
        }
    end;
    Name = "ban";
    Description = "Bans a certain user from the guild.";
    Usage = "<mention> [days/inf] [reason]";
    Aliases = {};
    Permission = "banMembers";
    BotOwnerOnly = false;
    GuildOwnerOnly = false;
    Enabled = true;
    Category = "Moderation";
}