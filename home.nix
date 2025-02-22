{ config, lib, pkgs, ... }:

let
  variant = "frappe";
  accent = "blue";
  kvantumThemePackage = pkgs.catppuccin-kvantum.override {
    inherit variant accent;
  };
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "flabbet";
  home.homeDirectory = "/home/flabbet";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    waybar
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    papirus-folders
(catppuccin-kvantum.override {
      variant = "${variant}";
      accent = "${accent}";
    })
    ];

gtk = {
    enable = true;
iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "${variant}";
        accent = "${accent}";
      };
    };
    cursorTheme = {
      name = "Catppuccin-Macchiato-Dark-Cursors";
      package = pkgs.catppuccin-cursors.macchiatoDark;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=catppuccin-${variant}-${accent}
    '';

    # The important bit is here, links the theme directory from the package to a directory under `~/.config`
    # where Kvantum should find it.
    "Kvantum/catppuccin-${variant}-${accent}".source = "${kvantumThemePackage}/share/Kvantum/catppuccin-${variant}-${accent}";
  };

home.pointerCursor = {
    gtk.enable = true;
    name = "Catppuccin-Macchiato-Dark-Cursors";
    package = pkgs.catppuccin-cursors.macchiatoDark;
    size = 16;
  }; 
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs.kitty = lib.mkForce {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      background_opacity = "0.8";
      background_blur = 5;
    };
    font.name = "Fira Code";
    themeFile = "Monokai";
  };

  programs.hyprlock = {
    enable = true;
    settings = {
  general = {
    disable_loading_bar = true;
    grace = 300;
    hide_cursor = true;
    no_fade_in = false;
  };

  background = [
    {
      path = "screenshot";
      blur_passes = 3;
      blur_size = 8;
    }
  ];

  input-field = [
    {
      size = "200, 50";
      position = "0, -80";
      monitor = "";
      dots_center = true;
      fade_on_empty = false;
      font_color = "rgb(202, 211, 245)";
      inner_color = "rgb(91, 96, 120)";
      outer_color = "rgb(24, 25, 38)";
      outline_thickness = 5;
      placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
      shadow_passes = 2;
    }
  ];

    };
  };

  programs.waybar = {
  enable = true;
  style = ''
  @import "mocha.css";

* {
  font-family: FantasqueSansMono Nerd Font;
  font-size: 17px;
  min-height: 0;
}

#waybar {
  background: transparent;
  color: @text;
  margin: 5px 5px;
}

#workspaces {
  border-radius: 1rem;
  margin: 5px;
  background-color: @surface0;
  margin-left: 1rem;
}

#workspaces button {
  color: @lavender;
  border-radius: 1rem;
  padding: 0.4rem;
}

#workspaces button.active {
  color: @sky;
  border-radius: 1rem;
}

#workspaces button:hover {
  color: @sapphire;
  border-radius: 1rem;
}

#custom-music,
#tray,
#backlight,
#clock,
#battery,
#bluetooth,
#pulseaudio,
#cava,
#cpu,
#custom-lock,
#custom-power {
  background-color: @surface0;
  padding: 0.5rem 1rem;
  margin: 1rem 0;
  border-radius: 1rem;
}

#clock {
  color: @blue;
  border-radius: 0px 1rem 1rem 0px;
  margin-right: 1rem;
}

#battery {
  color: @green;
}

#battery.charging {
  color: @green;
}

#battery.warning:not(.charging) {
  color: @red;
}

#backlight {
  color: @yellow;
}

#backlight, #battery {
    border-radius: 0;
}

#pulseaudio {
  color: @maroon;
  border-radius: 1rem 0px 0px 1rem;
  margin-left: 1rem;
}

#cpu{
margin-left: 1rem;
color: @green;
}

#custom-music {
  color: @mauve;
  border-radius: 1rem 0 0 1rem;
}

#bluetooth{
margin-right: 1rem;
color: @sapphire;
}

#cava
{
color: @mauve;
border-radius: 0 1rem 1rem 0;
}

#custom-lock {
    border-radius: 1rem 0px 0px 1rem;
    color: @lavender;
}

#custom-power {
    margin-right: 1rem;
    border-radius: 0px 1rem 1rem 0px;
    color: @red;
}

#tray {
  margin-right: 1rem;
  border-radius: 1rem;
}
  '';
  settings = {
    mainbar = {
	layer = "top"; 
	position = "top"; 
        modules-left = ["cpu"];
        modules-center = ["custom/music" "cava"];
        modules-right = ["pulseaudio" "clock" "bluetooth" "custom/lock" "custom/power"];

    "bluetooth" = {
    	format = " {device_alias}";
	format-disabled = "";
	tooltip = true;
	tooltip-format = "{device_enumerate}";
	tooltip-format-enumerate-connected = "{device_alias}";
	tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_battery_percentage}%";
	on-click = "blueman-manager";
	
    };
    "cpu" = {
    interval= 1;
     format= "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}  {usage}% ";
     format-icons= [
          "<span color='#69ff94'>▁</span>" 
          "<span color='#2aa9ff'>▂</span>"
          "<span color='#f8f8f2'>▃</span>"
          "<span color='#f8f8f2'>▄</span>"
          "<span color='#ffffa5'>▅</span>"
          "<span color='#ffffa5'>▆</span>"
          "<span color='#ff9977'>▇</span>"
          "<span color='#dd532e'>█</span>"
     ];
    };
     "custom/music" = {
	    format = "  {}";
	    escape = true;
	    interval = 5;
	    tooltip = false;
	    exec = "playerctl metadata --format='{{ title }}'";
	    on-click = "playerctl play-pause";
	    max-length = 50;
    };
    "cava"={
	    cava-config = "~/.config/cava/config";
	    framerate = 30;
	hide_on_silence= true;
	    autosens= 1;
	    bars= 14;
	    bar_delimiter= 0;
	    format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
	    actions= {
		    on-click-right= "mode";
	    };
    };
    "clock"= {
	    timezone= "Europe/Warsaw";
	    tooltip-format= "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
	    format-alt= " {:%d/%m/%Y}";
	    format= " {:%H:%M}";
    };
    "pulseaudio"= {
	format= "{icon}  {volume}%";
	format-muted= "";
	format-icons= {
		default= ["" "" " "];
	};
	on-click= "pavucontrol";
    };
    "custom/lock"= {
	    tooltip= false;
	    on-click= "hyprlock";
	    format= "";
    };
    "custom/power"= {
	    tooltip= false;
	    on-click= "~/.config/rofi/applets/bin/powermenu.sh";
	    format= "⏻";
     };
    };
  };
};
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/flabbet/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
