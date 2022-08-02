-- Random Answers table with 8ball responses (from 8ball.lua)
local answers = {
    "It is certain",
    "It is decidedly so",
    "Without a doubt",
    "Yes definitely",
    "You may rely on it",
    "As I see it, yes",
    "Most likely",
    "Outlook good",
    "Yes",
    "Signs point to yes",
    "Reply hazy try again",
    "Ask again later",
    "Better not tell you now",
    "Cannot predict now",
    "Concentrate and ask again",
    "Don't count on it",
    "My reply is no",
    "My sources say no",
    "Outlook not so good",
    "Very doubtful",
    "Don't even ask",
    "I don't know",
    "I don't know if it's true or false",
    "I don't know if it's true or false, but I'm pretty sure it's true",
    "I don't know if it's true or false, but I'm pretty sure it's false",
    "I am not sure...",
    "This might be true",
    "This might be false",
    "You should ask someone else",
    "I am a ball, how do I know?",
    "I am a ball, how can I know?",
    "I am a ball, how do I know if it's true or false?",
    "You would need to ask someone else",
    "Looks like a yes.",
    "Looks like a no.",
    "Looks like a maybe.",
    "Looks like a maybe, but I'm not sure.",
    "Can't say for sure.",
    "Can't say for sure, but it is a yes.",
    "Can't say for sure, but it is a no.",
    "That's a 100% chance for a yes.",
    "That's a 100% chance for a no.",
    "That's a 50% chance for a yes.",
    "That's a 50% chance for a no.",
    "That's a 33% chance for a yes.",
    "That's a 33% chance for a no.",
    "You need to concentrate harder.",
    "You need to concentrate harder, but it's a yes.",
    "You need to concentrate harder, but it's a no.",
}

-- Return the command function for the bot to run so it can be called by the bot
return {
    Run = function(env, message, args, client)
        if args[2] == nil then
            return "You need to ask a question!";
        end
        local question = table.concat(args, " ", 2);
        -- Check if the question is an actual question by checking if it ends with a question mark
        if string.sub(question, -1) ~= "?" then
            return "You need to ask a question!";
        end
        -- Get a random answer from the answers table
        local answer = answers[math.random(1, #answers)];
        -- Return the answer in a fancy embed so it will look nice unlike the code snippet above (from 8ball.lua)
        return {
            embed = {
                title = "8ball",
                fields = {
                    {name = "Question", value = question, inline = true},
                    {name = "Answer", value = answer, inline = true},
                },
                color = env.config.accentColor,
            }
        };
    end;
    Name = "8ball";
    Description = "Returns a random answer to a question.";
    Usage = "<question>";
    Aliases = { "8b" };
    Permission = "none";
    BotOwnerOnly = false;
    GuildOwnerOnly = false;
    Enabled = true;
    Category = "Fun";
}