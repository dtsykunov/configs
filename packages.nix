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
  neovim = pkgs.neovim.override (
    let
      abscs = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "abcsc";
        src = pkgs.fetchFromGitHub {
          owner = "Abstract-IDE";
          repo = "Abstract-cs";
          rev = "4f19d4b1bf7bd0cfc0f820cbbec7e9285088f700";
          sha256 = "sha256-tENdnmP0NRoLApJZlRzkgjG6dva03sptJaaKOdyc/wo";
        };
      };
    in
    {
      viAlias = true;
      vimAlias = true;

      # if you set configure attribute ~/.config/nvim/init.lua will not be sourced
      # however, lua modules inside ~/.config/nvim are found
      configure = {
        customRC = ''
          colorscheme abscs
          if filereadable(expand("~/.config/nvim/init.lua"))
              lua require('dima')
          endif
        '';
        packages.myPlugins = with pkgs.vimPlugins; {
          start = [
            (nvim-treesitter.withPlugins (
              plugins: with plugins; [
                nix
                python
                help
              ]
            ))
            telescope-nvim
            abscs
          ];
        };
      };
    }
  );

  gtypist-single-space = pkgs.gtypist.overrideAttrs (_:
    let
      single-space-files = pkgs.fetchFromGitHub {
        owner = "inaimathi";
        repo = "gtypist-single-space";
        rev = "2bdf2f417c81f3243822f1a8fc38c3143a98cb0b";
        sha256 = "sha256-vkRKGi/U18QLoSlM96IwKQZNkc+fHrynGi8nhrO+LhU";
      };
    in
    {
      fixupPhase = ''
        cp -f ${single-space-files}/*.typ $out/share/gtypist
      '';
    });
}
