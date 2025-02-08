Init submodules first

## ROFI:

```
cd rofi
chmod +x setup.sh
./setup.sh
```

config the style in `/.config/rofi/launchers/type-5/launcher.sh`, I use 4

## rclone

put gdrive-config.conf inside `/etc/nixos/`

```
[gdrive]
type = drive
scope = drive
token = {"access_token":"","token_type":"","refresh_token":"","expiry":""}
team_drive =
```
