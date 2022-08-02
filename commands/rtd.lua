-- Return the command function for the bot to run so it can be called by the bot
return {
    Run = function(env, message, args, client)
        -- Get a random number between 1 and 6 if the user didn't provide a number as the second argument
        if not args[2] then
            args[2] = 6;
        end;
        -- Check if the user provided a valid number as the second argument
        if not tonumber(args[2]) then
            args[2] = 6;
        else
            args[2] = tonumber(args[2]);
        end;

        -- Return an embed containing the rolled dice
        return {
            embed = {
                title = "🎲 Dice Rolled!",
                fields = {
                    {name = "Sides", value = "🎲 "..args[2].." 🎲", inline = true},
                    {name = "Result", value = "🎲 "..math.random(1, args[2]).." 🎲", inline = true},
                },
                color = env.config.accentColor,
            }
        }
    end;
    Name = "rtd";
    Description = "Rolls a dice.";
    Usage = "[sides]";
    Aliases = {};
    Permission = "none";
    BotOwnerOnly = false;
    GuildOwnerOnly = false;
    Enabled = true;
    Category = "Fun";
}