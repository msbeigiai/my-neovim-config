-- init.lua

-- Basic Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'
-- Leader key
vim.g.mapleader = ','

-- Plugin Manager Setup
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  -- Packer
  use 'wbthomason/packer.nvim'
  use {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()
  end
}

  -- LSP and Autocompletion
  use 'neovim/nvim-lspconfig'               
  use 'hrsh7th/nvim-cmp'                    
  use 'hrsh7th/cmp-nvim-lsp'                
  use 'hrsh7th/cmp-buffer'                  
  use 'saadparwaiz1/cmp_luasnip'            
  use 'L3MON4D3/LuaSnip'                    
  use { "catppuccin/nvim", as = "catppuccin" }

  -- Scala (Metals)
  use { 'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" } }

  -- Treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  -- File Explorer
  use {
   'nvim-tree/nvim-tree.lua',
   requires = {
     'nvim-tree/nvim-web-devicons', -- optional
   },
  }
  use 'nvim-tree/nvim-web-devicons'

  -- Status Line
  use 'nvim-lualine/lualine.nvim'

  -- Telescope
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.8', requires = { {'nvim-lua/plenary.nvim'} } }


  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
      require("toggleterm").setup()
  end}
  -- Color Themes
  use 'morhetz/gruvbox'
  use 'joshdick/onedark.vim'
  use 'dracula/vim'

  -- Git Integration
  use 'tpope/vim-fugitive'
  use 'lewis6991/gitsigns.nvim'

  -- Autopairs
  use 'windwp/nvim-autopairs'

  -- Debugger
  use 'mfussenegger/nvim-dap'

  use {
  'ray-x/lsp_signature.nvim',
  config = function()
    require('lsp_signature').setup({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      floating_window = true, -- Use a floating window for the signature.
      hint_enable = false, -- Disable virtual text hints
      handler_opts = {
        border = "rounded"   -- Rounded borders for the floating window
      },
      extra_trigger_chars = { "(", "," }, -- Trigger signature help on '(' and ','
    })
  end
}

  use {
  'iamcco/markdown-preview.nvim',
  run = function() vim.fn['mkdp#util#install']() end
}

end)

-- Colorscheme
-- vim.cmd [[colorscheme vim]]
-- colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
vim.cmd.colorscheme "catppuccin"

-- Lualine
require('lualine').setup {
  options = {
    theme = 'gruvbox',
    section_separators = '',
    component_separators = ''
  }
}

-- NvimTree
require('nvim-tree').setup {
  -- view = {
  --   width = 30,
  --   side = 'left',
  --   mappings = {
  --     list = {
  --       { key = "s", action = "vsplit"},
  --       { key = "i", action = "split"}
  --     },
  --   },
  -- },
  -- filters = {
  --   dotfiles = false,
  -- },
}
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { "scala", "cpp", "lua", "json", "html", "css", "bash" },
  highlight = {
    enable = true,
  },
}

-- Autopairs
require('nvim-autopairs').setup{}

-- Comment.nvim
require('Comment').setup{
  mappings = {
    basic = true, -- basic mappings (gc, gcc) are enabled
    extra = true, -- additional mappings (gco, gcA)
  }
}

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<C-f>', builtin.live_grep, {})

-- LSP and Autocompletion
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),  
    ['<C-f>'] = cmp.mapping.scroll_docs(4),   
    ['<C-Space>'] = cmp.mapping.complete(),   
    ['<CR>'] = cmp.mapping.confirm({ select = true }),  
    ['<Tab>'] = cmp.mapping.select_next_item(),  
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),  
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },    
    { name = 'luasnip' },     
  }, {
    { name = 'buffer' },      
  })
})

-- LSP Capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- LSP Key Mappings
local on_attach = function(client, bufnr)
  -- Set keybindings for LSP functionality
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- Key mappings
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.api.nvim_set_keymap('n', '<leader>rd', ':MetalsRunDoctor<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>trm', ':ToggleTerm<CR>', { noremap = true, silent = true })
  -- Keybinding to manually insert Scala package declaration
  vim.api.nvim_set_keymap('n', '<leader>ip', ':lua InsertScalaPackage()<CR>', { noremap = true, silent = true })

  -- Diagnostics
  vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, opts)

  vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<leader>p', ':MarkdownPreview<CR>', { noremap = true, silent = true })
    -- Disable macro recording and playback if you never use it
  vim.api.nvim_set_keymap('n', 'q', '<Nop>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '@', '<Nop>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })

  -- Move left, right, up, down in insert mode
  vim.api.nvim_set_keymap('i', '<C-h>', '<Left>', { noremap = true })
  vim.api.nvim_set_keymap('i', '<C-l>', '<Right>', { noremap = true })
  vim.api.nvim_set_keymap('i', '<C-j>', '<Down>', { noremap = true })
  vim.api.nvim_set_keymap('i', '<C-k>', '<Up>', { noremap = true })

-- Move to beginning/end of line in insert mode
  vim.api.nvim_set_keymap('i', '<C-a>', '<Home>', { noremap = true })
  vim.api.nvim_set_keymap('i', '<C-e>', '<End>', { noremap = true })
-- Jump between words in insert mode
  vim.api.nvim_set_keymap('i', '<C-b>', '<C-o>b', { noremap = true })
  vim.api.nvim_set_keymap('i', '<C-w>', '<C-o>w', { noremap = true })
  -- vim.api.nvim_set_keymap('i', '<CR>', '<Esc>A<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('i', '<C-o>', '<Esc>o', { noremap = true, silent = true })


end

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- Scala (Metals)
local metals_config = require("metals").bare_config()
metals_config.settings = {
  showImplicitArguments = true,
  showInferredType = true,
}
metals_config.init_options.statusBarProvider = "on"
metals_config.capabilities = capabilities
metals_config.on_attach = on_attach
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
})

-- Function to insert package declaration
function InsertScalaPackage()
  -- Get the full path of the current file
  local filepath = vim.fn.expand('%:p')

  -- Extract the path starting after 'src/main/scala/'
  local package_path = filepath:match("/src/main/scala/(.*)/.*.scala")

  if package_path then
    -- Replace '/' with '.' to format as package declaration
    local package_name = package_path:gsub("/", ".")

    -- Add the 'package' keyword
    local package_declaration = "package " .. package_name

    -- Insert the package declaration at the top of the file
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { package_declaration, "" })
  end
end


-- C++ (Clangd)
require('lspconfig').clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Gitsigns
require('gitsigns').setup()

