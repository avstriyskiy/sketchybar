local events <const> = {
  YABAI_SPACE_CHANGED = "space_change",
  YABAI_WINDOW_FOCUSED = "application_activated",
  SWAP_MENU_AND_SPACES = "swap_menu_and_spaces",
  FRONT_APP_SWITCHED = "front_app_switched",
  UPDATE_WINDOWS = "update_windows",
  SEND_MESSAGE = "send_message",
  HIDE_MESSAGE = "hide_message",
}

local items <const> = {
  SPACES = "workspaces",
  MENU = "menu",
  MENU_TOGGLE = "menu_toggle",
  FRONT_APPS = "front_apps",
  MESSAGE = "message",
  VOLUME = "widgets.volume",
  WIFI = "widgets.wifi",
  BATTERY = "widgets.battery",
  CALENDAR = "widgets.calendar",
}

local yabai <const> = {
  LIST_ALL_SPACES = "yabai -m query --spaces | jq -r '.[].label'",
  GET_CURRENT_SPACE = "yabai -m query --spaces --space | jq -r '.label'",
  LIST_WINDOWS = "yabai -m query --windows --space | jq -r '.[] | \"id=\" + (.id | tostring) + \", name=\" + .app'",
  GET_CURRENT_WINDOW = "yabai -m query --windows --window | jq -r '.app'",
}

return {
  items = items,
  events = events,
  yabai = yabai,
}
