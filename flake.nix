{
  description = "Tomasxs NixOS Flake";

  inputs = {
    # Using unstable as requested for latest packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # see: https://github.com/NixOS/nixpkgs/issues/437992#issuecomment-3380880457
    nixpkgs-for-stremio.url = "nixpkgs/5135c59491985879812717f4c9fea69604e7f26f";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensures version compatibility
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
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
