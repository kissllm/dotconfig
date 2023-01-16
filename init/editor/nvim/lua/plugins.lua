#!/usr/bin/env lua
-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Sometimes it's called init.lua

local log_file = require("boot")

local home = os.getenv("HOME")
-- https://www.tutorialspoint.com/lua/lua_file_io.htm
-- https://stackoverflow.com/questions/51438763/lua-io-write-not-working
-- local log_file = io.open(home .. "/.vim.log", "w+a")

log_file:write("\n\n")
log_file:write("home: " .. home .. "\n")
-- https://github.com/mnemnion/luash.git
-- luarocks install --server=http://luarocks.org/dev luash
-- local sh = require("sh")
log_file:write("environment package.path: " .. package.path .. "\n")
log_file:write("environment package.cpath: " .. package.cpath .. "\n")
-- local ver = _VERSION
-- local ver_list = {}
-- for i in string.gmatch(ver, "%S+") do
--     log_file:write(i)
--     table.insert(ver_list, i)
-- end
-- luarocks_name = "luarocks-" .. ver_list[2]
-- -- luarocks = require(luarocks_name)
-- local datafile = require("datafile")

-- local luarocks = datafile.openers.luarocks
-- attempt to concatenate a table value
-- print("luarocks('path --lr-path'): " .. luarocks('path --lr-path'))

-- log_file:write("tostring(luarocks('path --lr-path')): " .. tostring(luarocks("path --lr-path")) .. "\n")
-- package.path = tostring(luarocks("path --lr-path"))
-- package.cpath = tostring(luarocks("path --lr-cpath"))
-- log_file:write("package.path: " .. package.path .. "\n")
-- log_file:write("package.cpath: " .. package.cpath .. "\n")

-- local luarocks = require "luarocks"
-- local loader = require "luarocks.loader"

-- doas luarocks --lua-version 5.1 install  luaunit
-- local lu = require("luaunit")

-- local stdlib = require("posix.stdlib")
-- https://rosettacode.org/wiki/Environment_variables

-- log_file:write("$HOME: " .. stdlib.getenv("HOME") .. "\n")
-- https://github.com/mah0x211/lua-realpath
-- luarocks path
-- local realpath = require('realpath')
-- local luafilesystem = require('luafilesystem')

-- local config_root = stdlib.realpath(vim.fn.stdpath("config"))
local config_root  = vim.fn.stdpath 'config'
-- log_file:write("config_root: " .. config_root .. "\n")
-- realpath = sh.command('realpath')
-- local config_root = tostring(realpath(vim.fn.stdpath("data")))
log_file:write("config_root: " .. config_root .. "\n")

-- local data_root = stdlib.realpath(vim.fn.stdpath("data"))
local data_root  = vim.fn.stdpath 'data'
log_file:write("data_root: " .. data_root .. "\n")
-- local package_root = stdlib.realpath(data_root .. "/site/pack")
local package_root = data_root .. "/site/pack"
log_file:write("package_root: " .. package_root .. "\n")

local cache_root = vim.fn.stdpath("cache")
log_file:write("cache_root: " .. cache_root .. "\n")

-- https://github.com/wbthomason/packer.nvim
-- https://jdhao.github.io/2021/07/11/from_vim_plug_to_packer/
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = package_root .. "/packer/start/packer.nvim"
-- local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local plug_url_format = ""
if vim.g.is_linux then
    plug_url_format = "https://hub.fastgit.org/%s"
else
    plug_url_format = "https://github.com/%s"
end
-- local test_result = execute('echo "hil"')
-- local test_result = print("world")
-- print (test_result)
local packer_repo = string.format(plug_url_format, "wbthomason/packer.nvim")
local install_cmd = string.format("10split |term git clone --depth=1 %s %s", packer_repo, install_path)
local packer_bootstrap = nil

if fn.empty(fn.glob(install_path)) > 0 then
    vim.api.nvim_echo({ { "Installing packer.nvim", "Type" } }, true, {})
    -- packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    packer_bootstrap = fn.system({ "git", "clone", "--depth", "1", packer_repo, install_path })
    -- packer_bootstrap = execute(install_cmd)
    -- -- Only required if you have packer configured as `opt`
    -- vim.cmd [[packadd packer.nvim]]
    -- execute 'packadd packer.nvim'
    -- -- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
    -- vim._update_package_paths()
end

function require_rel(...)
    if arg and arg[0] then
        package.path = arg[0]:match("(.-)[^\\/]+$") .. "?.lua;" .. package.path
        require_rel = require
    elseif ... then
        local d = (...):match("(.-)[^%.]+$")
        function require_rel(module)
            return require(d .. module)
        end
    end
