local constants = require("constants")
local settings = require("config.settings")

local spaces = {}

local swapWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

local currentWorkspaceWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

-- Modify this file with Visual Studio Code - at least vim does have problems with the icons
-- copy "Icons" from the nerd fonts cheat sheet and replace icon and name accordingly below
-- https://www.nerdfonts.com/cheat-sheet
local spaceConfigs <const> = {
  ["terminal"] = { icon = "", name = "Terminal" },
  ["browser"] = { icon = "", name = "Browser" },
  ["messenger"] = { icon = "󰭹", name = "Social" },
  ["db"] = { icon = "", name = "Database" },
  ["postman"] = { icon = "", name = "Postman" },
  ["obsidian"] = { icon = "󰇮", name = "Obsidian" },
  ["meeting"] = { icon = "󰊻", name = "Meetings" },
  ["secret"] = { icon = "󰌾", name = "Secret" },
  ["music"] = { icon = "", name = "Music" },
  -- ["t"] = { icon = "", name = "Meeting" },
}

local function selectCurrentWorkspace(focusedWorkspaceName)
  for sid, item in pairs(spaces) do
    if item ~= nil then
      -- Извлекаем метку пространства из sid (формат: workspaces.terminal, workspaces.browser, etc.)
      local label = sid:match("%.(.+)$")
      local isSelected = label == focusedWorkspaceName
      
      item:set({
        icon = { color = isSelected and settings.colors.bg1 or settings.colors.white },
        label = { color = isSelected and settings.colors.bg1 or settings.colors.white },
        background = { color = isSelected and settings.colors.white or settings.colors.bg1 },
      })
    end
  end

  sbar.trigger(constants.events.UPDATE_WINDOWS)
end

local function findAndSelectCurrentWorkspace()
  sbar.exec(constants.yabai.GET_CURRENT_SPACE, function(focusedWorkspaceOutput)
    local focusedWorkspaceName = focusedWorkspaceOutput:match("[^\r\n]+")
    selectCurrentWorkspace(focusedWorkspaceName)
  end)
end

local function addWorkspaceItem(workspaceName)
  local spaceName = constants.items.SPACES .. "." .. workspaceName
  local spaceConfig = spaceConfigs[workspaceName]

  -- Для пустых меток (на случай если yabai вернет пространство без метки)
  if workspaceName == "" or workspaceName == "nil" then
    return
  end

  spaces[spaceName] = sbar.add("item", spaceName, {
    label = {
      width = 0,
      padding_left = 0,
      string = spaceConfig and spaceConfig.name or workspaceName,
    },
    icon = {
      string = spaceConfig and spaceConfig.icon or settings.icons.apps["default"],
      color = settings.colors.white,
    },
    background = {
      color = settings.colors.bg1,
    },
    -- click_script = "yabai -m space --focus " .. spaceName,
  })

  sbar.add("item", spaceName .. ".padding", {
    width = settings.dimens.padding.label
  })
end

local function createWorkspaces()
  sbar.exec(constants.yabai.LIST_ALL_SPACES, function(workspacesOutput)
    for workspaceName in workspacesOutput:gmatch("[^\r\n]+") do
      addWorkspaceItem(workspaceName)
    end

    findAndSelectCurrentWorkspace()
  end)
end

swapWatcher:subscribe(constants.events.SWAP_MENU_AND_SPACES, function(env)
  local isShowingSpaces = env.isShowingMenu == "off" and true or false
  sbar.set("/" .. constants.items.SPACES .. "\\..*/", { drawing = isShowingSpaces })
end)

currentWorkspaceWatcher:subscribe(constants.events.YABAI_SPACE_CHANGED, function(env)
  findAndSelectCurrentWorkspace()
end)

createWorkspaces()
