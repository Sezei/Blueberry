-- Return the command function for the bot to run so it can be called by the bot
return {
    Run = function(env, message, args, client)
        -- Set the game to whatever the user wants after the second argument
        local game = table.concat(args, " ", 2);
        -- Set the game for the bot
        client:setGame(game);
        
        -- Store the game in the quickdb so it can be set next time the bot is started
        env.Quickdb:Set("botgame", game);

        -- Return the embed with the game set
        return {
            embed = {
                title = "Done!",
                description = "Set the game for the bot to " .. game .. ".",
                color = env.config.accentColor,
            }
        };
    end;
    Name = "setgame";
    Description = "Sets the bot's game status.";
    Usage = "<game>";
    Aliases = {};
    Permission = "none";
    BotOwnerOnly = true;
    GuildOwnerOnly = false;
    Enabled = true;
    Category = "Maintenance";
}