{ pkgs ? import <nixpkgs> { }}: 
{
	inherit (pkgs)
        exa
        fd
        fzf
        git
        gtypist
        luaformatter
        nixpkgs-fmt
        ripgrep
        tree
        zsh # i had to do '$ command -v zsh | sudo tee -a /etc/shells'
        zsh-fast-syntax-highlighting
		;
	neovim = pkgs.neovim.override ({
		viAlias = true;
		vimAlias = true;

        # if you set configure attribute than ~/.config/nvim/init.lua will not be sourced
	});
}
