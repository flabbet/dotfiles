LOCAL_CONFIG=~/.config
DOTFILES=~/Git/dotfiles/

cp $LOCAL_CONFIG/hypr/hyprland.conf $DOTFILES
cp /etc/nixos/flake.nix $DOTFILES
cp /etc/nixos/home.nix $DOTFILES
cp /etc/nixos/configuration.nix $DOTFILES
