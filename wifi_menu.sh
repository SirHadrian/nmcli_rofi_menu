#!/usr/bin/env bash

SCRIPTPATH="$(cd "$(dirname "$0")" || exit && pwd -P)"

LIST="$(nmcli --fields "SSID,SECURITY,BARS" device wifi)"

WIFISTATUS="$(nmcli radio wifi)"


[[ "$WIFISTATUS" =~ "enabled" ]] && TOGGLE="Turn wifi off"
[[ "$WIFISTATUS" =~ "disabled" ]] && TOGGLE="Turn wifi on"


RESULT="$(echo -e "$TOGGLE\n$LIST" | rofi -dmenu -p "Wi-Fi SSID: " -matching regex -config "$SCRIPTPATH/wifi_config.rasi")"


[[ "$RESULT" =~ "Turn wifi off" ]] && nmcli radio wifi off
[[ "$RESULT" =~ "Turn wifi on" ]] && nmcli radio wifi on



