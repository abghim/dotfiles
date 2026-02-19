local p = require("mytheme.palette")
local api = vim.api
local function hi(group, opts)
    api.nvim_set_hl(0, group, opts)
end

hi("Normal", { fg = p.fg, bg=NONE })
hi("NormalNC", { fg = p.fg, bg = NONE })
hi("CursorLine", { bg = p.bg_high })
hi("Visual", { bg = p.bg_high })
hi("WinSeparator", { fg = p.bg_high })

hi("DiagnosticError", { fg = p.red })
hi("DiagnosticWarn", { fg = p.yellow })
hi("DiagnosticInfo", { fg = p.blue })
hi("DiagnosticHint", { fg = p.cyan })
