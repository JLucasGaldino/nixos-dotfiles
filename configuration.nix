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
  services.udisks2.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.epson-escpr2
    pkgs.epson-escpr
  ];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];  # For network/Wi-Fi scanning


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
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        options.tabstop = 2;
        theme.enable = true;
        theme.name = "everforest";
        theme.style = "medium";
        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        languages = {
          nix.enable = true;
          nix.lsp.enable = true;
          nix.lsp.servers = [ "nixd" ];
          nix.treesitter.enable = true;
          ts.enable = true;
          rust.enable = true;
          rust.lsp.enable = true;
          rust.treesitter.enable = true;
        };
        binds = {
          whichKey.enable = true;
        };
      }; 
    };
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
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    helix
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    fira-sans
    libertinus
    emacs-all-the-icons-fonts
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

