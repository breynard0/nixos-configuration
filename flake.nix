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

    nixvim.url = "github:nix-community/nixvim/nixos-26.05";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    taut.url = "github:jeremy46231/taut";

    paseo = {
      url = "github:getpaseo/paseo";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    claude-code.url = "github:sadjow/claude-code-nix";

    ableton-linux.url = "github:shibco/ableton-linux";

    myreview = {
      url = "path:/home/breynard/Agentic/MyReview";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
