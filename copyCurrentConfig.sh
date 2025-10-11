LOCAL_CONFIG=~/.config
DOTFILES=~/Git/dotfiles

cp $LOCAL_CONFIG/hypr/hyprland.conf $DOTFILES/
cp /etc/nixos/flake.nix $DOTFILES/
cp /etc/nixos/home.nix $DOTFILES/
cp /etc/nixos/configuration.nix $DOTFILES/
cp $LOCAL_CONFIG/waybar/waybar-style.css $DOTFILES/waybar/
cp $LOCAL_CONFIG/waybar/mocha.css $DOTFILES/waybar/
cp -r $LOCAL_CONFIG/hyprpanel $DOTFILES/hyprpanel/
