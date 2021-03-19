#!/bin/bash

function run {
  if ! pgrep $(echo $1 | cut -d ' ' -f1);
  then
    $@&
  fi
}
run "nm-applet"
run "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
run "numlockx on"
run "volumeicon"
run "nitrogen --restore"
run "udiskie --automount --notify --no-tray"

#run "spotify"
#run "discord"
#run "telegram-desktop"

run "owncloud"
