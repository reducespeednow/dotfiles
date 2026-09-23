{ config, lib, pkgs, ... }:

{
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/London";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.niri.enable = true;
  programs.fish.enable = true;

  users.users.sara = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    brave
    alacritty
    fuzzel
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
    yazi
    waybar
    swaynotificationcenter
    wpaperd
    networkmanagerapplet
  ];

  security.pam.services.swaylock = {};
}
