-- Return the command function for the bot to run so it can be called by the bot
return {
    Run = function(env, message, args, client)
        -- Check if the bot has the permission to change slowmode of the channels
        if not message.guild.me:hasPermission('manageChannels') then
            return '❌ I can\'t manage channels!';
        end
        -- Get the current channel of the message
        local channel = message.channel;
        -- Check if the user provided the amount of seconds to set the slowmode to
        if args[2] then
            -- Check if the user provided a valid amount of seconds
            if not tonumber(args[2]) and not args[2] == "off" then
                return '❌ You must provide a valid amount of seconds for slowmode!';
            end

            if args[2] == "off" then
                args[2] = 0;
            end
            
            -- Set the slowmode of the channel to the amount of seconds provided
            channel:setRateLimit(tonumber(args[2]));
            -- Return a success embed to the user
            return {
                embed = {
                    title = "✅ Successfully set slowmode to "..args[2].." seconds!",
                    fields = {
                        {name = "Slowmode invoker", value = message.author.tag, inline = true},
                        {name = "Target", value = channel.name, inline = true},
                    },
                    color = env.config.successColor,
                    timestamp = env.discordia.Date():toISO('T', 'Z'),
                    footer = {
                        text = "Case #"..env.AssignCase(message.guild, message.author.tag.." set slowmode to "..args[2].." seconds on "..channel.name);
                    }
                }
            }
        else
            -- Return the current slowmode of the channel
            return 'Current slowmode of '..channel.name..' is '..channel.slowmode..' seconds.';
        end
    end;
    Name = "slowmode";
    Description = "Sets the slowmode of a channel";
    Usage = "<seconds>";
    Aliases = {"ratelimit", "slow"};
    Permission = "manageMessages";
    BotOwnerOnly = false;
    GuildOwnerOnly = false;
    Enabled = true;
    Category = "Moderation";
}