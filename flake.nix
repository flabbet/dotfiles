{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

     hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
     
     nixvim = {
    url = "github:nix-community/nixvim";
    # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
    # url = "github:nix-community/nixvim/nixos-24.11";

    inputs.nixpkgs.follows = "nixpkgs";
  };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      nixos-flabbet = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
	specialArgs = { 
	inherit inputs; 
	};
        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
	    home-manager.backupFileExtension = "backup";

            home-manager.users.flabbet = import ./home.nix;
	    home-manager.extraSpecialArgs = { inherit inputs; }; 
          }
        ]; 
      };
    };
  };
}
