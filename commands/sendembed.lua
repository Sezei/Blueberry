-- Return the command function for the bot to run so it can be called by the bot
return {
    Run = function(env, message, args, client)
        -- Check if a channel was provided as the second argument
        if args[2] and tonumber(args[2]) then
            -- Check if the second argument can be decoded into a snowflakeId (needs to be a number)
            if tonumber(args[2]) then
                -- Attempt to get the channel from the provided snowflakeId
                local channel = client:getChannel(args[2]);

                -- Check if the channel was found
                if channel then
                    -- Check if the channel belongs to the same guild as the message
                    if channel.guild.id ~= message.guild.id then return "The channel provided is not in the same guild as the message." end;
                    -- Check if channel type is a TextChannel
                    if channel.type ~= 0 then return "The channel provided is not a text channel." end;
                    -- Get the guildchannel from the channel
                    channel = message.guild:getChannel(channel.id);

                    -- Build the embed from the string which is provided as the third and so on arguments
                    local str = table.concat(args, " ", 3);
                    local embed = {
                        description = str,
                        color = env.config.accentColor,
                        footer = {
                            text = "Sent by " .. message.author.tag,
                        }
                    };

                    -- Send the embed to the channel
                    channel:send({
                        embed = embed
                    });

                    -- Add a success reaction to the message since it was successful
                    message:addReaction("✅");
                else
                    return "The channel provided was not found."
                end
            else
                return "Argument 2 is not a valid snowflakeId."
            end
        else
            -- Skip all the checks since we already have the channel where it was sent from and build the embed from the string which is provided as the second and so on arguments
            local messagechannel = message.channel;
            local str = table.concat(args, " ", 2);
            messagechannel:send({
                embed = {
                    description = str,
                    color = env.config.accentColor,
                    footer = {
                        text = "Sent by " .. message.author.tag,
                    }
                }
            });
            message:delete();
        end
    end;
    Name = "sendembed";
    Description = "Sends an embed message to a certain channel.";
    Usage = "[channel] <text>";
    Aliases = { "embed" };
    Permission = "manageMessages";
    BotOwnerOnly = false;
    GuildOwnerOnly = false;
    Enabled = true;
    Category = "Moderation";
}