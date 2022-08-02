-- Return the command function for the bot to run so it can be called by the bot
return {
    Run = function(env, message, args, client)
        if not message.guild.me:hasPermission('manageRoles') then
            return '❌ I can\'t manage roles!';
        end
        local author = message.guild:getMember(message.author.id)
        if not message.mentionedUsers.first then return "❌ You must provide a user to mute!" end;
        local user = message.guild:getMember(message.mentionedUsers.first.id)
        if user == nil then return "❌ You must provide a user to mute!" end;
        
        if author.highestRole.position <= user.highestRole.position and author.guild.owner.id ~= author.id then -- Skip the role check if the author is the owner of the server or if the author is the same role as the user
            message:reply('❌ You are unable to mute '..user.mentionString..' as their role is higher than or equals to yours!')
            return
        end

        if message.guild.me.highestRole.position <= user.highestRole.position then -- Same as above, but for the bot (no point in attempting to kick the user if the bot is unable to do so in the first place)
            message:reply('❌ I am unable to mute '..user.mentionString..' as their role is higher than or equals to mine!')
            return
        end
        
        local reason = "No reason provided was provided.";
        if #args > 2 then
            reason = table.concat(args, " ", 3);
        end
        
        -- Find and give the muted role to the target user, or create one if one doesn't already exist
        local muteroles = message.guild:getRole(env.Quickdb:Get("mutedroles"));
        if muteroles == nil then
            muteroles = {};
        end
        if muteroles[message.guild.id] == nil then
            muteroles[message.guild.id] = message.guild:createRole({name = "Muted", permissions = 0});
            muteroles[message.guild.id]:disableAllPermissions();
            muteroles[message.guild.id]:disableMentioning();
            env.Quickdb:Set("mutedroles", muteroles);
            env.AssignCase(message.guild, author.user.tag.." created mute role with ID "..muteroles[message.guild.id].id)
        end
        user:addRole(muteroles[message.guild.id]);

        return {
            embed = {
                title = "✅ Successfully muted "..user.user.tag,
                fields = {
                    {name = "Mute invoker", value = author.user.tag, inline = true},
                    {name = "Mute reason", value = reason, inline = true},
                    {name = "Target", value = user.user.tag, inline = true},
                },
                color = env.config.successColor,
                timestamp = env.discordia.Date():toISO('T', 'Z'),
                footer = {
                    text = "Case #"..env.AssignCase(message.guild, author.user.tag.." muted "..user.user.tag .." for "..reason);
                }
            }
        }
    end;
    Name = "mute";
    Description = "Mutes a certain user.";
    Usage = "<mention> [reason]";
    Aliases = {};
    Permission = "kickMembers";
    BotOwnerOnly = false;
    GuildOwnerOnly = false;
    Enabled = true;
    Category = "Moderation";
}