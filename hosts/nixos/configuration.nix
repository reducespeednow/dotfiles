{ config, lib, pkgs, ... }:

{
    imports = [ ./theme.nix ];
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/London";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.niri.enable = true;
  programs.fish.enable = true;
  programs.yazi.enable = true;

  users.users.sara = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    vim
    playerctl
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
    waybar
    swaynotificationcenter
    wpaperd
    networkmanagerapplet
  ];

  security.pam.services.swaylock = {};
}
