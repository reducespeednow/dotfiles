{
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./theme.nix
    ./hardware-configuration.nix
  ];

  config = lib.mkMerge [

    # ── System ───────────────────────────────────────────────────
    {
      networking.hostName = "charlie";
      time.timeZone = "Europe/London";
      system.stateVersion = "26.05";
    }

    # ── Boot ─────────────────────────────────────────────────────
    {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    }

    # ── Swap ─────────────────────────────────────────────────────
    {
      swapDevices = [
        {
          device = "/dev/disk/by-partuuid/5e6f8da9-1c22-4512-b67a-cc7c4578fbb8";
          randomEncryption.enable = true;
        }
      ];
    }

    # ── Nix store maintenance ────────────────────────────────────
    {
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
      nix.settings.auto-optimise-store = true;
    }

    # ── Unfree packages ──────────────────────────────────────────
    {
      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "spotify"
          "discord"
        ];
    }

    # ── User ─────────────────────────────────────────────────────
    {
      users.users.sara = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "docker"
        ];
        shell = pkgs.fish;
      };
      programs.fish.enable = true;
    }

    # ── Dotfiles: symlink ~/.config/<app> -> ~/dotfiles/<app> ────
    {
      systemd.user.tmpfiles.users.sara.rules = map (d: "L+ %h/.config/${d} - - - - %h/dotfiles/${d}") [
        "alacritty"
        "niri"
        "fish"
        "nvim"
        "tmux"
        "waybar"
        "wpaperd"
        "swaync"
        "fuzzel"
      ];
    }

    # ── Networking (wifi + VPN) ──────────────────────────────────
    {
      networking.networkmanager.enable = true;
      networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
      environment.systemPackages = with pkgs; [
        networkmanagerapplet
      ];
    }

    # ── Audio ────────────────────────────────────────────────────
    {
      services.pipewire = {
        enable = true;
        pulse.enable = true;
      };
      environment.systemPackages = with pkgs; [
        pavucontrol
        playerctl
      ];
    }

    # ── Bluetooth ────────────────────────────────────────────────
    {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
      services.blueman.enable = true;
    }

    # ── Power: battery levels, low-battery notifications, profiles
    {
      services.upower = {
        enable = true;
        percentageLow = 20;
        percentageCritical = 10;
        percentageAction = 5;
      };
      systemd.user.services.poweralertd = {
        description = "Battery/power notifications";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Restart = "on-failure";
          ExecStart = "${pkgs.poweralertd}/bin/poweralertd";
        };
      };
      services.power-profiles-daemon.enable = true;
      environment.systemPackages = with pkgs; [
        poweralertd
      ];
    }

    # ── Framework hardware: firmware updates + fingerprint reader
    {
      services.fwupd.enable = true;
      services.fprintd.enable = true;
      security.pam.services.login.fprintAuth = false;
    }

    # ── Input remapper for Joy-Cons ──────────────────────────────
    {
      services.joycond.enable = true;
      services.input-remapper.enable = true;
      services.input-remapper.enableUdevRules = true;
      environment.systemPackages = with pkgs; [
        input-remapper
      ];
    }

    # ── Keyboard languages (US, Russian, Persian, Japanese) ──────
    {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          waylandFrontend = true;
          addons = with pkgs; [
            fcitx5-mozc
            fcitx5-gtk
          ];
          settings.inputMethod = {
            GroupOrder."0" = "Default";
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "keyboard-us";
            };
            "Groups/0/Items/0".Name = "keyboard-us";
            "Groups/0/Items/1".Name = "keyboard-ru";
            "Groups/0/Items/2".Name = "keyboard-ir";
            "Groups/0/Items/3".Name = "mozc";
          };
        };
      };
    }

    # ── Desktop: niri + bar, notifications, wallpaper, launcher ──
    {
      programs.niri.enable = true;
      security.soteria.enable = true; # polkit auth prompts
      environment.sessionVariables.NIXOS_OZONE_WL = "1";
      environment.systemPackages = with pkgs; [
        waybar
        swaynotificationcenter
        libnotify
        wpaperd
        fuzzel
        wl-clipboard
        brightnessctl
        wlsunset
      ];
    }

    # ── Lock screen + idle ───────────────────────────────────────
    {
      security.pam.services.swaylock = { };
      environment.systemPackages = with pkgs; [
        swaylock
        swayidle
      ];
    }

    # ── Screen recording ─────────────────────────────────────────
    {
      environment.systemPackages = with pkgs; [
        wf-recorder
        slurp
      ];
    }

    # ── Terminal + CLI tools ─────────────────────────────────────
    {
      programs.yazi.enable = true;
      programs.zoxide.enable = true;
      environment.localBinInPath = true;
      environment.systemPackages = with pkgs; [
        alacritty
        tmux
        git
        curl
        wget
        zip
        unzip
        tree
        ripgrep
        fd
        fzf
        psmisc
        fastfetch
      ];
    }

    # ── Editor + dev tooling (neovim, LSPs, formatters) ──────────
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
      };
      environment.systemPackages = with pkgs; [
        gcc
        tree-sitter
        lua-language-server
        nixd
        nixfmt
        stylua
        prettier
        black
      ];
    }

    # ── Docker / containers ──────────────────────────────────────
    {
      virtualisation.docker.enable = true;
    }

    # ── Apps ─────────────────────────────────────────────────────
    {
      environment.systemPackages = with pkgs; [
        brave
        mpv
        spotify
        discord
      ];
    }
  ];
}
