local api = vim.api
-- local lu = require("luaunit")
-- if type(_G.WindLine) == 'function' then
--     log_file:write(lu.prettystr(_G.WindLine()) .. "\n")
-- elseif type(_G.WindLine) == 'table' then
--     log_file:write(lu.prettystr(_G.WindLine) .. "\n")
-- end

-- if type(_G.WindLine) ~= "table" then
--     _G.WindLine = {}
--     -- local M = {}
--     _G.WindLine.state = {
--         mode = {}, -- vim mode {normal insert}
--         comp = {}, -- component state it will reset on begin render
--         config = {},
--         runtime_colors = {}, -- some colors name added by function add_component
--     }
--     -- else
--     -- local M = _G.WindLine or {}
-- end

-- _G.WindLine.state = _G.WindLine.state
--     or {
--         mode = {}, -- vim mode {normal insert}
--         comp = {}, -- component state it will reset on begin render
--         config = {},
--         runtime_colors = {}, -- some colors name added by function add_component
--     }

local windline = require("windline")
local helper = require("windline.helpers")
local b_components = require("windline.components.basic")
local vim_components = require('windline.components.vim')
local state = _G.WindLine.state
local utils = require('windline.utils')
local lsp_comps = require("windline.components.lsp")
local git_comps = require("windline.components.git")
local animation = require("wlanimation")
local effects = require('wlanimation.effects')

local state = _G.WindLine.state

local hl_list = {
    Black = { "white", "black" },
    White = { "black", "white" },
    Inactive = { "InactiveFg", "InactiveBg" },
    Active = { "ActiveFg", "ActiveBg" },
}
local basic = {}

local breakpoint_width = 90
basic.divider = { b_components.divider, "" }
basic.bg = { " ", "StatusLine" }

-- stylua: ignore
utils.change_mode_name({
    ['n']    = { ' -- Normal -- '   , 'Normal'  } ,
    ['no']   = { ' -- Visual -- '   , 'Visual'  } ,
    ['nov']  = { ' -- Visual -- '   , 'Visual'  } ,
    ['noV']  = { ' -- Visual -- '   , 'Visual'  } ,
    ['no'] = { ' -- Visual -- '   , 'Visual'  } ,
    ['niI']  = { ' -- Normal -- '   , 'Normal'  } ,
    ['niR']  = { ' -- Normal -- '   , 'Normal'  } ,
    ['niV']  = { ' -- Normal -- '   , 'Normal'  } ,
    ['v']    = { ' -- Visual -- '   , 'Visual'  } ,
    ['V']    = { ' -- Visual -- '   , 'Visual'  } ,
    ['']   = { ' -- Visual -- '   , 'Visual'  } ,
    ['s']    = { ' -- Visual -- '   , 'Visual'  } ,
    ['S']    = { ' -- Visual -- '   , 'Visual'  } ,
    ['']   = { ' -- Visual -- '   , 'Visual'  } ,
    ['i']    = { ' -- Insert -- '   , 'Insert'  } ,
    ['ic']   = { ' -- Insert -- '   , 'Insert'  } ,
    ['ix']   = { ' -- Insert -- '   , 'Insert'  } ,
    ['R']    = { ' -- Replace -- '  , 'Replace' } ,
    ['Rc']   = { ' -- Replace -- '  , 'Replace' } ,
    ['Rv']   = { ' -- Normal -- '   , 'Normal'  } ,
    ['Rx']   = { ' -- Normal -- '   , 'Normal'  } ,
    ['c']    = { ' -- Commmand -- ' , 'Command' } ,
    ['cv']   = { ' -- Commmand -- ' , 'Command' } ,
    ['ce']   = { ' -- Commmand -- ' , 'Command' } ,
    ['r']    = { ' -- Replace -- '  , 'Replace' } ,
    ['rm']   = { ' -- Normal -- '   , 'Normal'  } ,
    ['r?']   = { ' -- Normal -- '   , 'Normal'  } ,
    ['!']    = { ' -- Normal -- '   , 'Normal'  } ,
    ['t']    = { ' -- Normal -- '   , 'Command' } ,
    ['nt']   = { ' -- Terminal -- ' , 'Command' } ,
})

local colors_mode = {
    Normal = { "red", "black" },
    Insert = { "green", "black" },
    Visual = { "yellow", "black" },
    Replace = { "blue_light", "black" },
    Command = { "magenta", "black" },
}

basic.vi_mode = {
    name = "vi_mode",
    hl_colors = colors_mode,
    text = function()
        return { { "  ", state.mode[2] } }
    end,
}

