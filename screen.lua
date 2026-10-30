local _dir = debug.getinfo(1, "S").source:sub(2):match("(.*[/\\])") or "./"
local function lrequire(name)
    local key = _dir .. name
    if not package.loaded[key] then
        package.loaded[key] = assert(loadfile(_dir .. name .. ".lua"))()
    end
    return package.loaded[key]
end

local Device          = require("device")
local FrameContainer  = require("ui/widget/container/framecontainer")
local HorizontalGroup = require("ui/widget/horizontalgroup")
local HorizontalSpan  = require("ui/widget/horizontalspan")
local Size            = require("ui/size")
local UIManager       = require("ui/uimanager")
local VerticalGroup   = require("ui/widget/verticalgroup")
local VerticalSpan    = require("ui/widget/verticalspan")
local _               = require("i18n")
local T               = require("ffi/util").template

local ScreenBase             = require("screen_base")
local MenuHelper             = require("menu_helper")
local KeyboardWidget         = lrequire("common/keyboard_widget")
local CryptogramBoard        = lrequire("board")
local CryptogramBoardWidget  = lrequire("board_widget")

local DeviceScreen = Device.screen

-- ---------------------------------------------------------------------------
-- CryptogramScreen
-- ---------------------------------------------------------------------------

local GAME_RULES_EN = _([[
Cryptogram — Rules

Decode the encrypted message by cracking the letter substitution cipher.

Each letter has been replaced by another letter.
The same substitution is used consistently throughout the message.
Tap a cipher letter to select it, then tap the keyboard to type your guess for the real letter.
Typing the same guess again erases it; Clear erases every guess.
Use logic and common word patterns to deduce the full message.
]])

local GAME_RULES_FR = [[
Cryptogramme — Règles

Décodez le message chiffré en craquant son chiffre par substitution de lettres.

Chaque lettre a été remplacée par une autre lettre, de façon cohérente dans tout le texte.
Appuyez sur une lettre chiffrée pour la sélectionner, puis tapez votre proposition.
Retapez la même lettre pour l'effacer ; « Effacer tout » retire toutes les propositions.
Utilisez les motifs des mots et la fréquence des lettres pour déduire le message complet.
]]

local CryptogramScreen = ScreenBase:extend{}

function CryptogramScreen:init()
    local state = self.plugin:loadState()
    local lang  = self.plugin:getSetting("lang", "en")
    self.board  = CryptogramBoard:new{ lang = lang }
    if not self.board:load(state) then
        -- fresh game
    end
    ScreenBase.init(self)
end

function CryptogramScreen:serializeState()
    return self.board:serialize()
end

function CryptogramScreen:buildLayout()
    local is_landscape = self:isLandscape()

    local title_bar = self:buildTitleBar(_("Cryptogram"), function()
        return {
            { text = _("New game"),     callback = function() self:onNewGame() end },
            { text = self:_langLabel(), callback = function() self:openLangMenu() end },
            self:makeRulesButtonConfig(GAME_RULES_EN, GAME_RULES_FR),
        }
    end)

    local controls_w = self:getControlsWidth()
    self.status_text:setMaxWidth(controls_w)
    self.keyboard_widget = KeyboardWidget.build{
        width      = controls_w,
        key_height = DeviceScreen:scaleBySize(52),
        onKey      = function(k) self:onVirtualKey(k) end,
    }
    local controls = VerticalGroup:new{
        align = "center",
        self.status_text,
        VerticalSpan:new{ width = Size.span.vertical_large },
        self.keyboard_widget,
        VerticalSpan:new{ width = Size.span.vertical_default },
        self:buildActionBar({
            { text = _("Clear"), callback = function() self:onClearAll() end },
        }),
    }

    -- The phrase gets the whole board budget: the widget picks the largest
    -- letter cells for which the word-wrapped text still fits.
    local frame_pad   = Size.padding.large
    local frame_extra = 2 * (frame_pad + Size.border.window)
    local budget_w, budget_h = self:getBoardBudget(title_bar, controls)
    self.board_widget = CryptogramBoardWidget:new{
        board             = self.board,
        max_width         = math.max(budget_w - frame_extra, 80),
        max_height        = math.max(budget_h - frame_extra, 60),
        cipherTapCallback = function(ch) self:onCipherTap(ch) end,
    }

    local board_frame = FrameContainer:new{
        padding = frame_pad,
        margin  = 0,
        self.board_widget,
    }

    if is_landscape then
        local content = HorizontalGroup:new{
            align = "center",
            board_frame,
            HorizontalSpan:new{ width = self:getGutter() },
            controls,
        }
        self:buildLandscapeLayout(title_bar, content)
    else
        self:buildPortraitLayout(title_bar, board_frame,
            VerticalGroup:new{ align = "center", controls, VerticalSpan:new{ width = self:getGutter() } })
    end
    self:updateStatus()
end

function CryptogramScreen:isRoundOver()
    return self.board:isComplete()
end

function CryptogramScreen:onCipherTap(ch)
    self.board:selectCipher(ch)
    self.board_widget:refresh()
    self:updateStatus()
    self.plugin:saveState(self.board:serialize())
end

function CryptogramScreen:onVirtualKey(key)
    if not self.board.selected_cipher then
        self:updateStatus(_("Tap a cipher letter first."))
        return
    end
    -- A key pressed on an already solved phrase must not count another win.
    local was_complete = self.board:isComplete()
    self.board:assignLetter(key)
    self.board_widget:refresh()
    if self.board:isComplete() and not was_complete then
        self.board.wins = self.board.wins + 1
        self:updateStatus(T(_("Solved! Wins: %1"), self.board.wins))
        self.plugin:saveState(self.board:serialize())
    else
        self:updateStatus()
        self.plugin:saveState(self.board:serialize())
    end
    -- Re-typing a letter of a solved phrase can un-solve it again.
    self:refreshActionBar()
end

function CryptogramScreen:onClearAll()
    self.board:clearAll()
    self.board_widget:refresh()
    self:refreshActionBar()
    self:updateStatus()
    self.plugin:saveState(self.board:serialize())
end

function CryptogramScreen:onNewGame()
    local lang = self.plugin:getSetting("lang", "en")
    self.board.lang = lang
    local wins = self.board.wins
    self.board:newGame()
    self.board.wins = wins
    self.plugin:saveState(self.board:serialize())
    self:buildLayout()
    UIManager:setDirty(self, function() return "ui", self.dimen end)
end

function CryptogramScreen:openLangMenu()
    local items = {
        { id = "en", text = _("English") },
        { id = "fr", text = _("Français") },
    }
    MenuHelper.openPickerMenu{
        title      = _("Language"),
        items      = items,
        current_id = self.plugin:getSetting("lang", "en"),
        parent     = self,
        on_select  = function(lang)
            self.plugin:saveSetting("lang", lang)
            self.board.lang = lang
            if self.lang_btn then
                self.lang_btn:setText(self:_langLabel(), self.lang_btn.width)
            end
            self:onNewGame()
        end,
    }
end

function CryptogramScreen:updateStatus(msg)
    local status
    if msg then
        status = msg
    else
        -- The selected letter and its guess are shaded on the board itself;
        -- naming them here too only overflowed the landscape side panel.
        local decoded, total = self.board:decodedCount()
        status = T(_("Decoded: %1/%2"), decoded, total)
    end
    ScreenBase.updateStatus(self, status)
end

function CryptogramScreen:_langLabel()
    local lang = self.plugin:getSetting("lang", "en")
    return T(_("Language: %1"), lang == "fr" and "FR" or "EN")
end

return CryptogramScreen
