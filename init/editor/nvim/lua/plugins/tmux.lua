

--  For development
--  find ~/.local/share/nvim/lazy/tmux.nvim/ -type f -name "*.lua" -exec grep -Hn "\-- print" {} +
--  fin "\-- print" ~/.local/share/nvim/lazy/tmux.nvim/ -- [fin is not a typo :)](https://github.com/trailblazing/dotconfig/blob/master/local/bin/fin)

return {
    "trailblazing/tmux.nvim",
        --  cond   = false, -- test
            cond   = true,
        branch = 'main',
    --  event  = "VeryLazy",
        event  = { "TextYankPost", 'VimEnter', 'VimLeave', 'VimResume', 'FocusGained', 'BufEnter', },
        lazy   = true,
    --  lazy   = false,
    --  Lazy will process the following "opts" table when no config function was defined
    --  So, don't put options here if you have config function defined
    --  "opts" is a hard coded index name -- lazy/core/loader.lua
    --  opts = {
    --   copy_sync = {
    --       -- enable                 = false, -- default
    --       -- enable                 = true,  -- will redefine the neovim "p"
    --       -- redirect_to_clipboard  = false,
    --       -- redirect_to_clipboard  = true,
    --       -- sync_registers         = true,
    --       -- sync_registers         = false,
    --       -- sync_unnamed           = false,
    --       enable                    = true, -- default
    --       sync_clipboard            = true, -- default
    --       sync_registers            = true, -- default
    --       -- sync_deletes           = false,
    --       -- No difference
    --       redirect_to_clipboard = false, -- default
    --       -- redirect_to_clipboard = true,
    --   },
    --   navigation = {
    --       enable_default_keybindings = true,
    --       -- enable_default_keybindings = false,
    --       cycle_navigation   = true,
    --       prefix_background  = "white",
    --   },
    --   resize = {
    --       enable_default_keybindings = true, -- default
    --       -- enable_default_keybindings = false,
    --   },
    --   logging = {
    --       file    = "disabled",
    --       notify  = "disabled",
    --   },
    --  },
    --  Lazy won't process this "logging" table and you could never reference it from here
    --  So, don't put logging options here regardless of whether you have defined a config function or not
    --  Deprecated options item outside "opts"
    --  logging = {
    --   file    = "disabled",
    --   notify  = "disabled",
    --  },
    --  Empty "config" function body will not work for tmux.nvim (even when the logging options was moved into "opts")
    --  Lazy will not process the upward "opts" if the "config" function was defined, whatever setup() was triggered with or without parameters
    --  Either use the "config" and use it till the end or don't use it at all
    config = function()
		--  local user_preferences = debug.getinfo(2, "S").source:sub(2)
        opts      = {
			--  user_preferences = user_preferences,
            copy_sync = {
                --  enable = false, -- default
                --  enable = true,  -- will redefine the neovim "p"
                --  redirect_to_clipboard = false,
                --  redirect_to_clipboard = true,
                --  sync_registers  = true,
                --  sync_registers  = false,
                --  sync_unnamed    = false,
                enable          = true, --  default
                sync_clipboard  = true, --  default
                sync_registers  = true, --  default
                --  sync_deletes    = false,
                --  No difference
                redirect_to_clipboard = false, -- default
                -- redirect_to_clipboard = true,
            },
            --  "XDG_CONFIG_HOME" files might be symbolic links pointing to user's real config files
            --  tmux.nvim won't touch it if user has modified the links
            tmux    = {
                --  conf    = os.getenv("HOME") .. "/.tmux.conf",
				--  Reference implementation. Not essential to this plugin
				conf    = os.getenv("XDG_CONFIG_HOME") .. "/tmux/tmux.conf",
                header  = os.getenv("XDG_CONFIG_HOME") .. "/tmux/header.conf",
            },
            prefix  = {
                conf    = os.getenv("XDG_CONFIG_HOME") .. "/tmux/prefix.conf",
                wincmd  = os.getenv("XDG_CONFIG_HOME") .. "/tmux/wincmd.conf",
                --  Modifying escape_key (prefix) and assist_key is not a trivial task
                --  Do it in tmux configuration files is a better choice
                --  escape_key  = 'Escape',
                --  escape_key  = '`',
                --  assist_key  = 'Escape',
                --  assist_key  = '`',
                --  assist_key  = '',
		        --  The background color value indicating entering prefix "mode" when vim background is dark
                prefix_background   = "#00d7d7", -- "brightyellow",
		        --  The background color value indicating entering copy-mode when nvim background is dark
                normal_background   = "colour003",
		        --  The background color value indicating entering prefix "mode" when vim background is light
                prefix_bg_on_light  = "#d7d7ff",
		        --  The background color value indicating entering copy-mode when nvim background is light
                normal_bg_on_light  = "colour003",
            },
            navigation = {
                conf    = os.getenv("XDG_CONFIG_HOME") .. "/tmux/navigation.conf",
                enable_default_keybindings = true,
                --  enable_default_keybindings = false,
                cycle_navigation   = true,
				resize_step_x = 5,
				resize_step_y = 2,
            },
            resize = {
                conf    = os.getenv("XDG_CONFIG_HOME") .. "/tmux/resize.conf",
                enable_default_keybindings = true, -- default
                --  enable_default_keybindings = false,
            },
            logging = {
                --  log_address: $HOME/.cache/nvim/tmux.nvim.log
                --  file    = "disabled",
                    file    = "debug", --  For development
                --  notify  = "disabled",
                --  notify  = "debug",
            },
        }

        require("tmux").setup(opts)
        --  require("tmux").setup() -- get the default options (options defined in tmux/init.lua)
        if false then
            vim.cmd
            [[
            if ! exists('#tmux_is_vim_vimenter#VimEnter')
                let keys_load_path = stdpath("data") . '/lazy/keys/after/plugin/keys.vim'
                exe 'set runtimepath+='.  keys_load_path
                exe 'set packpath+='.     keys_load_path
                execute "source "   .     keys_load_path
                execute "runtime! " .     keys_load_path
            else
                augroup tmux_is_vim | au! | augroup END
                endif
                ]]
        end
    end,


}