end

local packer = nil
local util = nil
local use = nil
local use_rocks = nil

-- vim.cmd([[
-- function! s:update_init()
-- source <afile>
-- lua require'plugins'.install()
-- :PackerCompile
-- endfunction
-- augroup packer_user_config
-- autocmd!
-- " autocmd BufWritnPost plugins.lua source <afile> | v:lua.require'plugins'.install() | :PackerCompile
-- autocmd BufWritnPost plugins.lua call s:update_init()
-- augroup end
-- ]])

local config_packer = {}
-- https://github.com/wbthomason/packer.nvim/issues/4
local function init()
    if packer == nil then
        packer = require("packer")
        util   = require("packer.util")
        config_packer = {
            ---- Should packer install plugin dependencies?
            --ensure_dependencies = true,
            --snapshot = nil, -- Name of the snapshot you would like to load at startup
            --snapshot_path = join_paths(vim.fn.stdpath("cache"), "packer.nvim"), -- Default save directory for snapshots
            --package_root = util.join_paths(vim.fn.stdpath("data"), "site", "pack"),
            --compile_path = util.join_paths(vim.fn.stdpath("config"), "plugin", "packer_compiled.lua"),
            --plugin_package = "packer", -- The default package for plugins
            --max_jobs = nil, -- Limit the number of simultaneous jobs. nil means no limit
            --auto_clean = true, -- During sync(), remove unused plugins
            --compile_on_sync = true, -- During sync(), run packer.compile()
            --disable_commands = false, -- Disable creating commands
            --opt_default = false, -- Default to using opt (as opposed to start) plugins

            ensure_dependencies = true, -- Should packer install plugin dependencies?
            snapshot = nil, -- Name of the snapshot you would like to load at startup
            -- snapshot_path = util.join_paths(cache_root, "packer.nvim"), -- Default save directory for snapshots
            snapshot_path = util.join_paths(vim.fn.stdpath("config"), "packer.nvim"), -- Default save directory for snapshots
            -- snapshot_path = util.join_paths(config_root, "packer.nvim"), -- Default save directory for snapshots
            package_root  = util.join_paths(vim.fn.stdpath("data"), "site", "pack"),
            -- compile_path = util.join_paths(stdlib.realpath(vim.fn.stdpath("data")), "plugin", "packer_compiled.lua"),
            compile_path  = util.join_paths(vim.fn.stdpath("cache"), "plugin", "packer_compiled.lua"),
            -- compile_path = util.join_paths(cache_root, "plugin", "packer_compiled.lua"),
            plugin_package       = "packer", -- The default package for plugins
            max_jobs             = nil, -- Limit the number of simultaneous jobs. nil means no limit
            auto_clean           = true, -- During sync(), remove unused plugins
            compile_on_sync      = true, -- During sync(), run packer.compile()
            disable_commands     = false, -- Disable creating commands
            opt_default          = false, -- Default to using opt (as opposed to start) plugins
            transitive_opt       = true, -- Make dependencies of opt plugins also opt by default
            transitive_disable   = true, -- Automatically disable dependencies of disabled plugins
            auto_reload_compiled = true, -- Automatically reload the compiled file after creating it.
            git = {
                cmd = "git", -- The base command for git operations
                subcommands = { -- Format strings for git subcommands
                    update         = "pull --ff-only --progress --rebase=false",
                    install        = "clone --depth %i --no-single-branch --progress",
                    fetch          = "fetch --depth 999999 --progress",
                    checkout       = "checkout %s --",
                    update_branch  = "merge --ff-only @{u}",
                    current_branch = "branch --show-current",
                    diff           = "log --color=never --pretty=format:FMT --no-show-signature HEAD@{1}...HEAD",
                    diff_fmt       = "%%h %%s (%%cr)",
                    get_rev        = "rev-parse --short HEAD",
                    get_msg        = "log --color=never --pretty=format:FMT --no-show-signature HEAD -n 1",
                    submodules     = "submodule update --init --recursive --progress",
                },
                depth              = 1, -- Git clone depth
                clone_timeout      = 60, -- Timeout, in seconds, for git clones
                default_url_format = "https://github.com/%s", -- Lua format string used for "aaa/bbb" style plugins
            },
            display = {
                non_interactive = false, -- If true, disable display windows for all operations
                open_fn         = nil, -- An optional function to open a window for packer's display
                open_cmd        = "65vnew \\[packer\\]", -- An optional command to open a window for packer's display
                working_sym     = "⟳", -- The symbol for a plugin being installed/updated
                error_sym       = "✗", -- The symbol for a plugin with an error in installation/updating
                done_sym        = "✓", -- The symbol for a plugin which has completed installation/updating
                removed_sym     = "-", -- The symbol for an unused plugin which was removed
                moved_sym       = "→", -- The symbol for a plugin which was moved (e.g. from opt to start)
                header_sym      = "━", -- The symbol for the header line in packer's display
                show_all_info   = true, -- Should packer show all update details automatically?
                prompt_border   = "double", -- Border style of prompt popups.
                keybindings     = { -- Keybindings for the display window
                    quit          = "q",
                    toggle_info   = "<CR>",
                    diff          = "d",
                    prompt_revert = "r",
                },
            },
            luarocks       = {
                python_cmd = "python", -- Set the python command to use for running hererocks
            },
            log            = { level = "warn" }, -- The default print log level. One of: "trace", "debug", "info", "warn", "error", "fatal".
            profile        = {
                enable    = false,
                threshold = 1, -- integer in milliseconds, plugins which load faster than this won't be shown in profile output
            },
        }
        packer.init(config_packer)
    end

    local use       = packer.use
    local use_rocks = packer.use_rocks
    local util      = require("packer.util")

    -- reset is inside init() and startup()
    -- packer.reset()
    -- lua print(vim.inspect(package.loaded))

    -- Packer can manage itself (not initialize)
    use { "wbthomason/packer.nvim",
        config = {
            function()
                -- -- print('startup config_packer: ' .. tprint(config_packer))
                -- require("packer").setup({
                --         -- Should packer install plugin dependencies?
                --         ensure_dependencies = true,
                --         snapshot = nil, -- Name of the snapshot you would like to load at startup
                --         snapshot_path = join_paths(vim.fn.stdpath("cache"), "packer.nvim"), -- Default save directory for snapshots
                --         package_root = util.join_paths(vim.fn.stdpath("data"), "site", "pack"),
                --         compile_path = util.join_paths(vim.fn.stdpath("data"), "plugin", "packer_compiled.lua"),
                --         plugin_package = "packer", -- The default package for plugins
                --         max_jobs = nil, -- Limit the number of simultaneous jobs. nil means no limit
                --         auto_clean = true, -- During sync(), remove unused plugins
                --         compile_on_sync = true, -- During sync(), run packer.compile()
                --         disable_commands = false, -- Disable creating commands
                --         opt_default = false, -- Default to using opt (as opposed to start) plugins


                --     })
            end,
        },
    }


    -- print('startup config_packer: ' .. tprint(config_packer))
    -- log_file:write(tprint(config_packer) .. '\n')
    log_file:write("config_packer.package_root: " .. config_packer.package_root .. "\n")
    log_file:write("config_packer.compile_path: " .. config_packer.compile_path .. "\n")
    log_file:write("config_packer.snapshot_path: " .. config_packer.snapshot_path .. "\n")

    use { 'matveyt/neoclip' }

    use ({
        "nvim-telescope/telescope.nvim",
        disable = true,
        -- disable telescope will delete plenary?
        requires = { { "nvim-lua/plenary.nvim", opt = true } },
    })

    use ({
        "nvim-telescope/telescope-file-browser.nvim",
        disable = true,
    })

    -- use init.lua to initialie vim-lua-format
    use ({
        "andrejlevkovitch/vim-lua-format",
        -- disable = true
    })

    -- Will modify environment $EDITOR value: $HOME/.local/share/nvim/site/pack/packer/start/neomux/plugin/bin/nmux
    use ({
        "nikvdp/neomux",
        disable = true,
        config = {
            function()
                vim.api.nvim_command('let g:neomux_win_num_status = ""')
            end,
        },
    })

    use ({
        "willelz/teastylua.nvim",
        disable = true,
        config = {
            function()
                vim.api.nvim_set_keymap("n", "<leader>f", "<Plug>teastyluaFormat")
                -- local teastylua_options_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/indent-blankline.nvim/stylua.toml"
                -- vim.g.teastylua_options = "--search-parent-directories --config-path=" .. teastylua_options_path
                vim.g.teastylua_options = [[--search-parent-directories --config-path="vim.fn.stdpath('data') .. '/site/pack/packer/start/indent-blankline.nvim/stylua.toml'"]]
            end,
        },
    })

    -- return require('packer').startup(function(use)
    use ({
        "lukas-reineke/indent-blankline.nvim",
        -- disable = true,
        config = {
            function()
                require("indent_blankline").setup({
                    char = "│",
                    -- char = '|',
                    -- char = '¦',
                    -- char = '▏',
                    -- char = '┆',
                    -- char = '┊',
                    buftype_exclude = { "terminal" },
                    show_end_of_line = true,
                })
            end,
        },
    })

    vim.opt.list = true
    -- vim.opt.listchars:append("eol:↴")

    -- require("slanted")
    -- require("slanted-gaps")
    -- require_rel("slanted-gaps")
    -- local lualine_path = fn.stdpath('data')..'/site/pack/packer/start/lualine.nvim'
    -- local lualine_path_folder = (lualine_path):match("(.-)[^%.]+$")

    use ({
        "kyazdani42/nvim-web-devicons",
        -- disable = true
    })

    -- use 'yorik1984/lualine-theme.nvim'

    use ({
        "camspiers/lens.vim",
        -- disable = true,
        requires = { "camspiers/animate.vim", opt = true },
    })

    -- use {
    --     'nvim-lualine/lualine.nvim',
    --     requires = {
    --         {'kyazdani42/nvim-web-devicons', opt = true},
    --         -- {'slanted'}
    --     },
    --     config = function()
    --         require('slanted')  -- ,
    --         -- require'lualine'.setup {
    --         --     -- require(lualine_path_folder .. '.examples.slanted-gaps'),

    --         --     -- require_rel("slanted-gaps"),
    --         --     options = {
    --         --         icons_enabled = true,
    --         --         -- theme = 'auto',
    --         --         -- theme = 'slanted',
    --         --         theme = 'slanted-gaps',
    --         --         -- theme = 'dracula',
    --         --         -- component_separators = { left = '', right = ''},
    --         --         -- section_separators = { left = '', right = ''},
    --         --         disabled_filetypes = {},
    --         --         always_divide_middle = true,
    --         --     },
    --         --     sections = {
    --         --         lualine_a = {'mode'},
    --         --         lualine_b = {'branch', 'diff', 'diagnostics'},
    --         --         lualine_c = {'filename'},
    --         --         lualine_x = {'encoding', 'fileformat', 'filetype'},
    --         --         lualine_y = {'progress'},
    --         --         lualine_z = {'location'}
    --         --     },
    --         --     inactive_sections = {
    --         --         lualine_a = {},
    --         --         lualine_b = {},
    --         --         lualine_c = {'filename'},
    --         --         lualine_x = {'location'},
    --         --         lualine_y = {},
    --         --         lualine_z = {}
    --         --     },
    --         --     tabline = {},
    --         --     extensions = {'quickfix'}
    --         -- }
    --     end
    -- }

    use ({
        "famiu/bufdelete.nvim",
        -- disable = true
    })

    -- -- :lua require('feline').setup() manually
    -- use ({
    --     { "feline-nvim/feline.nvim", branch = "develop" },
    --     config = function()
    --         require("feline").setup({
    --             preset = "noicon",
    --         })
    --     end,
    -- })

    use {
        "vimpostor/vim-tpipeline",
        disable = true
    }

    -- _G.WindLine is not good
    -- curl https://nvim.sh/s/statusline
    -- https://github.com/windwp/windline.nvim
    use ({
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
    })


    use ({
        "jbyuki/instant.nvim",
        -- disable = true
    })

    -- Simple plugins can be specified as strings
    -- use '9mm/vim-closer'
    use ({
        "rstacruz/vim-closer",
        -- disable = true
    })

    -- Lazy loading:
    -- Load on specific commands
    use ({
        "tpope/vim-dispatch",
        -- disable = true,
        opt = true,
        cmd = { "Dispatch", "Make", "Focus", "Start" },
    })

    -- Load on an autocommand event
    -- https://github.com/andymass/vim-matchup
    use ({
        "andymass/vim-matchup",
        -- disable = true,
        event = "VimEnter",
    })

    -- use { "dense-analysis/ale", opt = true }
    -- Load on a combination of conditions: specific filetypes or commands
    -- Also run code after load (see the "config" key)
    use ({
        "dense-analysis/ale",   -- same as "w0rp/ale",
        disable = true,
        ft = { "sh", "zsh", "bash", "c", "cpp", "cmake", "html", "markdown", "racket", "vim", "tex" },
        cmd = "ALEEnable",
        config = "vim.cmd[[ALEEnable]]",
    })

    -- -- Plugins can have dependencies on other plugins
    -- use {
    --     'haorenW1025/completion-nvim',
    --     opt = true,
    --     requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
    -- }

    -- run java at background
    -- use { 'neovim/nvim-lspconfig' }

    use ({
        "neovim/nvim-lspconfig",
        -- disable = true,
        "williamboman/nvim-lsp-installer",
    })

    -- use "neovim/nvim-lspconfig"
    -- use "williamboman/nvim-lsp-installer"
    -- use "junnplus/nvim-lsp-setup"
    use {
        'junnplus/nvim-lsp-setup',
        requires = {
            'neovim/nvim-lspconfig',
            'williamboman/nvim-lsp-installer',
        }
    }

    -- use ({
    --     "ms-jpq/coq_nvim",
    --     branch = "coq",
    -- })

    -- use ({
    --     "ms-jpq/coq.artifacts",
    --     branch = "artifacts",
    -- })

    -- use ({
    --     "ms-jpq/coq.thirdparty",
    --     branch = "3p",
    -- })

    -- -- Plugins can also depend on rocks from luarocks.org:
    -- use {
    --     'my/supercoolplugin',
    --     rocks = {'lpeg', {'lua-cjson', version = '2.1.0'}}
    -- }

    -- You can specify rocks in isolation
    use_rocks({
        "penlight",
        -- disable = true
    })

    use_rocks({
        "lua-resty-http",
        "lpeg",
        -- disable = true
    })

    -- use_rocks('mah0x211/lua-realpath')

    -- disable netrw at the very start of your init.lua (strongly advised)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- set termguicolors to enable highlight groups
    vim.opt.termguicolors = true
    -- attempt to index global 'TreeExplorer' (a function value)
    use ({
        -- "kyazdani42/nvim-tree.lua",
        'nvim-tree/nvim-tree.lua',
        requires = {
            -- "kyazdani42/nvim-web-devicons", -- optional, for file icon
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly', -- optional, updated every week. (see issue #1193)
        config = function()
            -- require'nvim-tree'.setup {
            -- init.lua
            -- following options are the default
            -- each of these are documented in `:help nvim-tree.OPTION_NAME`
            require("nvim-tree").setup({
                disable_netrw = false,
                hijack_netrw = true,
                open_on_setup = false,
                ignore_ft_on_setup = {},
                auto_close = false,
                auto_reload_on_write = true,
                open_on_tab = false,
                hijack_cursor = false,
                update_cwd = false,
                hijack_unnamed_buffer_when_opening = false,
                hijack_directories = {
                    enable = true,
                    auto_open = true,
                },
                diagnostics = {
                    enable = false,
                    icons = {
                        hint = "",
                        info = "",
                        warning = "",
                        error = "",
                    },
                },
                update_focused_file = {
                    enable = false,
                    update_cwd = false,
                    ignore_list = {},
                },
                system_open = {
                    cmd = nil,
                    args = {},
                },
                filters = {
                    -- dotfiles = false,
                    dotfiles = true,
                    custom = {},
                },
                git = {
                    enable = true,
                    ignore = true,
                    timeout = 500,
                },
                view = {
                    adaptive_size = true,
                    width = 30,
                    height = 30,
                    hide_root_folder = false,
                    side = "left",
                    auto_resize = false,
                    mappings = {
                        custom_only = false,
                        list = {
                            { key = "u", action = "dir_up" },
                        },
                    },
                    number = false,
                    relativenumber = false,
                    signcolumn = "yes",
                },
                trash = {
                    cmd = "trash",
                    require_confirm = true,
                },
                actions = {
                    change_dir = {
                        global = false,
                    },
                    open_file = {
                        quit_on_open = false,
                    },
                },
                sort_by = "case_sensitive",
                renderer = {
                    group_empty = true,
                },
            })
            -- }
        end,
    })

    -- -- Local plugins can be included
    -- use '~/projects/personal/hover.nvim'

    -- Generating a lot of content
    -- -- Plugins can have post-install/update hooks
    -- use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}

    use {
        "nvim-treesitter/nvim-treesitter-refactor",
        -- disable = true,
        require'nvim-treesitter.configs'.setup {
            refactor = {
                highlight_definitions = {
                    enable = true,
                    -- Set to false if you have an `updatetime` of ~100.
                    clear_on_cursor_move = true,
                },
                highlight_current_scope = { enable = true },
                smart_rename = {
                    enable = true,
                    keymaps = {
                        smart_rename = "grr",
                    },
                },
                navigation = {
                    enable = true,
                    keymaps = {
                        goto_definition = "gnd",
                        list_definitions = "gnD",
                        list_definitions_toc = "gO",
                        goto_next_usage = "<a-*>",
                        goto_previous_usage = "<a-#>",
                    },
                },
            },
        }
    }

    -- https://github.com/nvim-treesitter/nvim-treesitter#advanced-setup
    -- echo nvim_get_runtime_file('parser', v:true)
    -- Post-install/update hook with neovim command
    -- use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use ({
        "nvim-treesitter/nvim-treesitter",
        requires = { "nvim-treesitter/nvim-treesitter-refactor", opt = false },
        -- disable = true,
        run = ":TSUpdate",
        config = function()
            require'nvim-treesitter.configs'.setup ({
                -- one of "all", "maintained" (parsers with maintainers), or a list of languages
                -- A list of parser names, or "all"
                -- ensure_installed = "maintained",
                ensure_installed = { "c", "lua", "rust" },
                matchup = {
                    enable = true, -- mandatory, false will disable the whole extension
                    disable = { "ruby" }, -- optional, list of language that will be disabled
                },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- List of parsers to ignore installing (for "all")
                ignore_install = { "javascript" },

                highlight = {
                    -- `false` will disable the whole extension
                    enable = true,

                    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
                    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
                    -- the name of the parser)
                    -- list of language that will be disabled
                    disable = { "c", "rust" },

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    -- additional_vim_regex_highlighting = false,
                    -- https://paste.rs/BW9.lua
                    -- Make `:set spell` only hightlight misspelled words in strings and comments
                    -- additional_vim_regex_highlighting = true,
                    -- additional_vim_regex_highlighting = false,
                    additional_vim_regex_highlighting = {
                        cpp = true,
                    },
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },
                indent = {
                    enable = true,
                },
                playground = {
                    enable = true,
                    updatetime = 25,
                },
                refactor = {
                    highlight_definitions = {
                        enable = true,
                        -- Set to false if you have an `updatetime` of ~100.
                        clear_on_cursor_move = true,
                    },
                    highlight_current_scope = { enable = true },
                    smart_rename = {
                        enable = true,
                        keymaps = {
                            smart_rename = "grr",
                        },
                    },
                    navigation = {
                        enable = true,
                        keymaps = {
                            goto_definition = "gnd",
                            list_definitions = "gnD",
                            list_definitions_toc = "gO",
                            goto_next_usage = "<a-*>",
                            goto_previous_usage = "<a-#>",
                        },
                    },
                },
            })
        end,
    })

    -- log_file:write(lu.prettystr(require "nvim-treesitter.parsers".get_parser_configs()) .. '\n')

    use "numToStr/Navigator.nvim"
    use "ray-x/guihua.lua"
    use ({ "ray-x/navigator.lua", requires = { "ray-x/guihua.lua", run = "cd lua/fzy && make" } })

