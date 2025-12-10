{
  description = "Tomasxs NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-for-stremio.url = "nixpkgs/5135c59491985879812717f4c9fea69604e7f26f";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # 1. NixOS Configuration (Camaragibe)
      nixosConfigurations = {
        camaragibe = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/camaragibe/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                themeVariant = "dark";
              };
              home-manager.users.tomasxs = import ./home/home.nix;
            }
          ];
        };
      };

      # 2. Standalone Configuration (Moreno)
      homeConfigurations = {
        # The format "username@hostname" allows home-manager to auto-detect this config
        "tomasxs@moreno" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            themeVariant = "dark";
          };
          modules = [
            ./hosts/moreno/home.nix
          ];
        };
      };
    };
}
