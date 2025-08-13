#!/bin/sh
export HOME=/config
mkdir -p /config/profile
mkdir -p /config/xdg

firefox --setDefaultBrowser --profile /config/profile &
sleep 5
xclicker.AppImage --appimage-extract-and-run
#autoclic-app --no-sandbox