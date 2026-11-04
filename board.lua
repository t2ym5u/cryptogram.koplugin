-- Phrases live in data/phrases_<lang>.lua ({ text, source } pairs), loaded
-- the first time a language is played, one language at a time (switching
-- drops the other), and dropped by CryptogramBoard.release() when the game
-- screen closes (quick to read again). Draws go through the shared
-- SeenHistory when the board is given the plugin (its settings hold the
-- history), so a phrase does not come back before the whole list has been
-- played; without a plugin (tests, old callers) they are plain random.
local SeenHistory = require("seen_history")

local _dir = debug.getinfo(1, "S").source:sub(2):match("(.*[/\\])") or "./"

local PHRASES = {}

local function loadPhrases(lang)
    if lang ~= "fr" then lang = "en" end
    if not PHRASES[lang] then
        PHRASES = { [lang] = assert(loadfile(_dir .. "data/phrases_" .. lang .. ".lua"))() }
    end
    return PHRASES[lang]
end

-- Phrases seen are remembered per language, by their text.
local HISTORY_MAX = 1500
local function phraseId(entry) return entry[1] end

local ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

-- ---------------------------------------------------------------------------
-- CryptogramBoard
-- ---------------------------------------------------------------------------

local CryptogramBoard = {}
CryptogramBoard.__index = CryptogramBoard

function CryptogramBoard:new(opts)
    opts = opts or {}
    local obj = setmetatable({
        lang            = opts.lang or "en",
        plugin          = opts.plugin,
        phrase          = "",
        source          = nil,
        ciphered        = "",
        cipher_map      = {},
        decipher_map    = {},
        user_map        = {},
        selected_cipher = nil,
        wins            = opts.wins or 0,
    }, self)
    if not opts.defer then obj:newGame() end
    return obj
end

-- The { text, source } list of a language ("fr", else English).
function CryptogramBoard.phrases(lang)
    return loadPhrases(lang)
end

function CryptogramBoard:_history()
    local lang = self.lang == "fr" and "fr" or "en"
    return SeenHistory.open(self.plugin, "phrases_" .. lang,
        { max = HISTORY_MAX, id_of = phraseId })
end

function CryptogramBoard:_pickEntry()
    local list = loadPhrases(self.lang)
    if self.plugin then
        local entry = self:_history():pick(list)
        if entry then return entry end
    end
    return list[math.random(#list)]
end

function CryptogramBoard:newGame()
    local entry  = self:_pickEntry()
    local phrase = entry[1]
    self.phrase  = phrase
    self.source  = entry[2]

    -- build a random bijective substitution cipher (never map letter to itself)
    local letters = {}
    for i = 1, 26 do letters[i] = ALPHA:sub(i, i) end

    -- Fisher-Yates shuffle to get a derangement
    local perm = {}
    for i = 1, 26 do perm[i] = i end
    repeat
        for i = 26, 2, -1 do
            local j = math.random(i)
            perm[i], perm[j] = perm[j], perm[i]
        end
        -- check: no fixed points
        local ok = true
        for i = 1, 26 do
            if perm[i] == i then ok = false; break end
        end
        if ok then break end
    until false

    self.cipher_map   = {}
    self.decipher_map = {}
    for i = 1, 26 do
        local plain  = letters[i]
        local cipher = letters[perm[i]]
        self.cipher_map[plain]   = cipher
        self.decipher_map[cipher] = plain
    end

    -- encipher the phrase
    local ciphered = {}
    for i = 1, #phrase do
        local ch = phrase:sub(i, i)
        if ch >= "A" and ch <= "Z" then
            ciphered[i] = self.cipher_map[ch]
        else
            ciphered[i] = ch
        end
    end
    self.ciphered = table.concat(ciphered)

    self.user_map        = {}
    self.selected_cipher = nil
end

function CryptogramBoard:selectCipher(letter)
    if letter >= "A" and letter <= "Z" then
        self.selected_cipher = letter
    end
end

-- Assign a plain letter to the currently selected cipher letter
function CryptogramBoard:assignLetter(plain)
    local cipher = self.selected_cipher
    if not cipher then return end
    if self.user_map[cipher] == plain then
        self.user_map[cipher] = nil
    else
        -- remove any existing assignment for this plain letter
        for k, v in pairs(self.user_map) do
            if v == plain then self.user_map[k] = nil end
        end
        self.user_map[cipher] = plain
    end
end

function CryptogramBoard:clearAll()
    self.user_map        = {}
    self.selected_cipher = nil
end

-- Returns the phrase with user_map applied (? for undecoded letters)
function CryptogramBoard:getDisplayPhrase()
    local result = {}
    for i = 1, #self.ciphered do
        local ch = self.ciphered:sub(i, i)
        if ch >= "A" and ch <= "Z" then
            result[i] = self.user_map[ch] or "?"
        else
            result[i] = ch
        end
    end
    return table.concat(result)
end

function CryptogramBoard:isComplete()
    for i = 1, #self.ciphered do
        local ch = self.ciphered:sub(i, i)
        if ch >= "A" and ch <= "Z" then
            if self.user_map[ch] ~= self.decipher_map[ch] then
                return false
            end
        end
    end
    return true
end

function CryptogramBoard:decodedCount()
    local total   = 0
    local decoded = 0
    local seen    = {}
    for i = 1, #self.ciphered do
        local ch = self.ciphered:sub(i, i)
        if ch >= "A" and ch <= "Z" and not seen[ch] then
            seen[ch] = true
            total = total + 1
            if self.user_map[ch] then decoded = decoded + 1 end
        end
    end
    return decoded, total
end

-- ---------------------------------------------------------------------------
-- Persistence
-- ---------------------------------------------------------------------------

function CryptogramBoard:serialize()
    local cm, dm, um = {}, {}, {}
    for k, v in pairs(self.cipher_map)   do cm[#cm+1] = { k, v } end
    for k, v in pairs(self.decipher_map) do dm[#dm+1] = { k, v } end
    for k, v in pairs(self.user_map)     do um[#um+1] = { k, v } end
    return {
        lang            = self.lang,
        phrase          = self.phrase,
        source          = self.source,
        ciphered        = self.ciphered,
        cipher_map      = cm,
        decipher_map    = dm,
        user_map        = um,
        selected_cipher = self.selected_cipher,
        wins            = self.wins,
    }
end

function CryptogramBoard:load(data)
    if type(data) ~= "table" or not data.phrase then return false end
    self.lang    = data.lang    or "en"
    self.phrase  = data.phrase  or ""
    self.source  = data.source
    self.ciphered = data.ciphered or ""
    self.wins    = data.wins    or 0
    self.selected_cipher = data.selected_cipher

    self.cipher_map   = {}
    self.decipher_map = {}
    self.user_map     = {}
    for _, pair in ipairs(data.cipher_map   or {}) do self.cipher_map[pair[1]]   = pair[2] end
    for _, pair in ipairs(data.decipher_map or {}) do self.decipher_map[pair[1]] = pair[2] end
    for _, pair in ipairs(data.user_map     or {}) do self.user_map[pair[1]]     = pair[2] end
    return true
end

-- Drops the loaded phrase list (called when the game screen closes); the
-- next game reads its language's list again.
function CryptogramBoard.release()
    PHRASES = {}
end

-- The languages whose phrase list is loaded now (for the specs).
function CryptogramBoard.loadedLanguages()
    local out = {}
    for lang in pairs(PHRASES) do out[#out + 1] = lang end
    table.sort(out)
    return out
end

return CryptogramBoard
