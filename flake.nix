{
  description = "Tomasxs NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-for-stremio.url = "nixpkgs/5135c59491985879812717f4c9fea69604e7f26f";
    nixgl.url = "github:nix-community/nixGL";
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
      nixgl,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ nixgl.overlay ];
      };
      mkNixosHost =
        hostModule:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            hostModule
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
    in
    {
      # 1. NixOS Configuration
      nixosConfigurations = {
        camaragibe = mkNixosHost ./hosts/camaragibe/default.nix;
        new-machine = mkNixosHost ./hosts/new-machine/default.nix;
        new-machine-minimal = mkNixosHost ./hosts/new-machine/minimal.nix;
        new-machine-gaming = mkNixosHost ./hosts/new-machine/gaming.nix;
      };

      # 2. Standalone Configurations
      homeConfigurations = {
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
        "tomasxs@recife" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            themeVariant = "dark";
          };
          modules = [ ./hosts/recife/home.nix ];
        };
        "tomasxs@wsl" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            themeVariant = "dark"; # Defaults to dark theme
          };
          modules = [ ./hosts/wsl/home.nix ];
        };
      };
    };
}
