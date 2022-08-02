-- Return the command function for the bot to run so it can be called by the bot
return {
    Run = function(env, message, args, client)
        return "Pong!";
    end;
    Name = "ping";
    Description = "Pongs!";
    Usage = "";
    Aliases = {};
    Permission = "none";
    BotOwnerOnly = false;
    GuildOwnerOnly = false;
    Enabled = true;
    Category = "General";
}