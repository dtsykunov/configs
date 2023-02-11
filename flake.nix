{
  description = "A flake that describes my personal development environment.";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux = {
      inherit (import nixpkgs { system = "x86_64-linux"; })
        fzf
        git
        nixpkgs-fmt
        pyright
        ripgrep
        rnix-lsp
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
          lsp-zero = pkgs.vimUtils.buildVimPluginFrom2Nix {
            name = "lsp-zero";
            src = pkgs.fetchFromGitHub {
              owner = "VonHeikemen";
              repo = "lsp-zero.nvim";
              rev = "40bbc05";
              sha256 = "sha256-ik2YijE254M5R6lSI/YfhBtN0iN5fhKjl5AiOn5vVCI=";
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
              set mouse=
              colorscheme abscs
              set signcolumn=yes
              if filereadable(expand("~/.config/nvim/init.lua"))
                  lua require('dima')
              endif
            '';
            packages.myPlugins = with pkgs.vimPlugins; {
              start = [
                (nvim-treesitter.withPlugins (
                  plugins: with plugins; [
                    help
                    javascript
                    nix
                    python
                    html
                  ]
                ))
                abscs
                cmp-nvim-lsp
                commentary
                fugitive
                lsp-zero
                luasnip
                nvim-cmp
                nvim-lspconfig
                telescope-nvim
              ];
            };
          };
        }
      );
    };
  };
}
