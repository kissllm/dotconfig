return {
    "windwp/windline.nvim",
    requires = {
        { "lewis6991/gitsigns.nvim", opt = true },
    },
    config = function()
        -- require("windline").init()
        -- require('wlsample.basic')
        -- require("wlsample.evil_line")
        require("cool")
        -- vim.api.nvim_command('lua require("cool")')
        -- require("wlsample.wind")

        -- default config
        require('wlfloatline').setup({
            interval = 300,
            ui = {
                active_char = '▁',
                active_color = 'blue',
                active_hl = nil,
            },
            skip_filetypes = {
                'NvimTree',
                'lir',
            },
        })
    end,
}
