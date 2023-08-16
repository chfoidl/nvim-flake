self: { 
  config, 
  lib, 
  pkgs, 
  ... 
}:

with lib;

let
  cfg = config.programs.configured-nvim;
  configured-nvim-stable = self.packages.${pkgs.stdenv.hostPlatform.system}.configured-nvim-stable;
  configured-nvim-nightly = self.packages.${pkgs.stdenv.hostPlatform.system}.configured-nvim-nightly;
in {
  options = {
    programs.configured-nvim = {
      enable = mkEnableOption "Configured NeoVim";

      #package = mkOption {
        #type = nullOr types.package;
        #default = null;
      #};

      useNightly = mkEnableOption "Use nightly NeoVim build";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      optional (!cfg.useNightly) configured-nvim-stable
      ++ optional (cfg.useNightly) configured-nvim-nightly;
  };
}
