local cmd = vim.cmd
local fn = vim.fn
local gl = require("galaxyline")
local gls = gl.section
gl.short_line_list = {"NvimTree", "vim-plug",'plug', 'term', 'startify', 'split'}

local colors = {
  bg = "#191919",
  fg = "#FFFFFF",
  -- lbg = "#6E8888",
  lbg = "#191919",
  line_bg = "#252525",
  magenta = "#C28788",
  fg_green = "#334648",
  blue = "#4B5056",
  red= "#4A3335",
  yellow = "#EBCB8B",
  cyan= "#919652",
  orange= "#E2995C",
  darkblue= "#66899D",
  purple= "#b88",
  green= "#334648",
  gray= "#606360",
  black="#252525"
}


local function insert_mid(element)
    table.insert(gls.mid, element)
end

local function lsp_status(status)
    shorter_stat = ''
    for match in string.gmatch(status, "[^%s]+")  do
        err_warn = string.find(match, "^[WE]%d+", 0)
        if not err_warn then
            shorter_stat = shorter_stat .. ' ' .. match
        end
    end
    return shorter_stat
end

local function trailing_whitespace()
    local trail = vim.fn.search("\\s$", "nw")
    if trail ~= 0 then
        return ' '
    else
        return nil
    end
end

-- insert_left insert item at the left panel
local function insert_left(element)
  table.insert(gls.left, element)
end

local function insert_blank_line_at_left()
insert_left {
  Space = {
    provider = function () return ' ' end,
    highlight = {colors.bg,colors.bg}
  }
}
end


local function insert_right(element)
  table.insert(gls.right, element)
end

local function insert_blank_line_at_right()
insert_right {
  Space = {
    provider = function () return '  ' end,
    highlight = {colors.fg, colors.fg}
  }
}
end


local checkwidth = function()
  local squeeze_width = fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

TrailingWhiteSpace = trailing_whitespace

local buffer_not_empty = function()
  if fn.empty(fn.expand("%:t")) ~= 1 then
    return true
  end
  return false
end

-----------------------------------------------------
----------------- start insert ----------------------
-----------------------------------------------------

insert_blank_line_at_left()
insert_blank_line_at_left()


insert_left {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local mode_color = {
        n = colors.fg,
        i = colors.magenta,
        v = colors.magenta,
        [""] = colors.magenta,
        V = colors.magenta,
        c = colors.magenta,
        no = colors.magenta,
        s = colors.orange,
        S = colors.orange,
        [""] = colors.orange,
        ic = colors.yellow,
        R = colors.purple,
        Rv = colors.purple,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ["r?"] = colors.cyan,
        ["!"] = colors.red,
        t = colors.red
      }
      cmd("hi GalaxyViMode guifg=" .. mode_color[fn.mode()])
      -- return "    "
      return "   "
    end,
    highlight = {colors.lbg, "bold" }
  }
}

insert_blank_line_at_left()
insert_blank_line_at_left()

insert_left{
    Start = {
    provider = function() return "   " end,
    highlight = {colors.fg, colors.bg},
  }
}

insert_left{
  FileName = {
    -- provider = "FileName",
    provider = function()
      return fn.expand("%:f")
    end,
    condition = buffer_not_empty,
    separator = "   ",
    separator_highlight = {colors.red, colors.bg},
    highlight = {colors.fg, colors.bg}
  }
}


insert_left {
  GitBranch = {
    provider = "GitBranch",
    separator = "",
    condition = require("galaxyline.provider_vcs").check_git_workspace,
    separator_highlight = {colors.purple, colors.bg},
    highlight = {colors.fg, colors.bg}
  }
}


insert_left {
  GitIcon = {
    provider = function()
      return "   "
      -- return "  "
    end,
    condition = require("galaxyline.provider_vcs").check_git_workspace,
    highlight = {colors.fg, colors.bg}
  }
}

------------------ MID -----------------------
insert_mid{
    ShowLspClient = {
        provider = 'GetLspClient',
        condition = function()
            local tbl = {['startify'] = true, [''] = true}
            if tbl[vim.bo.filetype] then
                return false
            end
            return true
            end,
            icon = ' ',
            highlight = {colors.fg, colors.bg}
    }
}

----------------- RIGHT ----------------------


insert_right {
  DiffAdd = {
    provider = "DiffAdd",
    condition = checkwidth,
    icon = "   ",
    highlight = {colors.fg, colors.bg}
  }
}

insert_right {
  DiffModified = {
    provider = "DiffModified",
    condition = checkwidth,
    icon = "  ",
    highlight = {colors.fg, colors.bg}
  }
}

insert_right {
  DiffRemove = {
    provider = "DiffRemove",
    condition = checkwidth,
    icon = "  ",
    highlight = {colors.fg, colors.bg}
  }
}

insert_blank_line_at_right()
insert_blank_line_at_right()
insert_blank_line_at_right()
insert_blank_line_at_right()
