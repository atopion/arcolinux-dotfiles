#
#   config.fish
#  
# Author: atopion
#
#

set fish_greeting

fish_ssh_agent

function __fish_command_not_found_handler --on-event fish_command_not_found
    echo "fish: Unknown command '$argv'"
end

# Todoist
function fish_user_key_bindings
  bind \ett peco_todoist_item
  bind \etp peco_todoist_project
  bind \etl peco_todoist_labels
  bind \etc peco_todoist_close
  bind \etd peco_todoist_delete
end

neofetch
