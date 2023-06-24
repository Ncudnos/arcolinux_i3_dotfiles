set number
set autochdir
set undofile
set signcolumn=yes
set ruler
set cursorline
syntax on
filetype plugin indent on
set bs=2
set smartindent
set wildmenu
set relativenumber
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set encoding=UTF-8
set mouse=a
set title
set ignorecase
set nobackup
set nowb
set noswapfile
set splitbelow
set splitright
set laststatus=2
set background=dark

""ctags
command! MakeTags !ctags -R .

call plug#begin()

Plug 'ervandew/supertab' 
Plug 'nvim-lua/plenary.nvim' 
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' } 
Plug 'kyazdani42/nvim-web-devicons' 
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'             " Required
Plug 'williamboman/mason.nvim'           " Optional
Plug 'williamboman/mason-lspconfig.nvim' " Optional
Plug 'hrsh7th/nvim-cmp'         " Required
Plug 'hrsh7th/cmp-nvim-lsp'     " Required
Plug 'hrsh7th/cmp-buffer'       " Optional
Plug 'hrsh7th/cmp-path'         " Optional
Plug 'saadparwaiz1/cmp_luasnip' " Optional
Plug 'hrsh7th/cmp-nvim-lua'     " Optional
Plug 'L3MON4D3/LuaSnip'             " Required
Plug 'rafamadriz/friendly-snippets' " Optional
Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v1.x'}
Plug 'windwp/nvim-autopairs'
Plug 'iamcco/markdown-preview.nvim'
Plug 'mzlogin/vim-markdown-toc'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'tjdevries/colorbuddy.nvim'
Plug 'svrana/neosolarized.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'kdheepak/tabline.nvim'


call plug#end()

lua <<EOF
local lsp = require('lsp-zero').preset({
  name = 'minimal',
  set_lsp_keymaps = true,
  manage_nvim_cmp = true,
  suggest_lsp_servers = false,
})

lsp.setup()
EOF

nnoremap <C-s> :w<Enter>
nnoremap <C-a> ggVG
vnoremap <C-c> :'<.'>%y+<Enter>
nnoremap <C-q> :bdelete!<Enter>
nnoremap <C-w> :q!<Enter>
nnoremap <C-z> :u<Enter>
nnoremap <C-d> :%d<Enter>
nnoremap <C-n> :Telescope file_browser<Enter>
nnoremap <TAB> :bnext<Enter>
nnoremap <C-f> :%s/
nnoremap <C-y> :noh<Enter>
nnoremap <silent> vim :e $MYVIMRC<TAB><cr>
nnoremap <silent> ;; :Telescope oldfiles<cr>

" Find files using Telescope command-line sugar.
nnoremap <silent>;g <cmd>Telescope live_grep<cr>
nnoremap <silent>;h <cmd>Telescope help_tags<cr>

if exists("&termguicolors") && exists("&winblend")
    syntax enable
    set termguicolors
    set winblend=10
    set wildoptions=pum
    set pumblend=20
    set background=dark
endif

lua << EOF

local status, telescope = pcall(require, "telescope")
if (not status) then return end
local actions = require('telescope.actions')
local builtin = require("telescope.builtin")

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local fb_actions = require "telescope".extensions.file_browser.actions

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
  },
  extensions = {
    file_browser = {
      theme = "dropdown",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        -- your custom insert mode mappings
        ["i"] = {
          ["<C-w>"] = function() vim.cmd('normal vbd') end,
        },
        ["n"] = {
          -- your custom normal mode mappings
          ["N"] = fb_actions.create,
          ["h"] = fb_actions.goto_parent_dir,
          ["/"] = function()
            vim.cmd('startinsert')
          end
        },
      },
    },
  },
}

telescope.load_extension("file_browser")

vim.keymap.set("n", "sf", function()
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    -- previewer = true,
    initial_mode = "normal",
    layout_config = { height = 20 }
  })
end)

telescope.load_extension("file_browser")

vim.keymap.set('n', ';f',
  function()
    builtin.find_files({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
      no_ignore = false,
      hidden = true,
    })
  end)

EOF

lua << EOF
require 'Comment'.setup{}
EOF

lua<<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "rust", "cpp", "html", "css", "python" },
  sync_install = false,
  auto_install = false,
  ignore_install = { "javascript" },
  highlight = {
    enable = true,
    disable = { "c", "rust" },
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
    additional_vim_regex_highlighting = false,
  },
}
EOF

lua << EOF
require("nvim-autopairs").setup {}
EOF

let g:vmt_insert_anchors = 1
let g:vmt_auto_update_on_save = 1

lua << EOF
require'colorizer'.setup()
EOF

lua << EOF

local lspconfig = require('lspconfig')
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)

    vim.diagnostic.config({
        virtual_text=true,
        signs=true,
        float= {boder="single"},
    })

  end,
})

EOF

lua << EOF

local status, n = pcall(require, "neosolarized")
if (not status) then return end

n.setup({
  comment_italics = true,
})

local cb = require('colorbuddy.init')
local Color = cb.Color
local colors = cb.colors
local Group = cb.Group
local groups = cb.groups
local styles = cb.styles

Color.new('white', '#ffffff')
Color.new('black', '#000000')
Group.new('Normal', colors.base1, colors.NONE, styles.NONE)
Group.new('CursorLine', colors.none, colors.base03, styles.NONE, colors.base1)
Group.new('CursorLineNr', colors.yellow, colors.black, styles.NONE, colors.base1)
Group.new('Visual', colors.none, colors.base03, styles.reverse)

local cError = groups.Error.fg
local cInfo = groups.Information.fg
local cWarn = groups.Warning.fg
local cHint = groups.Hint.fg

Group.new("DiagnosticVirtualTextError", cError, cError:dark():dark():dark():dark(), styles.NONE)
Group.new("DiagnosticVirtualTextInfo", cInfo, cInfo:dark():dark():dark(), styles.NONE)
Group.new("DiagnosticVirtualTextWarn", cWarn, cWarn:dark():dark():dark(), styles.NONE)
Group.new("DiagnosticVirtualTextHint", cHint, cHint:dark():dark():dark(), styles.NONE)
Group.new("DiagnosticUnderlineError", colors.none, colors.none, styles.undercurl, cError)
Group.new("DiagnosticUnderlineWarn", colors.none, colors.none, styles.undercurl, cWarn)
Group.new("DiagnosticUnderlineInfo", colors.none, colors.none, styles.undercurl, cInfo)
Group.new("DiagnosticUnderlineHint", colors.none, colors.none, styles.undercurl, cHint)

Group.new("HoverBorder", colors.yellow, colors.none, styles.NONE)

EOF

lua << EOF

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'solarized_dark',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}


require'tabline'.setup {
      enable = true,
      options = {
        section_separators = {'', ''},
        component_separators = {'', ''},
        max_bufferline_percent = 66, 
        show_tabs_always = false, 
        show_devicons = true,
        show_bufnr = false,
        show_filename_only = false,
        modified_icon = "+ ",
        modified_italic = false,
        show_tabs_only = false,
      }
    }

EOF