basic.square_mode = {
    hl_colors = colors_mode,
    text = function()
        return { { "▊", state.mode[2] } }
    end,
}

basic.file = {
    name = "file",
    hl_colors = {
        default = hl_list.Black,
        white = { "white", "black" },
        magenta = { "magenta", "black" },
    },
    text = function(_, _, width)
        if width > breakpoint_width then
            return {
                { b_components.cache_file_size(), "default" },
                { " ", "" },
                { b_components.cache_file_name("[No Name]", "unique"), "magenta" },
                { b_components.line_col_lua, "white" },
                { b_components.progress_lua, "" },
                { " ", "" },
                { b_components.file_modified(" "), "magenta" },
            }
        else
            return {
                { b_components.cache_file_size(), "default" },
                { " ", "" },
                { b_components.cache_file_name("[No Name]", "unique"), "magenta" },
                { " ", "" },
                { b_components.file_modified(" "), "magenta" },
            }
        end
    end,
}
basic.file_right = {
    hl_colors = {
        default = hl_list.Black,
        white = { "white", "black" },
        magenta = { "magenta", "black" },
    },
    text = function(_, _, width)
        if width < breakpoint_width then
            return {
                { b_components.line_col_lua, "white" },
                { b_components.progress_lua, "" },
            }
        end
    end,
}

basic.lsp_name = {
    width = breakpoint_width,
    name = "lsp_name",
    hl_colors = {
        magenta = { "magenta", "black" },
    },
    text = function(bufnr)
        if lsp_comps.check_lsp(bufnr) then
            return {
                { lsp_comps.lsp_name(), "magenta" },
            }
        end
        return {
            { b_components.cache_file_type({ icon = true }), "magenta" },
        }
    end,
}

-- basic.lsp_diagnos = {
--     name = "diagnostic",
--     -- hl_colors = hl_list.default,
--     hl_colors = {
--         red = { "red", "black" },
--         yellow = { "yellow", "black" },
--         blue = { "blue", "black" },
--     },
--     width = large_width,
--     text = function(bufnr)
--         if lsp_comps.check_lsp(bufnr) then
--             -- stylua: ignore
--             return {
--                 { lsp_comps.lsp_error({ format = '  %s', show_zero = true }), '' },
--                 { lsp_comps.lsp_warning({ format = '  %s', show_zero = true }), '' },
--             }
--         end
--         return ""
--     end,
-- }

-- basic.lsp_diagnos = {
--     name = "diagnostic",
--     hl_colors = {
--         red = { "red", "black" },
--         yellow = { "yellow", "black" },
--         blue = { "blue", "black" },
--     },
--     width = breakpoint_width,
--     text = function(bufnr)
--         if lsp_comps.check_lsp(bufnr) then
--             return {
--                 { lsp_comps.lsp_error({ format = "  %s", show_zero = true }), "red" },
--                 { lsp_comps.lsp_warning({ format = "  %s", show_zero = true }), "yellow" },
--                 { lsp_comps.lsp_hint({ format = "  %s", show_zero = true }), "blue" },
--             }
--         end
--         return ""
--     end,
-- }

basic.lsp_diagnos = {
    name = "diagnostic",
    hl_colors = {
        red_text = { "red", "transparent" },
    },
    hl_colors = {
        red = { "red", "black" },
        yellow = { "yellow", "black" },
        blue = { "blue", "black" },
    },
    width = large_width,
    text = function(bufnr, winid, width)
        if lsp_comps.check_lsp() then
            return {

                { "[ lsp: ", "red_text" },
                -- red_text define in hl_colors. It make easy cache value first
                -- because text function run multiple time on redraw

                { lsp_comps.lsp_name(), "IncSearch" },
                -- it use a hightlight group IncSearch

                -- but you can create a hightlight on child component too
                { lsp_comps.lsp_error({ format = "  %s" }), { "red", "transparent" } },

                { lsp_comps.lsp_warning({ format = "  %s" }), { "yellow", "" } },
                -- it have same background black with the previous component

                { lsp_comps.lsp_hint({ format = "  %s" }), { "", "blue" } },
                -- it have same foreground yellow with the previous component

                { " ] " },
            }
        end
        return ""
    end,
}

basic.git = {
    name = "git",
    hl_colors = {
        green = { "green", "black" },
        red = { "red", "black" },
        blue = { "blue", "black" },
    },
    width = breakpoint_width,
    text = function(bufnr)
        if git_comps.is_git(bufnr) then
            return {
                { git_comps.diff_added({ format = "  %s", show_zero = true }), "green" },
                { git_comps.diff_removed({ format = "  %s", show_zero = true }), "red" },
                { git_comps.diff_changed({ format = " 柳%s", show_zero = true }), "blue" },
            }
        end
        return ""
    end,
}

