{ lib, pkgs, inputs,   ... }:
let
  variant = "frappe";
  accent = "blue";
  kvantumThemePackage = pkgs.catppuccin-kvantum.override {
    inherit variant accent;
  };
in {
imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel inputs.nixvim.homeManagerModules.nixvim ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "flabbet";
  home.homeDirectory = "/home/flabbet";
nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

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
    hyprpanel
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    papirus-folders
    feh
    wl-clipboard
    grimblast
    grim
    wf-recorder
    hyprpicker
    jq
    slurp
    bc
    nextcloud-client
    vscode
    hyprpolkitagent
    obsidian
    python3
(catppuccin-kvantum.override {
      variant = "${variant}";
      accent = "${accent}";
    })
    ];

programs.nixvim = {
    enable = true;

    colorschemes.catppuccin.enable = true;
    plugins = {
      nix.enable = true;
      lsp.enable = true;
      lsp-format.enable = true;
      lualine.enable = true;
    };
};

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
    gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
	'';
    };

    gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
	'';
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

  programs.hyprpanel = {
    enable = true;
    overlay.enable = true;
    overwrite.enable = true;

    layout = {
      "bar.layouts" = {
        "1" = {
           left = [ "dashboard" "workspaces" "windowtitle"];
	   middle = ["media" "cava"];
	   right = [ "volume" "network" "bluetooth" "systray" "clock" "notifications"];
	};
	"0" = {
            left = ["dashboard" "workspaces" "windowtitle"];
            middle = ["cava"];
            right = ["volume" "clock" "notifications"];
	};
      };
    };

    settings = {
    bar = {
    workspaces.show_icons = true;
    workspaces.showApplicationIcons = true;
    launcher = {
      autoDetectIcon = true;
    };
    network.label = false;
    };

    menus.clock = {
        time = {
           hideSeconds = true;
	   military = true;
	};
	weather = {
          location = "Warsaw";
	  unit = "metric";
	};
    };

    menus.dashboard = {

    powermenu.avatar.image = "/home/flabbet/Pictures/face.icon";

    shortcuts.left = {
    shortcut1.command = "firefox";
    shortcut1.icon = "";
    shortcut1.tooltip = "Firefox";
    shortcut2.command = "spotify";
    shortcut4.command = "~/.config/rofi/launchers/type-5/launcher.sh";
    };

    directories.left = {
        directory1.command = "bash -c \"xdg-open $HOME\"";
	directory1.label = "󱂵 Home";
        directory2.command = "bash -c \"xdg-open $HOME/Git\"";
	directory2.label = " Git";
        directory3.command = "bash -c \"xdg-open $HOME/Git/PixiEditor\"";
	directory3.label = "󰚝 PixiEditor";
    };
    directories.right = {
        directory1.command = "bash -c \"dolphin /mnt/gdrive\"";
	directory1.label = "󰉎 Google Drive";
        directory2.command = "bash -c \"dolphin $HOME/Nextcloud\"";
	directory2.label = "󰴋 NextCloud";
        directory3.command = "bash -c \"xdg-open $HOME/Pobrane\"";
	directory3.label = "󰉍 Downloads";

    };
    };
};
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

xdg.mimeApps = {
    enable = true;
    defaultApplications = {
	"inode/directory" = "org.kde.dolphin.desktop";
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
