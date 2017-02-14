#!/bin/bash

# MoeSetupTheme.sh
# :: mt08
# http://qiita.com/mt08/items/ccc660f233e0f525b0da
#
# Examples)
# $ /vagrant/MoeSetupTheme.sh Pink
# $ /vagrant/MoeSetupTheme.sh Blue 10
# $ /vagrant/MoeSetupTheme.sh BlueGreen 9

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

if [ -z "$MOE_BASE_COLOR" ]; then 
    if [ -z $1 ]; then
	MOE_BASE_COLOR=Pink
    else
	echo $1 $2
	MOE_BASE_COLOR=$1
	if [ ! -z $2 ]; then
            MOE_THEME_REVISION=$2
	fi
    fi
fi

if [ -z "$MOE_THEME_REVISION" ]; then 
    for i in $(seq 7 15) ; do 
	[ -f "${SCRIPT_DIR}/Moe-${MOE_BASE_COLOR}${i}.tar.gz" ] && MOE_THEME_REVISION=${i}
    done
fi

MOE_THEME_ICON=MoePinkIcons
MOE_ICON_FILE=MoePinkIcons_150719.tar.gz
MOE_DASH_ICON_FILE=DashIcons3.tar.gz

declare -r -A MOE_COLOR_TABLE=(
    [Pink0]="#fff4ff" [Blue0]="#F4F8F9" [BlueGreen0]="#edf7f5" [Yellow0]="#FFFCF4" [Red0]="#fff9f9" [Orange0]="#fffbf7" [Navy0]="#f9faff" [Green0]="#FBFFF7" [Purple0]="#fbf7ff" 
    [Pink1]="#FEA5FA" [Blue1]="#7bdcf7" [BlueGreen1]="#92dddd" [Yellow1]="#FFD335" [Red1]="#f89494" [Orange1]="#ffb420" [Navy1]="#8a95ec" [Green1]="#b5eb82" [Purple1]="#ba7ef7" 
    [Pink2]="#ff66f7" [Blue2]="#31ccf7" [BlueGreen2]="#5cd7db" [Yellow2]="#ffcd19" [Red2]="#f86a6a" [Orange2]="#ffaa00" [Navy2]="#7b88ea" [Green2]="#a3e663" [Purple2]="#b46ef9" 
    [Pink3]="#ff4cf6" [Blue3]="#18C7F7" [BlueGreen3]="#2aced3" [Yellow3]="#ffbb35" [Red3]="#f75757" [Orange3]="#ff9900" [Navy3]="#6d7be8" [Green3]="#6ee500" [Purple3]="#a95af8" 
    [Pink4]="#ff33f4" [Blue4]="#00c1ff" [BlueGreen4]="#00ccd3" [Yellow4]="#ff8a00" [Red4]="#f74545" [Orange4]="#ff6a00" [Navy4]="#2e44e8" [Green4]="#56b200" [Purple4]="#9431f7" 
    [Pink5]="#ffccff" [Blue5]="#ade7f7" [BlueGreen5]="#c6efed" [Yellow5]="#ffe399" [Red5]="#ffcccc" [Orange5]="#ffdbba" [Navy5]="#ced1e5" [Green5]="#c3e5a0" [Purple5]="#d7b6fa" 
    [Pink6]="#cc84c8" [Blue6]="#66b5cc" [BlueGreen6]="#6fa8a5" [Yellow6]="#cca92a" [Red6]="#cc7a7a" [Orange6]="#e5a21d" [Navy6]="#6971b2" [Green6]="#6bb724" [Purple6]="#9f78c6" 
)
declare -r MOE_LAUNCHER_BG_COLOR_____TBLIDX='3'
declare -r MOE_LAUNCHER_BG_COLOR_____ALPHA='84'
declare -r MOE_ACTIVE_SHADOW_COLOR___TBLIDX='6'
declare -r MOE_ACTIVE_SHADOW_COLOR___ALPHA='66'
declare -r MOE_INACTIVE_SHADOW_COLOR_TBLIDX='6'
declare -r MOE_INACTIVE_SHADOW_COLOR_ALPHA='a5'