--     -- use ({ "neovim/nvim-lspconfig" })
--     -- use ({ "hrsh7th/cmp-nvim-lsp" })
--     -- use ({ "hrsh7th/cmp-buffer" })
--     -- use ({ "hrsh7th/cmp-path" })
--     -- use ({ "hrsh7th/cmp-cmdline" })
--     use ({
--         "hrsh7th/nvim-cmp",
--         disable = true,
--         requires = {
--             { "hrsh7th/cmp-cmdline" },
--             { "hrsh7th/cmp-nvim-lsp" },
--             { "hrsh7th/cmp-buffer" },
--             { "hrsh7th/cmp-path" },
--             -- For vsnip users.
--             -- use ({ "hrsh7th/cmp-vsnip" })
--             -- use ({ "hrsh7th/vim-vsnip" })
--
--             -- For luasnip users.
--             -- use ({ "L3MON4D3/LuaSnip" })
--             -- use ({ "saadparwaiz1/cmp_luasnip" })
--             { "L3MON4D3/LuaSnip" },
--             { "saadparwaiz1/cmp_luasnip" },
--             -- For ultisnips users.
--             -- use ({ 'SirVer/ultisnips' })
--             -- use ({ 'quangnguyen30192/cmp-nvim-ultisnips' })
--
--             -- For snippy users.
--             -- use ({ 'dcampos/nvim-snippy' })
--             -- use ({ 'dcampos/cmp-snippy' })
--         },
--         config = function()
--             -- Setup nvim-cmp.
--             local cmp = require("cmp")
--
--             cmp.setup({
--
--                 completion = {
--                     autocomplete = false, -- disable auto-completion.
--                 },
--                 snippet = {
--                     -- REQUIRED - you must specify a snippet engine
--                     expand = function(args)
--                         -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
--                         require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
--                         -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
--                         -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
--                     end,
--                 },
--                 mapping = {
--                     ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
--                     ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
--                     ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
--                     ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
--                     ["<C-e>"] = cmp.mapping({
--                         i = cmp.mapping.abort(),
--                         c = cmp.mapping.close(),
--                     }),
--                     ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--                 },
--                 sources = cmp.config.sources({
--                     { name = "nvim_lsp" },
--                     -- { name = "vsnip" }, -- For vsnip users.
--                     { name = "luasnip" }, -- For luasnip users.
--                     -- { name = 'ultisnips' }, -- For ultisnips users.
--                     -- { name = 'snippy' }, -- For snippy users.
--                 }, {
--                     { name = "buffer" },
--                 }),
--             })
--
--             -- Set configuration for specific filetype.
--             cmp.setup.filetype("gitcommit", {
--                 sources = cmp.config.sources({
--                     { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
--                 }, {
--                     { name = "buffer" },
--                 }),
--             })
--
--             -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
--             cmp.setup.cmdline("/", {
--                 sources = {
--                     { name = "buffer" },
--                 },
--             })
--
--             -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
--             cmp.setup.cmdline(":", {
--                 sources = cmp.config.sources({
--                     { name = "path" },
--                 }, {
--                     { name = "cmdline" },
--                 }),
--             })
--
--             -- Setup lspconfig.
--             local capabilities = require("cmp_nvim_lsp").update_capabilities(
--                 vim.lsp.protocol.make_client_capabilities()
--             )
--             -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
--             require("lspconfig")["tsserver"].setup({
--                 capabilities = capabilities,
--             })
--
--             _G.vimrc = _G.vimrc or {}
--             _G.vimrc.cmp = _G.vimrc.cmp or {}
--             _G.vimrc.cmp.on_text_changed = function()
--                 local cursor = vim.api.nvim_win_get_cursor(0)
--                 local line = vim.api.nvim_get_current_line()
--                 local before = string.sub(line, 1, cursor[2] + 1)
--                 if before:match("%s*$") then
--                     cmp.complete() -- Trigger completion only if the cursor is placed at the end of line.
--                 end
--             end
--             vim.cmd([[
--   augroup vimrc
--     autocmd
--     autocmd TextChanged,TextChangedI,TextChangedP * call luaeval('vimrc.cmp.on_text_changed()')
--   augroup END
-- ]])
--         end,
--     })


    -- -- Post-install/update hook with call of vimscript function with argument
    -- use {'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end}

    -- use 'yorik1984/lualine-theme.nvim'


    -- use {
    --     'nvim-lualine/lualine.nvim',
    -- })

    -- Use specific branch, dependency and run lua file after load
    use ({
        "glepnir/galaxyline.nvim",
        branch = "main",
        -- After disable, run PackerSync manuallly
        disable = true,
        config = function()
            require("status-line")
        end,
        requires = { "kyazdani42/nvim-web-devicons" },
    })

    use ({ "nvim-lua/plenary.nvim" })

    -- Use dependency and run lua function after load
    use ({
        "lewis6991/gitsigns.nvim",
        -- disable = true,
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup({

                signs = {
                    add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
                    change = {
                        hl = "GitSignsChange",
                        text = "│",
                        numhl = "GitSignsChangeNr",
                        linehl = "GitSignsChangeLn",
                    },
                    delete = {
                        hl = "GitSignsDelete",
                        text = "_",
                        numhl = "GitSignsDeleteNr",
                        linehl = "GitSignsDeleteLn",
                    },
                    topdelete = {
                        hl = "GitSignsDelete",
                        text = "‾",
                        numhl = "GitSignsDeleteNr",
                        linehl = "GitSignsDeleteLn",
                    },
                    changedelete = {
                        hl = "GitSignsChange",
                        text = "~",
                        numhl = "GitSignsChangeNr",
                        linehl = "GitSignsChangeLn",
                    },
                },
                signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
                numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
                linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
                word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
                keymaps = {
                    -- Default keymap options
                    noremap = true,

                    ["n ]c"] = { expr = true, "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'" },
                    ["n [c"] = { expr = true, "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'" },

                    ["n <leader>hs"] = "<cmd>Gitsigns stage_hunk<CR>",
                    ["v <leader>hs"] = ":Gitsigns stage_hunk<CR>",
                    ["n <leader>hu"] = "<cmd>Gitsigns undo_stage_hunk<CR>",
                    ["n <leader>hr"] = "<cmd>Gitsigns reset_hunk<CR>",
                    ["v <leader>hr"] = ":Gitsigns reset_hunk<CR>",
                    ["n <leader>hR"] = "<cmd>Gitsigns reset_buffer<CR>",
                    ["n <leader>hp"] = "<cmd>Gitsigns preview_hunk<CR>",
                    ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
                    ["n <leader>hS"] = "<cmd>Gitsigns stage_buffer<CR>",
                    ["n <leader>hU"] = "<cmd>Gitsigns reset_buffer_index<CR>",

                    -- Text objects
                    ["o ih"] = ":<C-U>Gitsigns select_hunk<CR>",
                    ["x ih"] = ":<C-U>Gitsigns select_hunk<CR>",
                },
                watch_gitdir = {
                    interval = 1000,
                    follow_files = true,
                },
                attach_to_untracked = true,
                current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
                    delay = 1000,
                    ignore_whitespace = false,
                },
                current_line_blame_formatter_opts = {
                    relative_time = false,
                },
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil, -- Use default
                max_file_length = 40000,
                preview_config = {
                    -- Options passed to nvim_open_win
                    border = "single",
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
                yadm = {
                    enable = false,
                },
            })
        end,
    })

    -- You can specify multiple plugins in a single call
    -- use {'tjdevries/colorbuddy.vim', {'nvim-treesitter/nvim-treesitter', opt = true}}
    use ({ "tjdevries/colorbuddy.vim", disable = true })

    -- You can alias plugin names
    use ({ "dracula/vim", as = "dracula", disable = true })

    -- https://github.com/Olical/aniseed
    use ({
        "Olical/aniseed",
        -- disable = true
    })

    use ({
        "simrat39/symbols-outline.nvim",
        -- disable = true,
        config = function()
            -- init.lua
            vim.g.symbols_outline = {
                highlight_hovered_item = true,
                show_guides = true,
                auto_preview = true,
                position = "right",
                relative_width = true,
                width = 25,
                auto_close = false,
                show_numbers = false,
                show_relative_numbers = false,
                show_symbol_details = true,
                preview_bg_highlight = "Pmenu",
                keymaps = { -- These keymaps can be a string or a table for multiple keys
                    close = { "<Esc>", "q" },
                    goto_location = "<Cr>",
                    focus_location = "o",
                    hover_symbol = "<C-space>",
                    toggle_preview = "K",
                    rename_symbol = "r",
                    code_actions = "a",
                },
                lsp_blacklist = {},
                symbol_blacklist = {},
                symbols = {
                    File = { icon = "", hl = "TSURI" },
                    Module = { icon = "", hl = "TSNamespace" },
                    Namespace = { icon = "", hl = "TSNamespace" },
                    Package = { icon = "", hl = "TSNamespace" },
                    Class = { icon = "𝓒", hl = "TSType" },
                    Method = { icon = "ƒ", hl = "TSMethod" },
                    Property = { icon = "", hl = "TSMethod" },
                    Field = { icon = "", hl = "TSField" },
                    Constructor = { icon = "", hl = "TSConstructor" },
                    Enum = { icon = "ℰ", hl = "TSType" },
                    Interface = { icon = "ﰮ", hl = "TSType" },
                    Function = { icon = "", hl = "TSFunction" },
                    Variable = { icon = "", hl = "TSConstant" },
                    Constant = { icon = "", hl = "TSConstant" },
                    String = { icon = "𝓐", hl = "TSString" },
                    Number = { icon = "#", hl = "TSNumber" },
                    Boolean = { icon = "⊨", hl = "TSBoolean" },
                    Array = { icon = "", hl = "TSConstant" },
                    Object = { icon = "⦿", hl = "TSType" },
                    Key = { icon = "🔐", hl = "TSType" },
                    Null = { icon = "NULL", hl = "TSType" },
                    EnumMember = { icon = "", hl = "TSField" },
                    Struct = { icon = "𝓢", hl = "TSType" },
                    Event = { icon = "🗲", hl = "TSType" },
                    Operator = { icon = "+", hl = "TSOperator" },
                    TypeParameter = { icon = "𝙏", hl = "TSParameter" },
                },
            }
        end,
    })


    use { "radenling/vim-dispatch-neovim", opt = true }


    use "phozzy/nvim-hotpot"

    -- https://github.com/rktjmp/hotpot.nvim
    use ({
        "rktjmp/hotpot.nvim",
        -- disable = true,
        -- packer says this is "code to run after this plugin is loaded."
        -- but it seems to run before plugin/hotpot.vim (perhaps just barely)
        config = function()
            require("hotpot").setup({
                provide_require_fennel = false, -- (require "fennel") -> hotpot.fennel
                compiler = {
                    modules = {}, -- options passed to fennel.compile for modules
                    macros = { -- options passed to fennel.compile for macros
                        env = "_COMPILER",
                    },
                },
            })
        end,
    })

    use ({
        "antoinemadec/FixCursorHold.nvim",
        -- disable = true,
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        -- require('packer').sync()
        packer.sync()
        -- packer.startup()
    end
end -- )

log_file:write("\n\n")
log_file:flush()
-- log_file:close()

-- return plugins table
-- https://github.com/wbthomason/packer.nvim/issues/4
return setmetatable({}, {
    __index = function(_, key)
        init()
        return packer[key]
    end,
})
