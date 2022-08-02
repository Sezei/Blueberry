-- Function for rounding numbers to a certain number of decimal places.
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

-- Return the command function for the bot to run so it can be called by the bot
return {
    Run = function(env, message, args, client)
        -- Start a timer for how long this command will run for using os.clock()
        local startTime = os.clock();
        -- Reload all of the commands for the bot by calling a function in start.lua using the env.reload function
        env.reload();
        -- Get the time it took to reload the commands
        local endTime = os.clock();
        -- Return the embed with the reload time
        return {
            embed = {
                title = "Reload",
                description = "Successfully reloaded all of the commands for the bot!\n\nTime taken: " .. round(endTime - startTime, 2) .. " seconds.",
                color = env.config.accentColor,
            }
        };
    end;
    Name = "reload";
    Description = "Reloads all of the commands for the bot.";
    Usage = "";
    Aliases = {};
    Permission = "administrator";
    BotOwnerOnly = true;
    GuildOwnerOnly = false;
    Enabled = true;
    Category = "Maintenance";
}