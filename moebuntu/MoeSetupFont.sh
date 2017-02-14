#!/bin/bash

# MoeSetupFont.sh
# :: mt08
# http://qiita.com/mt08/items/ccc660f233e0f525b0da

# DBUS
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    echo Trying to set DBUS_SESSION_BUS_ADDRESS
    dbus_session_file=${HOME}/.dbus/session-bus/$(cat /var/lib/dbus/machine-id)-0
    if [ -e "$dbus_session_file" ]; then
	export $(grep -E '^DBUS_SESSION_BUS_PID=' $dbus_session_file)
	export $(</proc/${DBUS_SESSION_BUS_PID}/environ tr \\0 \\n | grep -E '^DBUS_SESSION_BUS_ADDRESS=')
    fi
fi

SCRIPT_DIR=$(cd $(dirname $0) && pwd)

#Font
MOE_FONT_FILE=AKUBIN1.34.TTF
MOE_FONT_NAME='Akubin 11'
#MOE_FONT_FILE=setofont.ttf
#MOE_FONT_NAME='SetoFont 11'

# ファイル存在チェック.
[ ! -f ${SCRIPT_DIR}/${MOE_FONT_FILE} ] && echo Not found: ${MOE_FONT_FILE} && exit 1

mkdir -p ${HOME}/.fonts/
cp ${SCRIPT_DIR}/${MOE_FONT_FILE} ${HOME}/.fonts
gsettings set org.gnome.desktop.interface document-font-name "$MOE_FONT_NAME"
gsettings set org.gnome.desktop.interface font-name "$MOE_FONT_NAME"
gsettings set org.gnome.desktop.interface monospace-font-name "$MOE_FONT_NAME"
gsettings set org.gnome.desktop.wm.preferences titlebar-font "$MOE_FONT_NAME"
