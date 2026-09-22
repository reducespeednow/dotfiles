{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "charlie";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sara = {
    isNormalUser = true;
    extraGroups = [ "wheel" "sudo" "networkmanager" ];
    shell = pkgs.fish;
  };

  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    git
    brave
    alacritty
    fuzzel
  ];

  nixpkgs.config.allowUnfree = true;

  programs.niri.enable = true;
  programs.fish.enable = true;
  programs.nix-ld.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05";
  security.pam.services.swaylock = {};

  stylix = {
      enable = true;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  };

  xdg.portal = {
  enable = true;
  extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser ];
  config.niri."org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
  };
}

