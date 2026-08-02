vim.g.mapleader = " "
vim.g.maplocalleader = ","

local opt = vim.opt
opt.number = true
opt.relativenumber = false
opt.cursorline = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.termguicolors = true
opt.hidden = true
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.smartindent = true
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.breakindent = true
opt.timeout = true
opt.timeoutlen = 300

local keymap = vim.keymap.set

keymap("n", "<leader>w", ":w<CR>", { desc = "Write buffer" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", ":qa!<CR>", { desc = "Force quit all" })
keymap("n", "<leader>h", "<C-w>h", { desc = "Focus left window" })
keymap("n", "<leader>j", "<C-w>j", { desc = "Focus down window" })
keymap("n", "<leader>k", "<C-w>k", { desc = "Focus up window" })
keymap("n", "<leader>l", "<C-w>l", { desc = "Focus right window" })
keymap("n", "<leader>sv", ":vsplit<CR>", { desc = "Split vertically" })
keymap("n", "<leader>sh", ":split<CR>", { desc = "Split horizontally" })
keymap("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>bp", ":bprevious<CR>", { desc = "Prev buffer" })
keymap("n", "<leader>bd", ":bd<CR>", { desc = "Close buffer" })
keymap("i", "jk", "<Esc>", { desc = "Escape insert mode" })
keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics" })
keymap("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
keymap("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Buffers" })
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        integrations = {
          cmp = true,
          gitsigns = true,
          mason = true,
          telescope = true,
          treesitter = true,
          which_key = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "css",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "python",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    },
    opts = {},
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      return {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = { "lua_ls" },
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
        automatic_installation = true,
      })

      vim.lsp.config("lua_ls", {
        cmd = { "lua-language-server" },
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
              path = vim.split(package.path, ";"),
            },
            diagnostics = {
              globals = { "vim" },
              disable = { "missing-fields" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            completion = {
              callSnippet = "Both",
              keywordSnippet = "Both",
            },
            telemetry = {
              enable = false,
            },
          },
        },
        root_markers = { ".git" },
      })

      vim.lsp.enable({ "lua_ls" })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my_lsp_attach", { clear = true }),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
        end,
      })
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      preset = "modern",
      delay = 150,
      icons = {
        mappings = false,
        rules = false,
      },
      spec = {
        { "<leader>b", group = "Buffer" },
        { "<leader>f", group = "Find" },
        { "<leader>s", group = "Split" },
        { "<leader>g", group = "Git" },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },
})
