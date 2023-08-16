{ pkgs, nvim }:
pkgs.writeShellApplication {
  name = "nvim";
  runtimeInputs = with pkgs; [ 
    nodejs-18_x
    python3Full
    lazygit
    unzip
    wget
    fd
    ripgrep
    tree-sitter
  ];
  text = ''
    ${nvim}/bin/nvim "$@"
  '';
}
