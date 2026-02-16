#!/bin/bash

OUTPUT=$(xrandr | awk ' /connected/{print $1}')
xrandr --newmode "1920x1080_60.00" 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync
xrandr --addmode $OUTPUT "1920x1080_60.00"
xrandr --output $OUTPUT --mode "1920x1080_60.00"
xrandr --dpi 96

unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR

export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5

# required for some apps depends on systemd?
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export XDG_DOCUMENTS_DIR="$XDG_RUNTIME_DIR/doc"
export XDG_CURRENT_DESKTOP="XFCE"
export XDG_SESSION_TYPE="x11"
export GTK_USE_PORTAL=1

eval $(dbus-launch --sh-syntax --exit-with-session)

/usr/libexec/xdg-desktop-portal --replace &
/usr/libexec/xdg-document-portal --replace &

xfconf-query -c xfce4-session -p /startup/lock-screen -s false

. ~/.profile
fcitx5 -d
exec startxfce4
