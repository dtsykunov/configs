{ pkgs ? import <nixpkgs> { } }:
{
  inherit (pkgs)
    exa
    fd
    fzf
    git
    luaformatter
    nixpkgs-fmt
    ripgrep
    tree
    zsh# i had to do '$ command -v zsh | sudo tee -a /etc/shells'
    zsh-fast-syntax-highlighting
    ;
  neovim = pkgs.neovim.override ({
    viAlias = true;
    vimAlias = true;
    # if you set configure attribute ~/.config/nvim/init.lua will not be sourced
  });

  gtypist-single-space = pkgs.gtypist.overrideAttrs (_: rec {
    single-space-files = pkgs.fetchFromGitHub {
      owner = "inaimathi";
      repo = "gtypist-single-space";
      rev = "master";
      sha256 = "sha256-vkRKGi/U18QLoSlM96IwKQZNkc+fHrynGi8nhrO+LhU";
    };
    fixupPhase = ''
      cp -f ${single-space-files}/*.typ $out/share/gtypist
    '';
  });
}
