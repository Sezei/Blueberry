local fs = require('fs');
local discordia = require('discordia');
local client = discordia.Client();
local env = {
    config = {
        -- Bot owner stuff
        ownerID = "274598834070618112", -- Your Discord ID here;
        ownerTag = "Sezei#3061", -- Your Discord tag here;

        -- Bot stuff
        version = "beta_4", -- The version of the bot; Can be any string, will only show up in the about command.
        prefix = "-", -- Prefix for commands here;
        token = "", -- Your bot token here;
        supportServer = "yPurvHPcQb", -- Your support server link here (whatever the 'xxxxx' is in 'https://discord.gg/invite/xxxxx');
        accentColor = 0x1461e7, -- Accent color for the bot here;
        successColor = 0x00ff00, -- Color for success messages here;
        errorColor = 0xff0000, -- Color for error messages here;
    },
    discordia = discordia,
}; -- Create a shared environment for the bot commands

function table.clear(t)
    for k, _ in pairs(t) do
        t[k] = nil;
    end
end

-- Function to print everything in a table into the console
function print_r (t, indent)
    local indent = indent or '';
    for k,v in pairs(t) do
        local key = indent .. k;
        if type(v) == "table" then
            print(key .. ":");
            print_r(v, indent .. '\t');
        else
            print(key .. ": " .. v);
        end
    end
end

-- Get functions from the function folder and insert them into the env table; This saves amount of lines in the code by splitting the functions into separate files.
for _, file in pairs(fs.readdirSync('./functions')) do
    if file:find('.lua') then
        local func = require('./functions/' .. file);
        env[file:gsub('.lua', '')] = func;
    end
end

-- Key-Value type storage using the Storage class
env.Quickdb = {
    -- Set a value in the database
    Set = function(self, key, value)
        local data = env.Storage:Load();
        if not data then 
            env.Storage:Store({});
            data = env.Storage:Load();
        end;
        data[key] = value;
        env.Storage:Store(data);
    end,
    -- Get a value from the database
    Get = function(self, key)
        local data = env.Storage:Load();
        if not data then 
            env.Storage:Store({});
            return nil 
        end;
        return data[key];
    end,
    -- Clear a value from the database
    Clear = function(self, key)
        local data = env.Storage:Load();
        if not data then 
            env.Storage:Store({});
            return nil 
        end;
        data[key] = nil;
        env.Storage:Store(data);
    end,
    -- Boolean to check if a value is in the database
    Exists = function(self, key)
        local data = env.Storage:Load();
        if not data then 
            env.Storage:Store({});
            return nil 
        end;
        return data[key] ~= nil;
    end
}

-- Assign a case number for moderation commands
function env.AssignCase(guild,action)
    local cases = env.Quickdb:Get("cases");
    if cases == nil then
        cases = {};
    end;
    local caseNumber = 1;
    if cases and cases[guild.id] == nil then
        cases[guild.id] = {};
    end;
    caseNumber = #cases[guild.id] + 1;
    cases[guild.id][caseNumber] = {
        action = action,
        time = os.time(),
    };
    env.Quickdb:Set("cases",cases);
    return caseNumber;
end

-- Get all of the commands for the bot to run from the commands folder which is in the same directory as this file
-- Use the fs module to get the directory of the file and then get the files in that directory and store them in a table of required commands
-- Remove the .lua extension from the file name and store the command name in the table of required commands as the key and the command function as the value
env.commands = {};
env.aliases = {};
local files = fs.readdirSync('./commands');
for i, file in ipairs(files) do
    local command = string.lower(file:sub(1, -5));
    env.commands[command] = require('./commands/' .. file);
    for _,v in pairs(env.commands[command].Aliases) do
        env.aliases[v] = env.commands[command];
    end
end;

