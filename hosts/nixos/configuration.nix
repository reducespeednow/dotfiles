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
  networking.networkmanager.enable = true;
  networking.hostName = "charlie";
  networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
  time.timeZone = "Europe/London";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.settings.auto-optimise-store = true;

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/5e6f8da9-1c22-4512-b67a-cc7c4578fbb8";
      randomEncryption.enable = true;
    }
  ];

  system.stateVersion = "26.05"; # Did you read the comment?

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.fwupd.enable = true;
  services.fprintd.enable = true;

  programs.niri.enable = true;
  programs.fish.enable = true;
  programs.yazi.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.zoxide.enable = true;

  virtualisation.docker.enable = true;

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

  users.users.sara = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    shell = pkgs.fish;
  };

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

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
      "discord"
    ];

  environment.systemPackages = with pkgs; [
    playerctl
    wget
    git
    brave
    alacritty
    fuzzel
    zip
    tree
    tmux
    fastfetch
    gcc
    ripgrep
    fd
    unzip
    tree-sitter
    lua-language-server
    swaylock
    libnotify
    brightnessctl
    waybar
    swaynotificationcenter
    wpaperd
    networkmanagerapplet
    wf-recorder
    slurp
    psmisc
    pavucontrol
    nixd
    prettier
    stylua
    nixfmt
    black
    swayidle
    wl-clipboard
    fzf
    mpv
    spotify
    discord
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.pam.services.swaylock = { };
  security.pam.services.login.fprintAuth = false;
  security.soteria.enable = true;
}
