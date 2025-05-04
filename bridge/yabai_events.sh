#!/bin/bash

# Скрипт для регистрации событий yabai в sketchybar

# Сначала удаляем все существующие сигналы yabai
echo "Removing existing yabai signals..."
yabai -m signal --remove "space_change"
yabai -m signal --remove "window_focused"
yabai -m signal --remove "application_front_switched"
yabai -m signal --remove "application_launched"
yabai -m signal --remove "application_terminated"

# Регистрация события смены пространства
yabai -m signal --add event=space_changed action="sketchybar --trigger space_change"

# Регистрация события фокуса окна (приложения)
yabai -m signal --add event=window_focused action="sketchybar --trigger application_activated"
yabai -m signal --add event=application_front_switched action="sketchybar --trigger application_activated"

# Регистрация событий для обновления при запуске/закрытии приложения
yabai -m signal --add event=application_launched action="sketchybar --trigger application_activated"
yabai -m signal --add event=application_terminated action="sketchybar --trigger application_activated"

echo "yabai events registered with sketchybar" 