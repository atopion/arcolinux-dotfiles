#!/bin/bash

xrandr --auto
xrandr --output DVI-D-0 --primary
xrandr --output HDMI-1 --auto --right-of DVI-D-0
xrandr --output HDMI-0 --same-as HDMI-1
