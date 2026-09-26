{
  pkgs,
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
  ];

  security.pam.services.swaylock = { };
}
