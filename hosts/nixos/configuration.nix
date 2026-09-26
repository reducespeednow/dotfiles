{ config, lib, pkgs, ... }:

{
    imports = [
        ./theme.nix
        ./hardware-configuration.nix
    ];
    networking.networkmanager.enable = true;
    time.timeZone = "Europe/London";

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    swapDevices = [{
      device = "/dev/disk/by-partuuid/5e6f8da9-1c22-4512-b67a-cc7c4578fbb8";
      randomEncryption.enable = true;
    }];

    networking.hostName = "charlie";
    system.stateVersion = "26.05"; # Did you read the comment?

    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    programs.niri.enable = true;
    programs.fish.enable = true;
    programs.yazi.enable = true;

    virtualisation.docker.enable = true;

    users.users.sara = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" ];
      shell = pkgs.fish;
    };

    systemd.user.tmpfiles.users.sara.rules = map
      (d: "L+ %h/.config/${d} - - - - %h/dotfiles/${d}")
      [ "alacritty" "niri" "fish" "nvim" "tmux" "waybar" "wpaperd" "swaync" "fuzzel" ];

    environment.systemPackages = with pkgs; [
      vim
      playerctl
      wget
      git
      brave
      alacritty
      fuzzel
      zip
      tree
      neovim
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
    ];

    security.pam.services.swaylock = {};
}
