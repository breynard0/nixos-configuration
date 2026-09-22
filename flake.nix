{
  description = "Main System Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-old.url = "github:nixos/nixpkgs?ref=nixos-25.11";

    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    affinity-nix.url = "github:mrshmllow/affinity-nix";

    nixvim.url = "github:nix-community/nixvim/nixos-26.05";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    taut.url = "github:jeremy46231/taut";

    claude-code.url = "github:sadjow/claude-code-nix";
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.forall.systems"
    ];
    extra-trusted-public-keys = [
      "cache.forall.systems:5PmD7QO4MSF8YgyRZtkSGXRDo96H3bybIf2SsQh8ScI="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixvim,
      claude-code,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.breynard-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          inputs.nix-flatpak.nixosModules.nix-flatpak

          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ claude-code.overlays.default ];

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit
                inputs
                pkgs-unstable
                ;
            };
            home-manager.sharedModules = [
              nixvim.homeModules.nixvim
            ];

            home-manager.users.breynard = import ./home.nix;
          }
        ];
      };
    };
}
