{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixie"; 
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Madrid";

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
    };
  };
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };
  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
    windowManager.qtile.enable = true;
  };
  services.illum = {
    enable = true;
  };

  users.users.lucas = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;
  programs.fish.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
    enableSSHSupport = true;
  };

  environment.shells = [ pkgs.fish pkgs.bashInteractive ];
  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
    alacritty
    foot
    wmenu
    wl-clipboard
    grim
    slurp
    swaybg
    waybar
    pavucontrol
    pamixer
    bluez
    bluez-tools
    cmatrix
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    fira-sans
  ];

  nix.settings = { 
    experimental-features = [ "nix-command" "flakes" ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  system.stateVersion = "25.11"; 

}

