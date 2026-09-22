{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
        url = "github:nix-community/stylix/release-26.05";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, stylix, ... }: {
    nixosConfigurations.charlie = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/nixos/configuration.nix
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.sara = import ./home.nix;
        }
      ];
    };
  };
}
