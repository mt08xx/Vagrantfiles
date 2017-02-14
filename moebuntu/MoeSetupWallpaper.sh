#!/bin/bash

# MoeSetupWallpaper.sh
# :: mt08
# http://qiita.com/mt08/items/ccc660f233e0f525b0da

# Examples)
# $ /vagrant/MoeSetupWallpaper.sh Pink
# $ /vagrant/MoeSetupWallpaper.sh braid
# $ /vagrant/MoeSetupWallpaper.sh anyimagefile_which_is_in_the_scriptfolder.jpg

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
	echo $1
	MOE_BASE_COLOR=$1
    fi
fi

#
declare -r MOE_LOGO=moebuntu_logo800new.png
declare -r -A MOE_WALLPAPER_TABLE=(
    [Pink-file]="theAnimeGallery_12631_1600x1200.jpg" [Pink-gravity]="east" [Pink-geometry]="+40+0"     # http://www.theanimegallery.com/image/12631
    [Blue-file]="theAnimeGallery_128810_1600x1200.jpg" [Blue-gravity]="west" [Blue-geometry]="+160+360" # http://www.theanimegallery.com/image/128810
    [Orange-file]="braid_hair_girl_1600x1200_logo.png"      # http://photozou.jp/photo/show/1101860/165108850
    [Yellow-file]="onyanoko1600x1200_logo.png"              # http://photozou.jp/photo/show/1101860/148821581
    ##
       [braid-file]="braid_hair_girl_1600x1200_logo.png"    # http://photozou.jp/photo/show/1101860/165108850
    [hinomoto-file]="hinomoto_oniko_1600-1200_logo.jpg"     # http://photozou.jp/photo/show/1101860/64654896
     [yukarin-file]="Yukarin_1600x1200_logo.jpg"            # http://photozou.jp/photo/show/1101860/64654896
        [hina-file]="Hina_1600x1200_logo.jpg"               # http://photozou.jp/photo/show/1101860/64181509
       [angel-file]="Angel_1600x1200_logo.jpg"              # http://photozou.jp/photo/show/1101860/58904389
       [peace-file]="Peace_sign_girl1600x1200_logo.png"     # http://photozou.jp/photo/show/1101860/115613701
    [onyanoko-file]="onyanoko1600x1200_logo.png"            # http://photozou.jp/photo/show/1101860/148821581
         [eva-file]="eva_chin_1600x1200_logo.png"           # http://photozou.jp/photo/show/1101860/80727975
      [clover-file]="clover_girl_1600x1200_logo.png"        # http://photozou.jp/photo/show/1101860/195146625
)

# Userチェック.
id=`id -u`
if [ $id -eq 0 ]; then
    echo "Please run as user."
    exit 1
fi

# Wallpaper
if [ -f ${SCRIPT_DIR}/$MOE_BASE_COLOR ]; then
    MOE_WALLPAPER=$MOE_BASE_COLOR
else
    [ -z ${MOE_WALLPAPER_TABLE["${MOE_BASE_COLOR}-file"]} ] && echo Exit: No wallpaper for $MOE_BASE_COLOR && exit 1

    MOE_WALLPAPER=${MOE_WALLPAPER_TABLE["${MOE_BASE_COLOR}-file"]}
fi

MOE_WALLPAPER_EXT=${MOE_WALLPAPER##*.}
declare -r MOE_WALLPAPER_FILE=${HOME}/.wallpaper.${MOE_WALLPAPER_EXT}

if [ -z ${MOE_WALLPAPER_TABLE["${MOE_BASE_COLOR}-gravity"]} ]; then
    MOE_LOGO_POSITION="none"
else
    MOE_LOGO_POSITION="-gravity ${MOE_WALLPAPER_TABLE["${MOE_BASE_COLOR}-gravity"]} -geometry ${MOE_WALLPAPER_TABLE["${MOE_BASE_COLOR}-geometry"]}"
fi

#default 
[ -z "$MOE_WALLPAPER" ] && MOE_WALLPAPER=wallpaper.jpg

# ファイル存在チェック.
[ ! -f ${SCRIPT_DIR}/${MOE_WALLPAPER} ] && echo Not found:${SCRIPT_DIR}/${MOE_WALLPAPER} && exit 1
cp -v ${SCRIPT_DIR}/${MOE_WALLPAPER} ${MOE_WALLPAPER_FILE}

if [ "${MOE_LOGO_POSITION}" = "none" ]; then
    cp ${SCRIPT_DIR}/${MOE_WALLPAPER} ${MOE_WALLPAPER_FILE}
else
    echo Composite logo
    convert -resize 1600 ${SCRIPT_DIR}/${MOE_WALLPAPER} ${HOME}/tmp1.png
    convert -resize  720 ${SCRIPT_DIR}/${MOE_LOGO}      ${HOME}/tmp2.png
    [ -f ${HOME}/tmp1.png ] && [ -f ${HOME}/tmp2.png ] && convert ${HOME}/tmp1.png ${HOME}/tmp2.png ${MOE_LOGO_POSITION} -compose over -composite ${MOE_WALLPAPER_FILE}
    rm -f ${HOME}/tmp1.png ${HOME}/tmp2.png
fi
gsettings set org.gnome.desktop.background picture-uri "file://${MOE_WALLPAPER_FILE}"
