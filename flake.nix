{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    neovim-stable = {
      url = "github:neovim/neovim/stable?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, neovim-stable, neovim-nightly }: 
    let
      systems = [
        "x86_64-linux"
      ];
      forEachSystem = nixpkgs.lib.genAttrs systems;
    in {
      packages = forEachSystem (
        system: let
          pkgs = nixpkgs.legacyPackages.${system};
          nvim-stable = neovim-stable.packages.${system}.default;
          nvim-nightly = neovim-nightly.packages.${system}.default;
          configured-nvim-stable = pkgs.callPackage ./packages/configured-nvim.nix {
            inherit pkgs;
            nvim = nvim-stable;
          };
          configured-nvim-nightly = pkgs.callPackage ./packages/configured-nvim.nix {
            inherit pkgs;
            nvim = nvim-nightly;
          };
        in {
          inherit configured-nvim-stable configured-nvim-nightly;
          default = configured-nvim-stable;
        }
      );

      defaultPackage = forEachSystem (system: self.packages.${system}.configured-nvim-stable);

      #apps.x86_64-linux.default = {
        #type = "app";
        #program = "${pkgs.myNeovim}/bin/nvim";
      #};

      homeManagerModules.default = import ./home-manager/modules/configured-nvim.nix self;
    };
}