-- Function to check if the member can use the provided command
function env.CanRun(command,member)
    local cmd = env.commands[command] or env.aliases[command];

    -- If the command is disabled then return false, because the command is not runnable in the first place...
    if cmd.Enabled == false then
        return false
    end

    if cmd.BotOwnerOnly == true and member.id ~= env.config.ownerID then
        return false
    elseif cmd.BotOwnerOnly == true and member.id == env.config.ownerID then
        return true
    elseif cmd.GuildOwnerOnly == true and member.guild.owner.id ~= member.id then
        return false
    elseif cmd.GuildOwnerOnly == true and member.guild.owner.id == member.id then
        return true
    elseif cmd.Permission == "none" or member:hasPermission(cmd.Permission) then
        return true
    else
        return false
    end
end

-- Turn all of the commands into a table of functions that can be called by the bot so that the bot can run them
local commandTable = {};
for k, v in pairs(env.commands) do
    commandTable[k] = function(env, message, args, client)
        if env.CanRun(k,message.member) then
            return v.Run(env, message, args, client);
        else
            return "❌ You do not have permission to use this command!";
        end;
    end
end
for k,v in pairs(env.aliases) do
    commandTable[k] = function(env, message, args, client)
        if env.CanRun(k,message.member) then
            return v.Run(env, message, args, client);
        else
            return "❌ You do not have permission to use this command!";
        end;
    end
end

-- Function to reload all of the commands for the bot to run from the commands folder which is in the same directory as this file
-- Use the fs module to get the directory of the file and then get the files in that directory and store them in a table of required commands
-- Remove the .lua extension from the file name and store the command name in the table of required commands as the key and the command function as the value
function env.reload()
    table.clear(env.commands);
    table.clear(env.aliases);
    table.clear(commandTable);

    local files = fs.readdirSync('./commands');

    -- Loop through all of the files in the commands folder and add them to the commands table
    for i, file in ipairs(files) do
        local command = string.lower(file:sub(1, -5));
        env.commands[command] = require('./commands/' .. file);
        for _,v in pairs(env.commands[command].Aliases) do
            env.aliases[v] = env.commands[command];
        end
    end;

    for k, v in pairs(env.commands) do
        commandTable[k] = function(env, message, args, client)
            if env.CanRun(k,message.member) then
                return v.Run(env, message, args, client);
            else
                return "❌ You do not have permission to use this command!";
            end;
        end
    end

    for k,v in pairs(env.aliases) do
        commandTable[k] = function(env, message, args, client)
            if env.CanRun(k,message.member) then
                return v.Run(env, message, args, client);
            else
                return "❌ You do not have permission to use this command!";
            end;
        end
    end

    print("Reloaded!")
    return true;
end

function Split(str, delimiter)
    local result = {};
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

-- Function for when the message was created
function messageCreated(message)
    if message.author.bot then return end;
    if message.author.id == client.user.id then return end;
    local args = Split(message.content, " ");
    -- Get prefix length and remove it from the message
    if string.sub(args[1], 1, string.len(env.config.prefix)) ~= env.config.prefix then return end;

    if message.guild == nil then return end;
    local command = string.lower(string.sub(args[1], string.len(env.config.prefix) + 1));
    local commandFunction = commandTable[command];
    if commandFunction == nil then return end;
    local success,error = pcall(function()
        local response = commandFunction(env, message, args, client);
        if response ~= nil then
            message.channel:send(response);
        end
    end)
    if not success then
        print("An error has occurred attempting to run command "..command..":\n"..error);
        message.channel:send({
            content = "Whoops, an error has occurred trying to run this command. Please report the following error to "..env.config.ownerTag..":";
            embed = {
                title = "An exception has occurred with the command "..command,
                description = "```\n"..error.."\n```",
                color = env.config.errorColor,
            }
        });
    end
end

-- On message creation use the messageCreated function
client:on('messageCreate', messageCreated);

-- When the client is ready, print to console to confirm it's running
client:on('ready', function()
	print('Logged in as '.. client.user.username);
    -- Get the game status from the quickdb and set it to the client status, if it exists, otherwise don't set it
    client:setGame(env.Quickdb:Get("botgame") or "");
end);

-- Run the client
client:run('Bot '..env.config.token);