-- -- short syntax
-- local git_branch = { git_comps.git_branch(), { "white", "transparent" }, 100 }

-- -- syntax using table
-- local git_branch = {
--     text = git_comps.git_branch(),
--     hl_colors = { "white", "transparent" },
--     --- component not visible if window width is less than 100
--     width = 100,
-- }

basic.git_branch = {
    name = "git_branch",
    -- hl_colors = hl_list.default,
    hl_colors = { "white", "transparent" },
    width = medium_width,
    --- component not visible if window width is less than 100
    width = 100,
    text = function(bufnr)
        if git_comps.is_git(bufnr) then
            return {
                { git_comps.git_branch(), hl_list.default, large_width },
                {
                    git_rev_components.git_rev(),
                    hl_list.default,
                    large_width,
                },
            }
        end
        return ""
    end,
}

local quickfix = {
    filetypes = { "qf", "Trouble" },
    active = {
        { "🚦 Quickfix ", { "white", "black" } },
        { helper.separators.slant_right, { "black", "black_light" } },
        {
            function()
                return vim.fn.getqflist({ title = 0 }).title
            end,
            { "cyan", "black_light" },
        },
        { " Total : %L ", { "cyan", "black_light" } },
        { helper.separators.slant_right, { "black_light", "InactiveBg" } },
        { " ", { "InactiveFg", "InactiveBg" } },
        basic.divider,
        { helper.separators.slant_right, { "InactiveBg", "black" } },
        { "🧛 ", { "white", "black" } },
    },

    always_active = true,
    show_last_status = true,
}

basic.explorer_name = {
    name = 'explorer_name',
    text = function(bufnr)
        if bufnr == nil then return '' end
        local bufname = vim.fn.expand(vim.fn.bufname(bufnr))
        local _,_, bufnamemin = string.find(bufname,[[%/([^%/]*%/[^%/]*);%$$]])
        if bufnamemin ~= nil and #bufnamemin > 1 then return bufnamemin end
        return bufname
    end,
    hl_colors = hl_list.Active
}

local explorer = {
    filetypes = { "fern", "NvimTree", "lir" },
    active = {
        { "  ", { "black", "red" } },
        { helper.separators.slant_right, { "red", "NormalBg" } },
        -- { helper.separators.slant_right, { 'black', 'ActiveBg' } },
        { b_components.divider, "" },
        -- basic.explorer_name,
        { b_components.file_name(""), { "white", "NormalBg" } },
    },
    always_active = true,
    show_last_status = true,
}

-- local utils = require('lualine.utils.utils')
-- local loader = require('lualine.utils.loader')

local color_name = vim.g.colors_name
-- if color_name then
--     -- Check if there's a theme for current colorscheme
--     -- If there is load that instead of genarating a new one
--     local ok, theme = pcall(loader.load_theme, color_name)
--     if ok and theme then
--         return theme
--     end
-- end

---------------
-- Constents --
---------------
-- fg and bg must have this much contrast range 0 < contrast_threshold < 0.5
local contrast_threshold = 0.3
-- how much brightness is changed in percentage for light and dark themes
local brightness_modifier_parameter = 10

