local fs = require('fs');
local json = require("json");

return {
    -- Stores the data in a file
    Store = function(self, data, file)
        local file = file or ".persist";
        local data = data or {};
        local data = json.encode(data);
        fs.writeFileSync(file, data);
    end,
    -- Loads the data from a file
    Load = function(self, file)
        local file = file or ".persist";
        local data = fs.readFileSync(file);
        data = json.decode(data);
        return data;
    end,
    -- Clears the data from a file
    Clear = function(self, file)
        local file = file or ".persist";
        fs.writeFileSync(file, "");
    end,
    -- Checks if the file exists
    Exists = function(self, file)
        local file = file or ".persist";
        return fs.existsSync(file);
    end,
    -- Checks if the file is empty
    IsEmpty = function(self, file)
        local file = file or ".persist";
        local data = fs.readFileSync(file);
        return data == "";
    end
}