#!/bin/sh
export HOME=/config
mkdir -p /config/profile
mkdir -p /config/xdg

firefox --setDefaultBrowser --profile /config/profile &
sleep 5
__CLICKER_COMMAND__