-- truns #rrggbb -> { red, green, blue }
local function rgb_str2num(rgb_color_str)
    if rgb_color_str:find("#") == 1 then
        rgb_color_str = rgb_color_str:sub(2, #rgb_color_str)
    end
    local red = tonumber(rgb_color_str:sub(1, 2), 16)
    local green = tonumber(rgb_color_str:sub(3, 4), 16)
    local blue = tonumber(rgb_color_str:sub(5, 6), 16)
    return { red = red, green = green, blue = blue }
end

-- turns { red, green, blue } -> #rrggbb
local function rgb_num2str(rgb_color_num)
    local rgb_color_str = string.format("#%02x%02x%02x", rgb_color_num.red, rgb_color_num.green, rgb_color_num.blue)
    return rgb_color_str
end

-- returns brightness lavel of color in range 0 to 1
-- arbitary value it's basicaly an weighted average
local function get_color_brightness(rgb_color)
    local color = rgb_str2num(rgb_color)
    local brightness = (color.red * 2 + color.green * 3 + color.blue) / 6
    return brightness / 256
end

-- returns average of colors in range 0 to 1
-- used to ditermine contrast lavel
local function get_color_avg(rgb_color)
    local color = rgb_str2num(rgb_color)
    return (color.red + color.green + color.blue) / 3 / 256
end

-- clamps the val between left and right
local function clamp(val, left, right)
    if val > right then
        return right
    end
    if val < left then
        return left
    end
    return val
end

-- changes braghtness of rgb_color by percentage
local function brightness_modifier(rgb_color, parcentage)
    local color = rgb_str2num(rgb_color)
    color.red = clamp(color.red + (color.red * parcentage / 100), 0, 255)
    color.green = clamp(color.green + (color.green * parcentage / 100), 0, 255)
    color.blue = clamp(color.blue + (color.blue * parcentage / 100), 0, 255)
    return rgb_num2str(color)
end

-- changes contrast of rgb_color by amount
local function contrast_modifier(rgb_color, amount)
    local color = rgb_str2num(rgb_color)
    color.red = clamp(color.red + amount, 0, 255)
    color.green = clamp(color.green + amount, 0, 255)
    color.blue = clamp(color.blue + amount, 0, 255)
    return rgb_num2str(color)
end

-- Changes brightness of foreground color to achive contrast
-- without changing the color
local function apply_contrast(highlight)
    local hightlight_bg_avg = get_color_avg(highlight.bg)
    local contrast_threshold_config = clamp(contrast_threshold, 0, 0.5)
    local contranst_change_step = 5
    if hightlight_bg_avg > 0.5 then
        contranst_change_step = -contranst_change_step
    end

    -- donn't waste too much time here max 25 interation should be more than enough
    local iteration_count = 1
    while
        math.abs(get_color_avg(highlight.fg) - hightlight_bg_avg) < contrast_threshold_config
        and iteration_count < 25
    do
        highlight.fg = contrast_modifier(highlight.fg, contranst_change_step)
        iteration_count = iteration_count + 1
    end
end

-- https://github.com/windwp/windline.nvim
-- sample
local colors = {
    black         = "",  -- terminal_color_0,
    red           = "",  -- terminal_color_1,
    green         = "",  -- terminal_color_2,
    yellow        = "",  -- terminal_color_3,
    blue          = "",  -- terminal_color_4,
    magenta       = "",  -- terminal_color_5,
    cyan          = "",  -- terminal_color_6,
    white         = "",  -- terminal_color_7,
    black_light   = "",  -- terminal_color_8,
    red_light     = "",  -- terminal_color_9,
    green_light   = "",  -- terminal_color_10,
    yellow_light  = "",  -- terminal_color_11,
    blue_light    = "",  -- terminal_color_12,
    magenta_light = "",  -- terminal_color_13,
    cyan_light    = "",  -- terminal_color_14,
    white_light   = "",  -- terminal_color_15,

    NormalFg      = "",  -- hightlight Normal fg
    NormalBg      = "",  -- hightlight Normal bg
    ActiveFg      = "",  -- hightlight StatusLine fg
    ActiveBg      = "",  -- hightlight StatusLine bg
    InactiveFg    = "",  -- hightlight StatusLineNc fg
    InactiveBg    = "",  -- hightlight StatusLineNc bg
}

-- return colors

-- -- Get the colors to create theme
-- -- stylua: ignore
-- local auto_colors = {
--     normal  = utils.extract_color_from_hllist('bg', { 'PmenuSel', 'PmenuThumb', 'TabLineSel' }, '#000000'),
--     insert  = utils.extract_color_from_hllist('fg', { 'String', 'MoreMsg' }, '#000000'),
--     replace = utils.extract_color_from_hllist('fg', { 'Number', 'Type' }, '#000000'),
--     visual  = utils.extract_color_from_hllist('fg', { 'Special', 'Boolean', 'Constant' }, '#000000'),
--     command = utils.extract_color_from_hllist('fg', { 'Identifier' }, '#000000'),
--     back1   = utils.extract_color_from_hllist('bg', { 'Normal', 'StatusLineNC' }, '#000000'),
--     fore    = utils.extract_color_from_hllist('fg', { 'Normal', 'StatusLine' }, '#000000'),
--     back2   = utils.extract_color_from_hllist('bg', { 'StatusLine' }, '#000000'),
-- }

local theme = {
    normal = {
        -- a = { fg = colors.white, bg = colors.black },
        a = { fg = colors.white, bg = colors.NONE },
        -- b = { fg = colors.white, bg = colors.grey },
        b = { fg = colors.white, bg = colors.NONE },
        -- c = { fg = colors.black, bg = colors.white },
        -- c = { fg = colors.NONE, bg = colors.white },
        c = { fg = colors.white, bg = colors.NONE },
        -- z = { fg = colors.white, bg = colors.black },
        z = { fg = colors.white, bg = colors.NONE },
    },
    -- insert  = { a = { fg = colors.black, bg = colors.light_green } },
    -- insert  = { a = { fg = colors.NONE, bg = colors.light_green } },
    insert = { a = { bg = colors.NONE, fg = colors.light_green } },
    -- visual  = { a = { fg = colors.black, bg = colors.orange } },
    -- visual  = { a = { fg = colors.NONE, bg = colors.orange } },
    visual = { a = { bg = colors.NONE, fg = colors.orange } },
    -- replace = { a = { fg = colors.black, bg = colors.green } },
    -- replace = { a = { fg = colors.NONE, bg = colors.green } },
    replace = { a = { bg = colors.NONE, fg = colors.green } },
}

-- local empty = require('lualine.component'):extend()
-- function empty:draw(default_highlight)
--     self.status = ''
--     self.applied_separator = ''
--     self:apply_highlights(default_highlight)
--     self:apply_section_separators()
--     return self.status
-- end

-- Put proper separators and gaps between components in sections
local function process_sections(sections)
    for name, section in pairs(sections) do
        local left = name:sub(9, 10) < "x"
        -- for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
        for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
            -- table.insert(section, pos * 2, { empty, color = { fg = colors.white, bg = colors.white } })
            -- table.insert(section, pos * 2, { empty, color = { fg = colors.white, bg = colors.NONE } })
            -- This setting generate the background of the special charators
            table.insert(section, pos * 2, { empty, color = { fg = colors.NONE, bg = colors.NONE } })
        end
        for id, comp in ipairs(section) do
            if type(comp) ~= "table" then
                comp = { comp }
                section[id] = comp
            end
            -- comp.separator = left and { left = '🭦' } or { right = '🭀' }
            -- comp.subseparator = left and { left = '🭦' } or { right = '🭀' }

            comp.separator = left and { left = "🭦🭀" } or { right = "🭦🭀" }

            -- comp.subseparator = left and { left = '🭦🭀' } or { right = '🭦🭀' }
        end
    end
    return sections
end

local function search_result()
    if vim.v.hlsearch == 0 then
        return ""
    end
    local last_search = vim.fn.getreg("/")
    if not last_search or last_search == "" then
        return ""
    end
    local searchcount = vim.fn.searchcount({ maxcount = 9999 })
    return last_search .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
end

local function modified()
    if vim.bo.modified then
        return "+"
    elseif vim.bo.modifiable == false or vim.bo.readonly == true then
        return "-"
    end
    return ""
end

local icon_comp = b_components.cache_file_icon({ default = "", hl_colors = { "white", "transparent" } })

-- basic.file = {
--     hl_colors = {
--         default = { "white", "transparent" },
--     },
--     text = function(bufnr)
--         return {
--             -- return a string
--             { b_components.cache_file_icon({ default = "" }), "default" },
--             -- return a table
--             icon_comp(bufnr),
--         }
--     end,
-- }

basic.file = {
    name = 'file',
    hl_colors = {
        default = hl_list.Black,
        white = { 'white', 'black' },
        magenta = { 'magenta', 'black' },
    },
    text = function(_, _, width)
        if width > breakpoint_width then
            return {
                { b_components.cache_file_size(), 'default' },
                { ' ', '' },
                { b_components.cache_file_name('[No Name]', 'unique'), 'magenta' },
                { b_components.line_col_lua, 'white' },
                { b_components.progress_lua, '' },
                { ' ', '' },
                { b_components.file_modified(' '), 'magenta' },
            }
        else
            return {
                { b_components.cache_file_size(), 'default' },
                { ' ', '' },
                { b_components.cache_file_name('[No Name]', 'unique'), 'magenta' },
                { ' ', '' },
                { b_components.file_modified(' '), 'magenta' },
            }
        end
    end,
}

basic.file_right = {
    hl_colors = {
        default = hl_list.Black,
        white = { 'white', 'black' },
        magenta = { 'magenta', 'black' },
    },
    text = function(_, _, width)
        if width < breakpoint_width then
            return {
                { b_components.line_col_lua, 'white' },
                { b_components.progress_lua, '' },
            }
        end
    end,
}

--- it create a function then set a result of function to
--- `vim.b.wl_file_name`.It update value on BufEnter event otherwise it return
--- value from buffer`vim.b.wl_file_name`

local cache_utils = require("windline.cache_utils")
local cache_file_name = cache_utils.cache_on_buffer("BufEnter", "wl_file_name", function() end)

--- it is a filename function It shorten the first part of
--- pathname and the second part has a different color
--- if you don't use cache_on_buffer it will calculate every time you change mode
--- or redraw status line,
basic.file_name = {
    text = cache_utils.cache_on_buffer("BufEnter", "wl_file_name", function()
        print("calc file_name")
        local path = fn.expand("%")
        local name = fn.fnamemodify(path, ":p:t")
        if string.match(path, "^fugitive") ~= nil then
            name = name .. "[git]"
            return { { name, "git" } }
        end
        if path == "" or path == "./" then
            return "[No Name]"
        end
        local dir = path and fn.fnamemodify(fn.pathshorten(path), ":h:h") .. "/" or ""
        local fname = path and fn.fnamemodify(path, ":h:t") .. "/" .. name or name
        if dir == "./" then
            dir = fn.fnamemodify(fname, ":h") .. "/"
            fname = name
        end
        return {
            { dir, "dir" },
            { fname, "path" },
        }
    end),
    hl_colors = {
        dir = { "white_light", "blue" },
        path = { "white", "blue" },
        git = { "red", "blue" },
    },
}

-- https://github.com/windwp/windline.nvim

-- local default = {
--     filetypes = { "default" },
--     active = {
--         basic.square_mode,
--         basic.vi_mode,
--         basic.file,
--         basic.lsp_diagnos,
--         basic.divider,
--         basic.file_right,
--         basic.lsp_name,
--         basic.git,
--         { git_comps.git_branch(), { "magenta", "black" }, breakpoint_width },
--         { " ", hl_list.Black },
--         basic.square_mode,
--     },
--     inactive = {
--         { b_components.full_file_name, hl_list.Inactive },
--         basic.file_name_inactive,
--         basic.divider,
--         basic.divider,
--         { b_components.line_col, hl_list.Inactive },
--         { b_components.progress, hl_list.Inactive },
--     },
-- }

local default = {
    filetypes = { "default" },
    active = {
        basic.git_branch,
        basic.lsp_diagnos,
        basic.vi_mode,
        basic.vi_mode_sep,
        { " ", "" },
        -- basic.file_name,
        { "[", { "red", "transparent" } },
        { "%f", { "orange", "transparent" } },
        { "]", { "red", "transparent" } },
        -- wave_left,
        { " ", { "orange", "transparent" } },
        { vim_components.search_count() },
        basic.divider,
        -- wave_right,
        basic.line_col,
        basic.progress,
        basic.lsp_name,
        -- --- components...
        -- {'[',{'red', 'transparent'}},
        -- {'%f',{'green','transparent'}},
        -- {']',{'red','transparent'}},

        -- -- empty color definition uses the previous component colors
        -- {"%=", ''} ,

        -- -- hightlight groups can also be used
        -- {' ','StatusLine'},

        -- {' %3l:%-2c ',{'white','transparent'}}
    },
    inactive = {
        basic.file_name_inactive,
        basic.divider,
        basic.divider,
        basic.line_col_inactive,
        { "", { "white", "transparent" } },
        basic.progress_inactive,
        -- --- components...
        -- {'[',{'red', 'transparent'}},
        -- {'%f',{'green','transparent'}},
        -- {']',{'red','transparent'}},

        -- -- empty color definition uses the previous component colors
        -- {"%=", ''} ,

        -- -- hightlight groups can also be used
        -- {' ','StatusLine'},

        -- {' %3l:%-2c ',{'white','transparent'}}
    },
}


local repl = {}
-- local explorer = {}
local dashboard = {}

-- windline.setup({
--     colors_name = function(colors)
--         -- print(vim.inspect(colors))
--         -- ADD MORE COLOR HERE ----
--         return colors
--     end,
--     statuslines = {
--         default,
--         quickfix,
--         explorer,
--     },
-- })

windline.setup({

    -- this function will run on ColorScheme autocmd
    colors_name = function(colors)
        --- add new colors
        -- this color will not update if you change a colorscheme
        colors.gray = "#a0a1a7"

        -- print(vim.inspect(colors))
        -- ADD MORE COLOR HERE ----
        colors.transparent = "none" -- this is the issue
        colors.grey = "#3d3d3d"
        -- colors.orange    = "#d8a657"
        colors.debug_yellow = "#eae611"
        colors.debug_red = "#ff6902"

        -- copied from rakr/vim-two-firewatch
        colors.orange = "#c8ae9d"

        colors.white_light = "none"
        colors.black_light = "none"
        colors.black = "none"

        colors.wavedefault = colors.black

        colors.waveright1 = colors.wavedefault
        colors.waveright2 = colors.wavedefault
        colors.waveright3 = colors.wavedefault
        colors.waveright4 = colors.wavedefault
        colors.waveright5 = colors.wavedefault
        colors.waveright6 = colors.wavedefault
        colors.waveright7 = colors.wavedefault
        colors.waveright8 = colors.wavedefault
        colors.waveright9 = colors.wavedefault

        -- colors.FilenameFg = colors.white_light
        colors.FilenameFg = colors.orange
        -- colors.FilenameBg = colors.black
        -- colors.FilenameBg = colors.black_light
        colors.FilenameBg = colors.transparent

        colors.arrowwhite = colors.black_light

        colors.arrowleft1 = colors.white
        colors.arrowleft2 = colors.white
        colors.arrowleft3 = colors.white
        colors.arrowleft4 = colors.white
        colors.arrowleft5 = colors.white

        colors.arrowright1 = colors.white
        colors.arrowright2 = colors.white
        colors.arrowright3 = colors.white
        colors.arrowright4 = colors.white
        colors.arrowright5 = colors.white

        colors.wavewhite = colors.white

        colors.waveleft1 = colors.white
        colors.waveleft2 = colors.white
        colors.waveleft3 = colors.white
        colors.waveleft4 = colors.white
        colors.waveleft5 = colors.white

        colors.waveright1 = colors.white
        colors.waveright2 = colors.white
        colors.waveright3 = colors.white
        colors.waveright4 = colors.white
        colors.waveright5 = colors.white

        colors.StatusFg = colors.ActiveFg
        colors.StatusBg = colors.ActiveBg

        -- dynamically get color from colorscheme hightlight group
        local searchFg, searchBg = require("windline.themes").get_hl_color("Search")
        colors.SearchFg = searchFg or colors.white
        colors.SearchBg = searchBg or colors.yellow

        return colors
    end,
    statuslines = {
        -- options = {
        --     icons_enabled = true,
        --     theme = theme,
        --     component_separators = '',
        --     -- component_separators = { left = '🭦🭀', right = '🭦🭀' },
        --     -- section_separators = { left = '🭀', right = '🭦' },
        --     -- section_separators = left and { left = '🭦🭀' } or { right = '🭦🭀' },
        --     section_separators = { left = "🭦🭀", right = "🭦🭀" },
        --     disabled_filetypes = {},
        --     always_divide_middle = true,
        -- },
        -- sections = process_sections {
        --     lualine_a = { 'mode' },
        --     lualine_b = {
        --         'branch',
        --         'diff',
        --         {
        --             'diagnostics',
        --             source = { 'nvim' },
        --             sections = { 'error' },
        --             -- diagnostics_color = { error = { bg = colors.red, fg = colors.white } },
        --             -- diagnostics_color = { error = { bg = colors.red, fg = colors.NONE } },
        --             diagnostics_color = { error = { fg = colors.red, bg = colors.NONE } },
        --         },
        --         {
        --             'diagnostics',
        --             source = { 'nvim' },
        --             sections = { 'warn' },
        --             -- diagnostics_color = { warn = { bg = colors.orange, fg = colors.white } },
        --             -- diagnostics_color = { warn = { bg = colors.orange, fg = colors.NONE } },
        --             diagnostics_color = { warn = { fg = colors.orange, bg = colors.NONE } },
        --         },
        --         { 'filename', file_status = false, path = 1 },
        --         -- { modified, color = { bg = colors.red } },
        --         { modified, color = { fg = colors.red } },
        --         {
        --             '%w',
        --             cond = function()
        --                 return vim.wo.previewwindow
        --             end,
        --         },
        --         {
        --             '%r',
        --             cond = function()
        --                 return vim.bo.readonly
        --             end,
        --         },
        --         {
        --             '%q',
        --             cond = function()
        --                 return vim.bo.buftype == 'quickfix'
        --             end,
        --         },
        --     },
        --     lualine_c = {},
        --     lualine_x = {},
        --     lualine_y = { search_result, 'filetype' },
        --     lualine_z = { '%l:%c', '%p%%/%L' },
        -- },
        -- inactive_sections = {
        --     lualine_a = {},
        --     lualine_b = {},
        --     lualine_c = { '%f %y %m' },
        --     lualine_x = {},
        --     lualine_y = {},
        --     lualine_z = {}
        -- },
        -- tabline = {},
        -- extensions = {'quickfix'},
        default,
        quickfix,
        repl,
        explorer,
        dashboard,
        animation
    },
})

local blue_colors = {
    "#90CAF9",
    "#64B5F6",
    "#42A5F5",
    "#2196F3",
    "#1E88E5",
    "#1976D2",
    "#1565C0",
    "#0D47A1",
}

windline.add_component({
        name = "test",
        hl_colors = {
            -- red = { 'red', 'NormalBg' },
            red = { "red", "transparent" },
        },
        text = function()
            return {
                { "🧛 ", "red" },
                { "new quiet", "red" },
                { " 🧛 ", "red" },
            }
        end,
    }, {
        filetype = "default",
        -- it will add a new component before git component
        -- you can use and index number
        position = "git",
        -- if you want to add on inactive component
        --kind ='inactive',
        autocmd = false,
        -- set it = true mean when you are on custom filetype component will add to the default statusline
        -- then remove after you leave that filetype
    })

animation.animation({
        data = {
            { "red_light", effects.rainbow() },
            { "green_light", effects.rainbow() },
            { "cyan_light", effects.blackwhite() },
            { "FilenameBg", effects.rainbow() },
            { "FilenameBg", effects.blackwhite() },
        },
        timeout = 10,
        delay = 200,
        interval = 100,
    })

-- copied from wlanimation.effects
-- we need a different value per animation but we cache a value if it is same
-- key ontick.
-- it need to sure animation have different per color name
local wrap = function(fnc)
    return function(...)
        local opt = { ... }
        return function()
            return fnc(unpack(opt))
        end
    end
end

-- -- you can write your own effect
-- local HSL = require('wlanimation.hsl')
-- animation.animation({
--         data = {
--             -- {'red', effects.wrap(function(color)
--             {'red', wrap(function(color)
--                 return HSL.new(color.H + 1, color.S, color.L)
--             end)},
--         },
--         timeout = 100,
--         delay = 200,
--         interval = 100,
--     })

-- -- Change brightness of auto_colors
-- -- darken incase of light theme lighten incase of dark theme
--
-- local normal_color = utils.extract_highlight_colors('Normal', 'bg')
-- if normal_color ~= nil then
--     if get_color_brightness(normal_color) > 0.5 then
--         brightness_modifier_parameter = -brightness_modifier_parameter
--     end
--     for name, color in pairs(colors) do
--         auto_colors[name] = brightness_modifier(color, brightness_modifier_parameter)
--     end
-- end

-- -- basic theme defination
-- local M = {
--     normal = {
--         a = { bg = auto_colors.normal,  fg = auto_colors.back1, gui = 'bold' },
--         b = { bg = auto_colors.back1,   fg = auto_colors.normal },
--         c = { bg = auto_colors.back2,   fg = auto_colors.fore },
--     },
--     insert = {
--         a = { bg = auto_colors.insert,  fg = auto_colors.back1, gui = 'bold' },
--         b = { bg = auto_colors.back1,   fg = auto_colors.insert },
--         c = { bg = auto_colors.back2,   fg = auto_colors.fore },
--     },
--     replace = {
--         a = { bg = auto_colors.replace, fg = auto_colors.back1, gui = 'bold' },
--         b = { bg = auto_colors.back1,   fg = auto_colors.replace },
--         c = { bg = auto_colors.back2,   fg = auto_colors.fore },
--     },
--     visual = {
--         a = { bg = auto_colors.visual,  fg = auto_colors.back1, gui = 'bold' },
--         b = { bg = auto_colors.back1,   fg = auto_colors.visual },
--         c = { bg = auto_colors.back2,   fg = auto_colors.fore },
--     },
--     command = {
--         a = { bg = auto_colors.command, fg = auto_colors.back1, gui = 'bold' },
--         b = { bg = auto_colors.back1,   fg = auto_colors.command },
--         c = { bg = auto_colors.back2,   fg = auto_colors.fore },
--     },
-- }
--

-- M.terminal = M.command
-- M.inactive = M.normal
--
-- -- Apply prpper contrast so text is readable
-- for _, section in pairs(M) do
--     for _, highlight in pairs(section) do
--         apply_contrast(highlight)
--     end
-- end
--
-- -- return M
--
-- local M = {}
--
-- M.setup = function()
--     windline.setup({
--         colors_name = function(colors)
--             colors.StatusFg = colors.ActiveFg
--             colors.StatusBg = colors.ActiveBg
--             return colors
--         end,
--         statuslines = {
--             default,
--             explorer,
--         },
--     })
-- end
--
-- M.setup()

-- M.change_color = function(bgcolor, fgcolor)
--     local colors = windline.get_colors()
--     colors.StatusFg = fgcolor or colors.StatusFg
--     colors.StatusBg = bgcolor or colors.StatusBg
--     windline.on_colorscheme(colors)
-- end

-- return M
