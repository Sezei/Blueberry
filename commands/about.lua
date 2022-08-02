-- Return the command function for the bot to run so it can be called by the bot
return {
    Run = function(env, message, args, client)
        -- The command does not do anything other than return an embed message showing information about the bot
        local commandamount = 0;
        for k, v in pairs(env.commands) do
            commandamount = commandamount + 1;
        end;
        return {
            embed = {
                title = "About me!";
                -- If you plan to make a full bot, you will need to change the description to show the bot's actual capabilities, since by default it uses my own description for it.
                description = "I am a bot made by [Sezei#3061](https://discord.com/users/274598834070618112) for moderation.\n\nI was made using LuaJIT and Luvit using Github's Copilot.";
                fields = {
                    {
                        name = "Total Commands";
                        value = tostring(commandamount);
                        inline = true;
                    };
                    {
                        name = "Version";
                        value = env.config.version;
                        inline = true;
                    };
                    {
                        name = "Invite Link";
                        value = "[Click me!](https://discord.com/oauth2/authorize?client_id="..client.user.id.."&permissions=1099780139062&scope=bot)";
                    };
                    {
                        name = "Support Server";
                        value = "[Click me!](https://discord.com/invite/"..env.config.supportServer..")";
                    };
                };
                footer = {
                    text = client.user.Name.." | Hosted by "..env.config.ownerTag.." | Based on [Blueberry](https://github.com/Sezei/Blueberry)";
                };
                color = env.config.accentColor;
            }
        }
    end;
    Name = "about";
    Description = "Shows information about the bot";
    Usage = "";
    Aliases = {};
    Permission = "none";
    BotOwnerOnly = false;
    GuildOwnerOnly = false;
    Enabled = true;
    Category = "General";
}