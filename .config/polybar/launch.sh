#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

while pgrep -x polybar >/dev/null; do sleep 1; done

echo "$USER" > /home/atopi/user.log

# Wait for xrandr setup to complete
    #while [ $(xrandr --current | grep '\bconnected' | wc -l) -lt 2 ]; do sleep 0.5; done

# Launch bar1 and bar2
echo "-------" | tee -a /tmp/polybar1.log /tmp/polybar2.log
echo " > Bars launched at: `date`" | tee -a /tmp/polybar1.log /tmp/polybar2.log
echo " > Number of monitors: `xrandr --current | grep '\bconnected' | wc -l`" | tee -a /tmp/polybar1.log /tmp/polybar2.log
~/code/polybar/build/bin/polybar left >> /tmp/polybar1.log 2>&1 & disown
~/code/polybar/build/bin/polybar right >> /tmp/polybar2.log 2>&1 & disown

echo "Bars launched..."
