local config = {}

local data

function config.setup(configuration)
    if configuration == nil then
        configuration = {}
    end

    if configuration.schematics == nil then
        configuration.schematics = {
            require("nvim-tree-angular.schematics").defaults
        }
    end

    -- reread schematics
    local schematics = {}

    for _, element in ipairs(configuration.schematics) do
        if type(element) == "table" then
            for _, e in ipairs(element) do
                table.insert(schematics, e)
            end
        else
            table.insert(schematics, element)
        end
    end

    configuration.schematics = schematics

    data = configuration
end

function config.get_configuration()
    return data
end

return config
