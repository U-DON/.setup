return {
  -- Vim

  ''
  'joshdick/onedark.vim',

  {
    'junegunn/fzf',
    dir = '~/.fzf',
    build = './install all',
  },

  'junegunn/fzf.vim',
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-sensible',
  'tpope/vim-surround',
  'vim-airline/vim-airline',

  -- Neovim

  {
    'akinsho/bufferline.nvim',
    opts = {
      options = {
        mode = 'tabs',
        numbers = 'ordinal',

        offsets = {
          {
            filetype = 'NvimTree',
            text_align = 'left',
          }
        },

        show_close_icon = true,
        sort_by = 'tabs',
      }
    },
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
    },
    opts = function()
      local cmp = require('cmp')

      return {
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),

          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
          },
        }),

        sources = {
          { name = 'buffer' },
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        },
      }
    end
  },

  'kyazdani42/nvim-web-devicons',

  {
    'kyazdani42/nvim-tree.lua',
    opts = {
      view = { preserve_window_proportions = true },
    },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'c_sharp',
        'cmake',
        'cpp',
        'css',
        'dockerfile',
        'elixir',
        'go',
        'graphql',
        'haskell',
        'hcl',
        'html',
        'java',
        'javascript',
        'jsdoc',
        'json',
        'kotlin',
        'lua',
        'make',
        'markdown',
        'perl',
        'php',
        'python',
        'r',
        'regex',
        'ruby',
        'rust',
        'scala',
        'scss',
        -- 'swift',
        'terraform',
        'tsx',
        'typescript',
        'vim',
        'yaml',
      },

      highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },

      indent = { enable = true },
      autotag = { enable = true },
    },
  },

  {
    'mason-org/mason-lspconfig.nvim',
    opts = {},
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'neovim/nvim-lspconfig',
    },
    opts = { automatic_installation = true },
  },

  {
    'olimorris/codecompanion.nvim',
    version = '^18.0.0',
    opts = {},
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {
      map_c_h = true, -- Map the <C-h> key to delete a pair
      map_c_w = true, -- Map <C-w> to delete a pair if possible
    },
  },

  'windwp/nvim-ts-autotag',
}
