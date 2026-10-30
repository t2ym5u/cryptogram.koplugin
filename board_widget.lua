local Blitbuffer     = require("ffi/blitbuffer")
local Device         = require("device")
local Font           = require("ui/font")
local Geom           = require("ui/geometry")
local GestureRange   = require("ui/gesturerange")
local InputContainer = require("ui/widget/container/inputcontainer")
local RenderText     = require("ui/rendertext")
local UIManager      = require("ui/uimanager")

local C_BG       = Blitbuffer.COLOR_WHITE
local C_CELL     = Blitbuffer.COLOR_GRAY_E
local C_SELECTED = Blitbuffer.COLOR_GRAY_9
local C_DECODED  = Blitbuffer.COLOR_GRAY_D
local C_BORDER   = Blitbuffer.COLOR_BLACK
local C_TEXT     = Blitbuffer.COLOR_BLACK
local C_DIM      = Blitbuffer.COLOR_GRAY_7

local Screen = Device.screen

-- Largest face whose ink for `sample` fits max_w x max_h. Measured unbounded
-- (a max_width limit cuts the text, so the width test could never fail), ink
-- height is y_top + y_bottom, and Font:getFace scales its size by the DPI, so
-- the pixel bound is converted back first.
local function fitFace(name, sample, max_w, max_h)
    local lo = 6
    local hi = math.max(lo, math.floor(max_h * 1000 / Screen:scaleBySize(1000)) * 2)
    local best = lo
    while lo <= hi do
        local mid = math.floor((lo + hi) / 2)
        local m = RenderText:sizeUtf8Text(0, Screen:getWidth(), Font:getFace(name, mid), sample, true, false)
        if m.x <= max_w and m.y_top + m.y_bottom <= max_h then
            best, lo = mid, mid + 1
        else
            hi = mid - 1
        end
    end
    return Font:getFace(name, best)
end

-- Centre `text` on (cx, cy): the baseline sits half the ink height below cy.
local function drawCentered(bb, face, text, cx, cy, color)
    local m = RenderText:sizeUtf8Text(0, Screen:getWidth(), face, text, true, false)
    RenderText:renderUtf8Text(bb, cx - math.floor(m.x / 2),
        cy + math.floor((m.y_top - m.y_bottom) / 2), face, text, true, false, color)
end

