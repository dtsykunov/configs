vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        requires = {{'nvim-lua/plenary.nvim'}}
    }
--    use({'nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'}})
    use({
        'Abstract-IDE/Abstract-cs',
        config = function() vim.cmd('colorscheme abscs') end
    })
end)
