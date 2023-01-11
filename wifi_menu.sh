#!/usr/bin/env bash

SCRIPTPATH="$(cd "$(dirname "$0")" || exit && pwd -P)"

LIST="$(nmcli --fields "SSID,SECURITY,BARS" device wifi)"


echo -e "$LIST" | rofi -dmenu -p "Wi-Fi SSID: " -matching regex -config "$SCRIPTPATH/wifi_config.rasi" 






