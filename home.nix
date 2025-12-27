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
  pdf_page_count_in_dir_script = pkgs.writeShellApplication {
    name = "pdf_page_count_in_dir";
    text = ''
      #!/usr/bin/env bash
      # Directory to search for PDF files (default is current directory)
      dir="''${1:-.}"
      # Initialize a variable to hold the total page count
      total_pages=0
      # Loop through all PDFs in the specified directory
      for pdf in "$dir"/*.pdf; do
          # Check if the file exists (in case no PDFs are found)
          if [[ -f "$pdf" ]]; then
              # Get the number of pages in the PDF using pdfinfo
              pages=$(${pkgs.poppler-utils}/bin/pdfinfo "$pdf" | grep "Pages" | awk '{print $2}')
              # Add the pages to the total count
              total_pages=$((total_pages + pages))
          fi
      done
      # Output the total number of pages
      echo "$total_pages"
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
    poppler-utils
    pdf_page_count_in_dir_script
  ];
}
