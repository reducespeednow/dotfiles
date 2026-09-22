{ config, pkgs, ... }:
let
  link = p: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${p}";
in {
  home.username = "sara";
  home.homeDirectory = "/home/sara";
  home.stateVersion = "26.05";

  services.swaync.enable = true;
  services.network-manager-applet.enable = true;

  services.wpaperd = {
      enable = true;
      settings.default = {
          path = "/home/sara/dotfiles/wallpapers";
          duration = "30m";
      };
  };

  programs.yazi = {
      enable = true;
      enableFishIntegration = true;
  };

  programs.waybar = {
      enable = true;
      settings.main = {
          layer = "top";
          position = "top";
          height = 24;
          modules-left = ["niri/workspaces"];
          modules-center = ["clock"];
          modules-right = ["tray" "backlight" "pulseaudio" "battery"];
          backlight.format = "bri {percent}%";
          clock.format = "{:%a %d %b  %H:%M}";
          pulseaudio.format = "vol {volume}%";
          battery.format = "bat {capacity}%";
          tray.spacing = 8;
      };
  };

  xdg.configFile = {
    "fish".source = link "fish";
    "nvim".source = link "nvim";
    "niri".source = link "niri";
    "tmux".source = link "tmux";
  };

  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text =
    let
      picker = pkgs.writeShellScript "yazi-picker" ''
        # args: multiple directory save path out
        exec alacritty -e yazi --chooser-file="$5" "$4"
      '';
    in ''
      [filechooser]
      cmd=${picker}
      default_dir=$HOME
    '';

  home.packages = with pkgs; [
    fastfetch neovim gcc ripgrep fd unzip tree-sitter lua-language-server wget swaylock libnotify tmux brightnessctl
  ];
}
