-- Return the command function for the bot to run so it can be called by the bot
return {
    Run = function(env, message, args, client)
        -- Get all commands from the environment
        local commands = env.commands;
        local runnablecommands = {};

        -- Check which permissions the user who called the command has
        -- If the second argument is "-all" or "-a" then show all of the commands
        if not args[2] then args[2] = "" end;
        if string.lower(args[2]) == "-all" or string.lower(args[2]) == "-a" then
            for _,v in pairs(commands) do
                if v.Enabled then
                    table.insert(runnablecommands, v);
                end
            end
        else
            for _,v in pairs(commands) do
                if env.CanRun(v.Name,message.member) and v.Enabled then
                    table.insert(runnablecommands,v);
                end
            end
        end

        -- Sort the commands by category
        local sortedcommands = {};
        for _,v in pairs(runnablecommands) do
            if sortedcommands[v.Category] == nil then
                sortedcommands[v.Category] = {};
            end
            table.insert(sortedcommands[v.Category],v);
        end

        -- Parse the commands into a string
        local commandstring = "";
        for k,v in pairs(sortedcommands) do
            commandstring = commandstring .. "\n**" .. k .. "**\n";
            for _,v2 in pairs(v) do
                if v2.Usage ~= "" then
                    commandstring = commandstring .. "`" .. v2.Name .. "` ".. v2.Usage .." - " .. v2.Description .. "\n";
                else
                    commandstring = commandstring .. "`" .. v2.Name .. "` - " .. v2.Description .. "\n";
                end
            end
        end

        -- Create the embed for the help command
        return {
            embed = {
                title = "List of runnable commands";
                description = commandstring;
                color = env.config.accentColor;
            }
        }
    end;
    Name = "commands";
    Description = "List all of the commands that you can use from the bot.";
    Usage = "";
    Aliases = { "commands", "help", "cmdslist", "cmdlist", "cmdshelp", "cmdhelp" };
    Permission = "none";
    BotOwnerOnly = false;
    GuildOwnerOnly = false;
    Enabled = true;
    Category = "General";
}