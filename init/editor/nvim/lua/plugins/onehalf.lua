return {
    -- 'zorgick/onehalf-lua',
    'CodeGradox/onehalf-lush',
    lazy = false,
    priority = 1000,
    dependencies = {
        'rktjmp/lush.nvim',
    },
    cond = true,
    -- disable = false,
    config = function()
        -- require("onehalf-lush").load()
        -- vim.api.nvim_set_options("background", "light")
        -- vim.cmd("colorscheme onehalf-lush")
        -- vim.api.nvim_set_options("background", "dark")
        -- E185: Cannot find color scheme 'onehalf-lush-dark'
        vim.cmd("colorscheme onehalf-lush-dark")
        -- vim.cmd("colorscheme onehalf-lua")
    end,
}