declare -r MOE_THEME=Moe-"${MOE_BASE_COLOR}${MOE_THEME_REVISION}"
declare -r     MOE_LAUNCHER_BG_COLOR="${MOE_COLOR_TABLE[${MOE_BASE_COLOR}${MOE_LAUNCHER_BG_COLOR_____TBLIDX}]}${MOE_LAUNCHER_BG_COLOR_____ALPHA}" # background-color
declare -r   MOE_ACTIVE_SHADOW_COLOR="${MOE_COLOR_TABLE[${MOE_BASE_COLOR}${MOE_ACTIVE_SHADOW_COLOR___TBLIDX}]}${MOE_ACTIVE_SHADOW_COLOR___ALPHA}" # active-shadow-color
declare -r MOE_INACTIVE_SHADOW_COLOR="${MOE_COLOR_TABLE[${MOE_BASE_COLOR}${MOE_INACTIVE_SHADOW_COLOR_TBLIDX}]}${MOE_INACTIVE_SHADOW_COLOR_ALPHA}" # inactive-shadow-color
declare -r MOE_PANEL_SHADOW="panel_shadow${MOE_BASE_COLOR}.png"

declare -r MOE_THEME_FILE=${MOE_THEME}.tar.gz

# ファイル存在チェック.
[ ! -f ${SCRIPT_DIR}/${MOE_THEME_FILE} ] && echo Not found: ${SCRIPT_DIR}/${MOE_THEME_FILE} && exit 1

# Userチェック.
sudo test 0
id=`id -u`
if [ $id -eq 0 ]; then
    echo "Please run as user."
    exit 1
fi

sudo tar xf ${SCRIPT_DIR}/${MOE_THEME_FILE} -C /usr/share/themes/
tar xf ${SCRIPT_DIR}/${MOE_DASH_ICON_FILE} -C /tmp
sudo cp /tmp/DashIcons3/MoeDashIcons/* /usr/share/unity/icons/
sudo cp /usr/share/unity/icons/${MOE_PANEL_SHADOW} /usr/share/unity/icons/panel_shadow.png

for i in unity unity-lowgfx; do
    # Color: Launcher
    gsettings set org.compiz.unityshell:/org/compiz/profiles/$i/plugins/unityshell/ background-color "${MOE_LAUNCHER_BG_COLOR}"
    
    # Step12: Color
    gsettings set org.compiz.unityshell:/org/compiz/profiles/$i/plugins/unityshell/ override-decoration-theme true
    gsettings set org.compiz.unityshell:/org/compiz/profiles/$i/plugins/unityshell/ shadow-x-offset 4
    gsettings set org.compiz.unityshell:/org/compiz/profiles/$i/plugins/unityshell/ shadow-y-offset 4
    gsettings set org.compiz.unityshell:/org/compiz/profiles/$i/plugins/unityshell/ active-shadow-radius 12
    gsettings set org.compiz.unityshell:/org/compiz/profiles/$i/plugins/unityshell/ active-shadow-color "${MOE_ACTIVE_SHADOW_COLOR}"
    gsettings set org.compiz.unityshell:/org/compiz/profiles/$i/plugins/unityshell/ inactive-shadow-radius 12
    gsettings set org.compiz.unityshell:/org/compiz/profiles/$i/plugins/unityshell/ inactive-shadow-color "${MOE_INACTIVE_SHADOW_COLOR}" 
done

mkdir -p ${HOME}/{.icons,.fonts}
tar xf ${SCRIPT_DIR}/${MOE_ICON_FILE} -C ${HOME}/.icons

echo Theme: "${MOE_THEME}"
gsettings set org.gnome.desktop.interface gtk-theme  "${MOE_THEME}"
gsettings set org.gnome.desktop.wm.preferences theme "${MOE_THEME}"
gsettings set org.gnome.desktop.interface icon-theme "${MOE_THEME_ICON}"
