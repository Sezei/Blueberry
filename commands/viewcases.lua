-- Return the command function for the bot to run so it can be called by the bot
return {
    Run = function(env, message, args, client)
        -- Get cases from the guild
        local cases = env.Quickdb:Get("cases");
        if cases == nil then
            cases = {};
        end

        -- Get the cases specific for the guild id
        local guildCases = cases[message.guild.id];
        if guildCases == nil then
            guildCases = {};
        end

        -- Construct the cases into a string so it can be displayed in the embed
        local caseString = "";
        for k, v in pairs(guildCases) do
            caseString = caseString .. "\n**Case " .. k .. "**: " .. v.action .. " @ " .. os.date("%c", v.time) .. "\n";
        end

        -- Return 'Nothing to see here' if there are no cases
        if caseString == "" then
            caseString = "Nothing to see here.";
        end

        -- Send the embed with the cases
        return {
            embed = {
                title = "Cases",
                description = caseString,
                color = env.config.accentColor,
            }
        };
    end;
    Name = "viewcases";
    Description = "Lists all of the moderation cases that have been made in the guild.";
    Usage = "";
    Aliases = {"moderationcases", "modcases", "cases"};
    Permission = "kickMembers";
    BotOwnerOnly = false;
    GuildOwnerOnly = false;
    Enabled = true;
    Category = "Moderation";
}