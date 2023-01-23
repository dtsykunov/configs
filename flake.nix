{
  description = "A flake that describes my personal development environment.";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux = {
      inherit (import nixpkgs { system = "x86_64-linux"; })
        fzf
        git
        nixpkgs-fmt
        ripgrep
        tree
        ;

      neovim = with (import nixpkgs { system = "x86_64-linux"; });  neovim.override (
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
              set mouse=
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
                abscs
                fugitive
                telescope-nvim
              ];
            };
          };
        }
      );
    };
  };
}
