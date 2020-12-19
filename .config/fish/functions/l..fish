# Defined in /home/atopi/.config/fish/config.fish @ line 25
function l.
    ls -A --color=auto $argv | egrep '^\.'
end