-- Split the ciphertext into words, keeping each letter's index.
local function splitWords(text)
    local words, cur = {}, nil
    for i = 1, #text do
        local ch = text:sub(i, i)
        if ch == " " then
            cur = nil
        else
            if not cur then cur = {}; words[#words + 1] = cur end
            cur[#cur + 1] = { ch = ch, idx = i }
        end
    end
    return words
end

-- Greedy word wrap at `cols` cells per line, one blank cell between words.
-- A word longer than a line is split (never happens with the bundled
-- phrases, but must not loop). Returns a list of lines, each a list of
-- tokens ({ch, idx} or false for the gap).
local function wrapWords(words, cols)
    local lines, line = {}, {}
    for _, word in ipairs(words) do
        local need = #word + (#line > 0 and 1 or 0)
        if #line > 0 and #line + need > cols then
            lines[#lines + 1] = line
            line = {}
        end
        if #line > 0 then line[#line + 1] = false end
        for _, tok in ipairs(word) do
            if #line >= cols then
                lines[#lines + 1] = line
                line = {}
            end
            line[#line + 1] = tok
        end
    end
    if #line > 0 then lines[#lines + 1] = line end
    return lines
end

-- ---------------------------------------------------------------------------
-- CryptogramBoardWidget
-- ---------------------------------------------------------------------------

local CryptogramBoardWidget = InputContainer:extend{
    board             = nil,
    max_width         = 300,
    max_height        = 200,
    cipherTapCallback = nil,
}

function CryptogramBoardWidget:init()
    self:_layout()

    self.letter_face = fitFace("smallinfofont", "W",
        math.floor(self.cell_w * 0.75), math.floor(self.cell_h * 0.55))

    self.ges_events = {
        CipherTap = { GestureRange:new{ ges = "tap", range = function() return self.paint_rect end } },
    }
end

-- Pick the largest cell for which the word-wrapped phrase fits the room.
-- Each letter is a cipher cell over a guess cell; lines are centred.
function CryptogramBoardWidget:_layout()
    local words = splitWords(self.board.ciphered or "")
    local longest, letters = 1, 0
    for _, w in ipairs(words) do
        longest = math.max(longest, #w)
        letters = letters + #w + 1
    end
    local max_w, max_h = self.max_width, self.max_height

    -- A cell is 10% taller than wide; a line is two cells, a hairline gap
    -- between them and a third of a cell before the next line.
    local function pitch(cw)
        local ch = math.floor(cw * 1.1)
        local inner = math.max(2, math.floor(ch * 0.08))
        return ch, inner, 2 * ch + inner + math.floor(ch * 0.35)
    end

    -- No more than ~a dozen cells per line, so a short phrase is not drawn
    -- at billboard size.
    local cell_w = math.floor(max_w / math.max(longest, math.min(letters, 12)))
    local lines
    while true do
        lines = wrapWords(words, math.max(1, math.floor(max_w / cell_w)))
        local _, _, row_h = pitch(cell_w)
        if cell_w <= 12 or #lines * row_h <= max_h then break end
        cell_w = cell_w - 1
    end
    local cell_h, inner, row_h = pitch(cell_w)

    local w = 0
    for _, line in ipairs(lines) do w = math.max(w, #line * cell_w) end
    self.rows   = lines
    self.cell_w = cell_w
    self.cell_h = cell_h
    self.inner  = inner
    self.row_h  = row_h
    self.w      = math.min(w, max_w)
    -- The last line needs no gap below it.
    self.h      = math.max(1, #lines * row_h - (row_h - 2 * cell_h - inner))
    self.dimen  = Geom:new{ w = self.w, h = self.h }
    self.paint_rect = nil
end

-- Left edge of line `ri`, relative to the widget: lines are centred.
function CryptogramBoardWidget:_lineOffset(ri)
    return math.floor((self.w - #self.rows[ri] * self.cell_w) / 2)
end

function CryptogramBoardWidget:onCipherTap(_, ges)
    if not self.paint_rect then return true end
    local rect = self.paint_rect
    local lx = ges.pos.x - rect.x
    local ly = ges.pos.y - rect.y
    if lx < 0 or ly < 0 or lx >= self.w or ly >= self.h then return true end

    local row_idx = math.floor(ly / self.row_h) + 1
    local row = self.rows[row_idx]
    if not row then return true end
    -- Either half of a letter selects it: the guess cell is as good a
    -- target as the cipher cell above it.
    local within_row_y = ly - (row_idx - 1) * self.row_h
    if within_row_y >= 2 * self.cell_h + self.inner then return true end

    local col_idx = math.floor((lx - self:_lineOffset(row_idx)) / self.cell_w) + 1
    local token = row[col_idx]
    if token and token.ch >= "A" and token.ch <= "Z" then
        if self.cipherTapCallback then self.cipherTapCallback(token.ch) end
    end
    return true
end

function CryptogramBoardWidget:paintTo(bb, x, y)
    self.paint_rect = Geom:new{ x = x, y = y, w = self.w, h = self.h }
    local board    = self.board
    local cell_w   = self.cell_w
    local cell_h   = self.cell_h
    local row_h    = self.row_h
    local half_w   = math.floor(cell_w / 2)
    local half_h   = math.floor(cell_h / 2)

    bb:paintRect(x, y, self.w, self.h, C_BG)

    local function box(bx, by, bg)
        bb:paintRect(bx + 1, by + 1, cell_w - 2, cell_h - 2, bg)
        bb:paintRect(bx, by, cell_w, 1, C_BORDER)
        bb:paintRect(bx, by + cell_h - 1, cell_w, 1, C_BORDER)
        bb:paintRect(bx, by, 1, cell_h, C_BORDER)
        bb:paintRect(bx + cell_w - 1, by, 1, cell_h, C_BORDER)
    end

    for ri, row in ipairs(self.rows) do
        local ry = y + (ri - 1) * row_h
        local ox = x + self:_lineOffset(ri)
        for ci, token in ipairs(row) do
            if token and token.ch >= "A" and token.ch <= "Z" then
                local cx = ox + (ci - 1) * cell_w
                local is_sel = token.ch == board.selected_cipher
                local decoded = board.user_map[token.ch]

                -- cipher cell
                box(cx, ry, is_sel and C_SELECTED or C_CELL)
                drawCentered(bb, self.letter_face, token.ch, cx + half_w, ry + half_h,
                    is_sel and C_TEXT or C_DIM)

                -- decoded cell
                local dy = ry + cell_h + self.inner
                box(cx, dy, C_DECODED)
                if decoded then
                    drawCentered(bb, self.letter_face, decoded, cx + half_w, dy + half_h, C_TEXT)
                end
            end
        end
    end
end

function CryptogramBoardWidget:refresh()
    UIManager:setDirty(self, function()
        return "ui", self.paint_rect or self.dimen
    end)
end

return CryptogramBoardWidget
