-- Return the command function for the bot to run so it can be called by the bot
return {
    Run = function(env, message, args, client)
        -- Remove the first argument (the command name)
        table.remove(args, 1);
        -- Convert the arguments to a string
        local str = table.concat(args, " ");
        -- Compile the string to a function
        local func = loadstring(str);
        
        -- Check if the function compiled successfully, otherwise return an error embed
        if not func then
            return {
                embed = {
                    title = "Compilation Error",
                    description = "The script has failed to compile.",
                    color = env.config.errorColor,
                }
            };
        end

        -- Run the function with the environment of the bot in a protected environment (pcall)
        local success, result = pcall(function()
            return func(env, message, args, client);
        end)

        -- Return the result of the function in an embed
        if success then
            return {
                embed = {
                    title = "Evaluation Result",
                    description = result,
                    color = env.config.accentColor,
                }
            };
        else
            return {
                embed = {
                    title = "Evaluation Error",
                    description = "The script has failed to run due to an error.\n```" .. result .. "```",
                    color = env.config.errorColor,
                }
            };
        end
    end;
    Name = "eval";
    Description = "Evaluates Lua code";
    Usage = "<lua code>";
    Aliases = { "lua"};
    Permission = "administrator";
    BotOwnerOnly = true;
    GuildOwnerOnly = false;
    Enabled = true;
    Category = "Maintenance";
}