local p        = require("mytheme.palette")
local devicons = require("nvim-web-devicons")
local fn, api  = vim.fn, vim.api

---------------------------- helpers ----------------------------------------
local function hex_to_rgb(hex)
    if type(hex) ~= 'string' or #hex ~= 7 then return 0, 0, 0 end
    return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
end
local function rgb_to_hex(r, g, b) return string.format("#%02x%02x%02x", r, g, b) end
local function blend(a, b, t)
    local r1, g1, b1 = hex_to_rgb(a); local r2, g2, b2 = hex_to_rgb(b)
    local lerp = function(x, y) return x + (y - x) * t end
    return rgb_to_hex(math.floor(lerp(r1, r2, t) + 0.5), math.floor(lerp(g1, g2, t) + 0.5), math.floor(lerp(b1, b2, t) +
        0.5))
end
local function hi(g, fg, bg) api.nvim_set_hl(0, g, { fg = fg, bg = bg, nocombine = true }) end

---------------------------- palette ----------------------------------------
local bg = p.bg or "#0d1117"
local hues = { "#A04C62", "#467159", "#C45A26", "#285A6B" }
local STEPS = 12

local function build_gradient(which)
    local base = hues[which]
    hi('SLModeBlock', p.fg, base)

    local c = {}
    for i = 0, STEPS do c[i] = blend(base, bg, i / STEPS) end
    for i = 1, STEPS do hi('SLGrad' .. i, c[i - 1], c[i]) end
end

--------------------------- widgets -----------------------------------------
local modes = {
    n = 'NORMAL',
    i = 'INSERT',
    v = 'VISUAL',
    V = 'V‑LINE',
    [''] = 'V‑BLOCK',
    c = 'NORMAL',
    R = 'REPLACE',
    t =
    'TERMINAL',
    s = 'SELECT',
    S = 'S‑LINE'
}
local function mode_block()
    local m = api.nvim_get_mode().mode; local lbl = modes[m] or m:upper()
    return string.format('%%#SLModeBlock# %s ', lbl)
end

local function getmode()
    local m = api.nvim_get_mode().mode; local lbl = modes[m] or m:upper()
    local oneorfour = { 1, 3 }
    local map = {
        n = 1,
        i = 2,
        v = 4,
        c = 3,
        s = 4,
    }
    return map[m] or 1
end


local function icon_file()
    local file = fn.expand('%:t'); if file == '' then file = '[No Name]' end
    local icn, fg = devicons.get_icon_color(file, nil, { default = true })
    hi('SLFileIcon', fg, bg); hi('SLFileName', p.fg, bg)
    return string.format('%%#SLFileIcon#%s %%#SLFileName#%s ', icn, file)
end
--------------------------- statusline --------------------------------------

function _G.CustomStatusLine()
    local left = mode_block()
    build_gradient(getmode())
    for i = 1, STEPS do left = left .. string.format('%%#SLGrad%d#', i) end
    left = left .. "  " .. icon_file()
    return left
end
vim.o.statusline = '%!v:lua.CustomStatusLine()'
