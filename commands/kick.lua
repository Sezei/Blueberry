-- Return the command function for the bot to run so it can be called by the bot
return {
    Run = function(env, message, args, client)
        if not message.guild.me:hasPermission('kickMembers') then
            return '❌ I can\'t kick members!';
        end
        local author = message.guild:getMember(message.author.id)
        if not message.mentionedUsers.first then return "❌ You must provide a user to kick!" end;
        local user = message.guild:getMember(message.mentionedUsers.first.id)
        if user == nil then return "❌ You must provide a user to kick!" end;
        
        if author.highestRole.position <= user.highestRole.position and author.guild.owner.id ~= author.id then -- Skip the role check if the author is the owner of the server or if the author is the same role as the user
            message:reply('❌ You are unable to kick '..user.mentionString..' as their role is higher than or equals to yours!')
            return
        end

        if message.guild.me.highestRole.position <= user.highestRole.position then -- Same as above, but for the bot (no point in attempting to kick the user if the bot is unable to do so in the first place)
            message:reply('❌ I am unable to kick '..user.mentionString..' as their role is higher than or equals to mine!')
            return
        end
        
        local reason = "No reason provided was provided.";
        if #args > 2 then
            reason = table.concat(args, " ", 3);
        end
        user:kick(reason.." | Kicked by "..author.user.tag);
        return {
            embed = {
                title = "✅ Successfully kicked "..user.user.tag,
                fields = {
                    {name = "Kick invoker", value = author.user.tag, inline = true},
                    {name = "Kick reason", value = reason, inline = true},
                    {name = "Target", value = user.user.tag, inline = true},
                },
                color = env.config.successColor,
                timestamp = env.discordia.Date():toISO('T', 'Z'),
                footer = {
                    text = "Case #"..env.AssignCase(message.guild, author.user.tag.." kicked "..user.user.tag .." for "..reason);
                }
            }
        }
    end;
    Name = "kick";
    Description = "Kicks a certain user from the guild.";
    Usage = "<mention> [reason]";
    Aliases = {};
    Permission = "kickMembers";
    BotOwnerOnly = false;
    GuildOwnerOnly = false;
    Enabled = true;
    Category = "Moderation";
}