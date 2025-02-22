LOCAL_CONFIG=~/.config
DOTFILES=~/Git/dotfiles/

cp $LOCAL_CONFIG/hypr/hyprland.conf $DOTFILES
cp $LOCAL_CONFIG/home-manager/home.nix $DOTFILES
cp /etc/nixos/configuration.nix $DOTFILES
