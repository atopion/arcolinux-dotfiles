# Defined in - @ line 1
function pacman-find --wraps=pacman\ -Slq\ \|\ fzf\ --multi\ --preview\ \'pacman\ -Si\ \{1\}\'\ \|\ xargs\ -ro\ sudo\ pacman\ -S --description alias\ pacman-find=pacman\ -Slq\ \|\ fzf\ --multi\ --preview\ \'pacman\ -Si\ \{1\}\'\ \|\ xargs\ -ro\ sudo\ pacman\ -S
  sudo pacman -Slq | fzf --multi --preview 'pacman -Si {1}' --query=$argv | xargs -ro sudo pacman -S;
end
