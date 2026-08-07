local opt = vim.opt

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = -1 -- Follow shiftwidth automatically

-- false = insert literal tab characters
-- true  = insert spaces
opt.expandtab = true

-- Soft wrapping
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.breakindentopt = "shift:2,min:20"

-- VimTeX
vim.g.vimtex_view_method = "zathura"
