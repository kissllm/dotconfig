vim.cmd([[ packadd nlua.nvim ]])

local lsp = require("lspconfig")
local nvim_lsp = lsp
vim.lsp.set_log_level("debug")
vim.o.completeopt = "menuone,noselect"

-- local cmp = require("cmp")
-- if cmp["disable"] == true then
--     cmp.setup({
--         enabled = true,
--         autocomplete = true,
--         debug = false,
--         min_length = 1,
--         preselect = "enable",
--         throttle_time = 80,
--         source_timeout = 200,
--         incomplete_delay = 400,
--         max_abbr_width = 100,
--         max_kind_width = 100,
--         max_menu_width = 100,
--         documentation = false,
--         completion = {
--             autocomplete = false, -- disable auto-completion.
--         },
--         snippet = {
--             -- REQUIRED - you must specify a snippet engine
--             expand = function(args)
--                 -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
--                 require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
--                 -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
--                 -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
--             end,
--         },
--         mapping = {
--             ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
--             ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
--             ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
--             ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
--             ["<C-e>"] = cmp.mapping({
--                 i = cmp.mapping.abort(),
--                 c = cmp.mapping.close(),
--             }),
--             ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--         },
--         sources = cmp.config.sources({
--             path = true,
--             buffer = true,
--             calc = true,
--             vsnip = true,
--             nvim_lsp = true,
--             nvim_lua = true,
--             spell = true,
--             tags = true,
--             snippets_nvim = true,
--             treesitter = true,
--             { name = "nvim_lsp" },
--             -- { name = "vsnip" }, -- For vsnip users.
--             { name = "luasnip" }, -- For luasnip users.
--             -- { name = 'ultisnips' }, -- For ultisnips users.
--             -- { name = 'snippy' }, -- For snippy users.
--         }, {
--             { name = "buffer" },
--         }),
--         documentation = {
--             border = "rounded",
--         },
--     })
-- end

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
-- move to prev/next item in completion menuone
-- jump to prev/next snippet's placeholder
_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t("<C-n>")
    elseif vim.fn.call("vsnip#available", { 1 }) == 1 then
        return t("<Plug>(vsnip-expand-or-jump)")
    elseif check_back_space() then
        return t("<Tab>")
    else
        return vim.fn["cmp#complete"]()
    end
end

_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t("<C-p>")
    elseif vim.fn.call("vsnip#jumpable", { -1 }) == 1 then
        return t("<Plug>(vsnip-jump-prev)")
    else
        -- If <S-Tab> is not working in your terminal, change it to <C-h>
        return t("<S-Tab>")
    end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", { expr = true })
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", { expr = true })

local completion = require("completion")

local mapper = function(mode, key, result)
    vim.api.nvim_buf_set_keymap(0, mode, key, "<cmd>lua " .. result .. "<cr>", { noremap = true, silent = true })
end

local custom_attach = function()
    completion.on_attach()
    -- Move cursor to the next and previous diagnostic
    mapper("n", "<leader>dn", "vim.lsp.diagnostic.goto_next()")
    mapper("n", "<leader>dp", "vim.lsp.diagnostic.goto_prev()")
end

lsp.pyls.setup({
    on_attach = custom_attach,
})

local configs = require("lspconfig/configs")
configs.ocamllsp = {
    default_config = {
        cmd = { "ocamllsp" },
        filtypes = { "ocaml" },
        root_dir = function(fname)
            return lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
        end,
        settings = {},
    },
}

lsp.ocamllsp.setup({
    on_attach = custom_attach,
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyright", "rust_analyzer", "tsserver" }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup({
        on_attach = on_attach,
        flags = {
            debounce_text_changes = 150,
        },
    })
end

vim.lsp.set_log_level("debug")

lsp.cmake.setup({})
lsp.lua.setup({})
-- lsp.clangd.setup{}
-- lsp.clangd.setup{on_attach = require'completion'.on_attach}

lsp.pyright.setup({})

-- local lsp = require "lspconfig"
local coq = require("coq") -- add this

-- https://github.com/ms-jpq/coq_nvim
-- syntax
-- lsp.<server>.setup(<stuff...>)                              -- before
-- lsp.<server>.setup(coq.lsp_ensure_capabilities(<stuff...>)) -- after

lsp.clangd.setup({}) -- before
lsp.clangd.setup(coq.lsp_ensure_capabilities()) -- after

-- Setup lspconfig.
lsp.tsserver.setup({
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
})

-- require("nvim-treesitter.configs").setup({
--     ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
--     sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
--     ignore_install = { "javascript" }, -- List of parsers to ignore installing
--     highlight = {
--         enable = true, -- false will disable the whole extension
--         disable = { "c", "rust" }, -- list of language that will be disabled
--         -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--         -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
--         -- Using this option may slow down your editor, and you may see some duplicate highlights.
--         -- Instead of true it can also be a list of languages
--         additional_vim_regex_highlighting = false,
--     },
-- })
--
-- -- This is for the spell checking to not be annoying in code
-- require("nvim-treesitter.configs").setup({
--     ensure_installed = "maintained",
--     highlight = {
--         enable = true,
--         additional_vim_regex_highlighting = true, -- <= THIS LINE is the magic!
--     },
--     indent = { enable = true },
--     incremental_selection = { enable = true },
-- })
