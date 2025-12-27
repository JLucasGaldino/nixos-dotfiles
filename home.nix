{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    qtile = "qtile";
    nvim = "nvim";
    rofi = "rofi";
    mango = "mango";
    foot = "foot";
    walls = "walls";
    emacs = "emacs";
    doom = "doom";
  };
  rebuild_script = pkgs.writeShellApplication {
    name = "rebuild";
    text = ''
    sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixie
    '';
  };
in
{ 
  home.username = "lucas";
  home.homeDirectory = "/home/lucas";
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "JLucasGaldino";
        email = "lucasgaldino@tuta.io";
      };
      init.defaultBranch = "main";
    };
  };
  home.stateVersion = "25.11";
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use nixos, btw";
    };
  };
  programs.fish.enable = true;
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraConfig = ''
      (setq standard-indent 2)
    '';
  };

  xdg.configFile = builtins.mapAttrs 
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    }) 
    configs;

  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    rofi
    librewolf
    anki
    croc
    fishPlugins.pure
    macchina
    pass
    pinentry-curses
    swaynotificationcenter
    libnotify
    thunderbird
    rebuild_script
  ];
}
