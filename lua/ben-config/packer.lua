-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.8',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }
  use({
	  'rose-pine/neovim',
	  as = 'rose-pine',
	  config = function()
		  vim.cmd('colorscheme rose-pine')
	  end

  })
  use ({'nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'}})
  use ('nvim-treesitter/playground')
  use "nvim-lua/plenary.nvim"
  use {
	  "ThePrimeagen/harpoon",
	  branch = "harpoon2",
	  requires = { {"nvim-lua/plenary.nvim"} }
  }
  use ('mbbill/undotree')
  use ('tpope/vim-fugitive')
  use {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require('lspconfig')
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          }
        }
      })
      lspconfig.pyright.setup({})
      lspconfig.clangd.setup({})
    end
  }
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    }
  }
  use ("ray-x/lsp_signature.nvim")
  use {
	  "windwp/nvim-autopairs",
	  config = function()
		  require("nvim-autopairs").setup {}
	  end,
  }
  use "tpope/vim-commentary"
end)
