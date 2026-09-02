vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.filetype.add({
    extension = {
        tmpl = 'gotmpl',
    }
})

require("saraabdullahi.set")
require("saraabdullahi.remap")
require("saraabdullahi.lazy")
