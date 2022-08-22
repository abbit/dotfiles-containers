-- Automatically install packer
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = vim.fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

return packer.startup(function(use)
    use "wbthomason/packer.nvim"

    use {
        "kylechui/nvim-surround",
        config = function() require("nvim-surround").setup() end
    }
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup() end
    }
    use {
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end
    }

     use {
        "akinsho/toggleterm.nvim",
        tag = 'v2.*',
        config = function()
            require("toggleterm").setup()
            function _G.set_terminal_keymaps()
                local opts = {buffer = 0}
                vim.keymap.set('t', '<C-[>', [[<C-\><C-n>]], opts)
                vim.keymap.set('t', '<ESC>', [[<C-\><C-n>]], opts)
                vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
                vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
                vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
                vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
            end

            -- if you only want these mappings for toggle term use term://*toggleterm#* instead
            vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
        end
    }


    -- Automatically set up configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
