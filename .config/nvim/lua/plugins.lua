return {

{
  "nvim-mini/mini.starter",
  event = "VimEnter",
  config = function()
    local starter = require("mini.starter")
    starter.setup({
      header = [=[
           __
.-.__      \ .-.  ___  __
|_|  '--.-.-(   \/\;;\_\.-._______.-.
(-)___     \ \ .-\ \;;\(   \       \ \
 Y    '---._\_((Q)) \;;\\ .-\     __(_)
 I           __'-' / .--.((Q))---'    \,
 I     ___.-:    \|  |   \'-'_          \
 A  .-'      \ .-.\   \   \ \ '--.__     '\
 |  |____.----((Q))\   \__|--\_      \     '
    ( )        '-'  \_  :  \-' '--.___\
     Y                \  \  \       \(_)
     I                 \  \  \         \,
     I                  \  \  \          \
     A                   \  \  \          '\
     |              snd   \  \__|           '
                           \_:.  \
                             \ \  \
                              \ \  \
                               \_\_|
	  ]=],
      items = {
		starter.sections.builtin_actions(),
		starter.sections.recent_files(5, true),
	  },
      footer = "",
    })
  end,
}


,

  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },

    {
    	"nvim-tree/nvim-tree.lua",
	     version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
	     config = function()
	     	require("nvim-tree").setup()
		end,
      keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle outline" },
        },
    },
    -- ─────────────────────────────────────────────────── syntax engine
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "lua", "python", "cpp", "rust", "bash", "html", "css", "javascript", "java", "json", "toml" },
                highlight = { enable = true },
            })
        end,
    },
   -- ─────────────────────────── nvim-cmp core + sources ───────────────────────
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip", -- snippets (optional but handy)
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp     = require("cmp")
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"]     = cmp.mapping(function(fb)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fb()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"]   = cmp.mapping(function(fb)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fb()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "buffer" },
                    { name = "luasnip" },
                },
            })
        end,
    },

    --─────────────────────────── outline sidebar (Aerial) ──────────────────────
    {
        "stevearc/aerial.nvim",
        opts = {
            backends = { "lsp", "treesitter", "markdown" }, -- lsp gives funcs/types; TS for files w/out LSP
        },
        keys = {
            { "<leader>o", "<cmd>AerialToggle!<cr>", desc = "Toggle outline" },
        },
    },

}
