{
  description = "Tomasxs NixOS Flake";

  inputs = {
    # Using unstable as requested for latest packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensures version compatibility
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # Host: camaragibe
      camaragibe = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          # Host specific config
          ./hosts/camaragibe/default.nix

          # Home Manager Module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.tomasxs = import ./home/home.nix;
          }
        ];
      };
    };
  };
}
