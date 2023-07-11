{ pkgs }:
{
  deps1 = with pkgs; [
    nodePackages.typescript-language-server
  ];
  deps2 = with pkgs; [
    nodejs-18_x
    python3Full
    lazygit
    unzip
    wget
    fd
    ripgrep
    tree-sitter
  ];
}
