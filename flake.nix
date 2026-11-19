{
  description = "Main System Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixvim.url = "github:nix-community/nixvim/nixos-26.05";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    taut = {
      url = "github:jeremy46231/taut";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comfyui-nix.url = "github:utensils/comfyui-nix";

    ableton-linux.url = "github:shibco/ableton-linux";

    claude-desktop = {
      url = "github:aaddrick/claude-desktop-debian";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gappie-dashboard = {
      url = "git+ssh://git@github.com/breynard0/gappie-dashboard";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    myreview = {
      url = "path:/home/breynard/Agentic/MyReview";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      inherit (self.nixosConfigurations.breynard-laptop) pkgs;
    in
    {
      nixosConfigurations.breynard-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.nix-index-database.nixosModules.default
          inputs.gappie-dashboard.nixosModules.default

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.sharedModules = [
              nixvim.homeModules.nixvim
            ];

            home-manager.users.breynard = import ./home.nix;
          }
        ];
      };

      packages.${system} = import ./pkgs { inherit pkgs inputs; };

      formatter.${system} = pkgs.nixfmt-tree;

      templates = {
        stm32-rust = {
          path = ./templates/stm32-rust;
          description = "Embedded Rust for STM32 with probe-rs";
        };
        rust = {
          path = ./templates/rust;
          description = "Rust with rustup";
        };
        python = {
          path = ./templates/python;
          description = "Python with uv";
        };
        bun = {
          path = ./templates/bun;
          description = "TypeScript with bun";
        };
        godot = {
          path = ./templates/godot;
          description = "Godot 4";
        };
      };
    };
}
