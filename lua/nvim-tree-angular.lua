local nvim_tree_angular = {}

local nvim_tree_angular_config = require("nvim-tree-angular.config")

function nvim_tree_angular.setup(conf)
    nvim_tree_angular_config.setup(conf)
end

local function create_schematic(folder, schematic, name)
    if name == nil then
        vim.ui.input({prompt = schematic .. " name:"}, function (name)
            create_schematic(folder, schematic, name)
        end)
        return
    end

    local relative = string.gsub(folder, "(.*)/src/app/", "")
    local main = string.gsub(folder, "/src/app/(.*)", "")

    local command = "cd " .. main .. " && ng generate " .. schematic .. " " .. relative .. "/" .. name
    print(command)
    local handle = io.popen(command)
    if handle == nil then
        return
    end
    local result = handle:read("*a")
    handle:close()
end

function nvim_tree_angular.create_angular_schematic()
    local ok, api = pcall(require, "nvim-tree.api")

    if not ok then
        return
    end

    local node = api.tree.get_node_under_cursor()

    local path = node.absolute_path

    if node.type == "file" then
        path = node.parent.absolute_path
    end

    local ok, _ = pcall(require, "telescope")

    if not ok then
        return
    end

    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local schematics = nvim_tree_angular_config.get_configuration().schematics

    pickers.new({}, {
        prompt_title = "Create Angular Schematic",
        finder = finders.new_table {
            results = schematics
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function (prompt_buffer, map)
            actions.select_default:replace(function ()
                actions.close(prompt_buffer)
                local selection = action_state.get_selected_entry()
                create_schematic(path, selection[1])
            end)
            return true
        end
    }):find()
end

return nvim_tree_angular
