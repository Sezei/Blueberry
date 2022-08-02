-- Return the command function for the bot to run so it can be called by the bot
return {
    Run = function(env, message, args, client)
        if not message.guild.me:hasPermission('manageRoles') then
            return '❌ I can\'t manage roles!';
        end

        local author = message.guild:getMember(message.author.id)

        local muterole = nil;

        -- Attempt to get the mute role ID in the server
        local muteroles = env.Quickdb:Get("mutedroles");
        if muteroles == nil then
            muteroles = {};
        end

        -- If the mute role ID is present as argument 2, we'll use that one instead of the one in the database
        if args[2] ~= nil then
            muterole = message.guild:getRole(args[2]);
        end

        -- Get all roles in the server
        local roles = message.guild.roles;

        -- Find the mute role in the server
        for _, role in pairs(roles) do
            if role.id == args[2] then
                muterole = role;
                break;
            end
        end

        -- If the mute role in the server wasn't found, try to find one by name
        if muterole == nil then
            for _, role in pairs(roles) do
                if role.name == args[2] then
                    muterole = role;
                    break;
                end
            end
        end

        -- If the mute role still wasn't found, attempt to force the 'Muted' name to be used
        if muterole == nil then
            for _, role in pairs(roles) do
                if role.name == "Muted" then
                    muterole = role;
                    break;
                end
            end
        end

        -- If the mute role wasn't found anyways, create the role and return an error message with the new role name and ID
        if muterole == nil then
            muterole = message.guild:createRole("Muted");
            muteroles[message.guild.id] = muterole;
            env.Quickdb:Set("mutedroles", muteroles);
            muterole:disableAllPermissions();
            muterole:disableMentioning();
            return {
                embed = {
                    title = "❗ Created a new mute role due to not being able to find the mute role.",
                    fields = {
                        {name = "Mute role Name", value = muterole.name, inline = true},
                        {name = "Mute role ID", value = muterole.id, inline = true},
                    },
                    color = env.config.accentColor,
                    timestamp = env.discordia.Date():toISO('T', 'Z'),
                    footer = {
                        text = "Case #"..env.AssignCase(message.guild, author.user.tag.." created mute role with ID "..muterole.id);
                    }
                }
            }
        end

        -- If the mute role was not found, return an error message
        if not muterole then
            return {
                embed = {
                    title = "❗ Mute role not found.",
                    color = env.config.errorColor,
                    timestamp = env.discordia.Date():toISO('T', 'Z'),
                }
            }
        end

        -- If the mute role was found, set it as the mute role in the server
        muteroles[message.guild.id] = muterole.id;
        env.Quickdb:Set("mutedroles", muteroles);

        -- Return a success message
        return {
            embed = {
                title = "✅ Mute role set!",
                fields = {
                    {name = "Mute role name", value = muterole.name, inline = true},
                    {name = "Mute role ID", value = muterole.id, inline = true},
                },
                color = env.config.successColor,
                timestamp = env.discordia.Date():toISO('T', 'Z'),
                footer = {
                    text = "Case #"..env.AssignCase(message.guild, author.user.tag.." set mute role to "..muterole.id);
                }
            }
        }
    end;
    Name = "setmuterole";
    Description = "Sets the mute role for the server.";
    Usage = "<roleID>";
    Aliases = {};
    Permission = "manageRoles";
    BotOwnerOnly = false;
    GuildOwnerOnly = false;
    Enabled = true;
    Category = "Moderation";
}