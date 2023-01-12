#!/usr/bin/env bash

# Config
#==========================================================
SCRIPTPATH="$(cd "$(dirname "$0")" || exit && pwd -P)"
# Config for rofi-wifi-menu
# position values:
# 1 2 3
# 8 0 4
# 7 6 5
POSITION=2
#x-offset
X_OFFSET=355
#y-offset
Y_OFFSET=50
#fields to be displayed
FIELDS=SSID,SECURITY,BARS
#font
FONT="JetBrainsMono Nerd Font 10"
#==========================================================

LIST="$(nmcli --fields "$FIELDS" device wifi)"
WIFI_STATUS="$(nmcli radio wifi)"

[[ "$WIFI_STATUS" =~ "enabled" ]] && TOGGLE="Turn wifi off"
[[ "$WIFI_STATUS" =~ "disabled" ]] && TOGGLE="Turn wifi on"

RESULT="$(echo -e "$TOGGLE\n$LIST" | rofi -dmenu -p "Wi-Fi SSID" -matching regex -config "$SCRIPTPATH/../configs/wifi_config.rasi" -location "$POSITION" -yoffset "$Y_OFFSET" -xoffset "$X_OFFSET" -font "$FONT")"

if [[ "$RESULT" =~ "Turn wifi off" ]]; then
	nmcli radio wifi off
	exit 0
elif [[ "$RESULT" =~ "Turn wifi on" ]]; then
	nmcli radio wifi on
	exit 0
fi

CON_SSID="$(echo "$RESULT" | cut -d ' ' -f 1)"
[[ -z "$CON_SSID" ]] && exit 0

[[ $(nmcli con up "$CON_SSID") ]] ||
	PASSWD="$(rofi -dmenu -p "Passwd" -matching regex -config "$SCRIPTPATH/../configs/wifi_config.rasi" -location "$POSITION" -yoffset "$Y_OFFSET" -xoffset "$X_OFFSET" -font "$FONT")" &&
	nmcli dev wifi con "$CON_SSID" password "$PASSWD"
