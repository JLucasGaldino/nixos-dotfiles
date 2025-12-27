{
    description = "flake file";
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-25.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
	mango = {
	  url = "github:DreamMaoMao/mango";
	  inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, mango, ... } @ inputs: {
        nixosConfigurations.nixie = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
	    specialArgs = { inherit inputs; };
            modules = [
                ./configuration.nix
                home-manager.nixosModules.home-manager
                {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.lucas = import ./home.nix;
                        backupFileExtension = "backup";
                    };
                }
		mango.nixosModules.mango
                {
                  programs.mango.enable = true;
                }
            ];
        };
    };
}
