local backup_dir = vim.fn.expand("~/.vim/backups")
vim.fn.mkdir(backup_dir, "p")      -- create once, "p" = parents OK

local function backup_name(filepath)
  local fname   = vim.fn.fnamemodify(filepath, ":t")           -- leaf name
  local stamp   = os.date("%Y%m%d-%H%M%S")                    -- 20250710-142301
  return string.format("%s/%s.%s.bak", backup_dir, fname, stamp)
end

local function copy_file(src, dst)
  local ok, err = vim.loop.fs_copyfile(src, dst)
  if not ok then
    vim.notify("backup-copy failed: "..err, vim.log.levels.WARN)
  end
end
	
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function(args)
    local file = args.file          -- full path
    if #file == 0 or vim.bo.filetype == "" then return end  -- ignore [No Name]
    copy_file(file, backup_name(file))
  end,
  })
require("bootstrap")

require("lazy").setup("plugins")


require("mytheme").setup()
require("statusline")

vim.opt.updatetime = 700
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.lsp.enable("jdtls")
vim.lsp.enable("clangd")
vim.lsp.enable("rust_analyzer")

vim.lsp.config("jdtls", {cmd={"jdtls"}, filetypes={"java", "jav"}, settings={["jdtls"] = {},}})
vim.lsp.config("rust_analyzer", {cmd={"rust-analyzer"}, filetypes={"rs","rust"}, settings={["rust_analyzer"] = {}}})
vim.lsp.config("clangd", {cmd={"clangd"}, filetypes={"c", "cpp", "h", "hpp", "hh", "cc"}, settings={["clangd"] = {},}})

local cmp = require("cmp")

cmp.setup({
  window = {
    completion = cmp.config.window.bordered({
      border = "rounded",
      winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
      scrollbar = true,
    }),
    documentation = cmp.config.window.bordered({
      border = "rounded",
      winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder,Search:None",
      max_width = 15,   -- 15 columns (very narrow!)
      max_height = 15,
    }),
  },

  performance = {
    max_view_entries = 15,
  },
})


vim.diagnostic.config({
  underline = true,
  severity_sort = true,
  update_in_insert = false,

  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "",
  },

  signs = true,
  float = {
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
  },
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn",  { link = "DiagnosticWarn"  })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo",  { link = "DiagnosticInfo"  })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint",  { link = "DiagnosticHint"  })

vim.opt.signcolumn = "yes:1"
local signs = {
  Error = "",
  Warn  = "",
  Info  = "󰋽",
  Hint  = "󰌶",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
  signs = true,
})

-- When in mini.starter, pressing `i` opens a new empty buffer and enters insert mode
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ministarter",
  callback = function(ev)
    vim.keymap.set("n", "i", function()
      vim.cmd("enew")   -- new empty buffer
      vim.cmd("startinsert")
    end, { buffer = ev.buf, silent = true, nowait = true })
  end,
})


vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.laststatus = 3

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ministarter",
  callback = function(ev)
    vim.keymap.set("n", "i", function()
      vim.cmd("enew")
      vim.cmd("startinsert")
    end, { buffer = ev.buf, silent = true, nowait = true })
  end,
})
