-- The phrase lists (data/phrases_*.lua) and the no-repeat draw.
local DIR = debug.getinfo(1, "S").source:sub(2):match("(.*[/\\])") or "./"
package.path = DIR .. "?.lua;" .. DIR .. "common/?.lua;" .. package.path

local function fakePlugin(store)
    store = store or {}
    return {
        getSetting  = function(_self, k, d) if store[k] == nil then return d end return store[k] end,
        saveSetting = function(_self, k, v) store[k] = v end,
    }
end

-- Names that must never appear (dictators, mass murderers…), and words
-- that have no place in a family game.
local BANNED = {
    "HITLER", "STALIN", "STALINE", "MUSSOLINI", "NAPOLEON", "LENIN", "LENINE",
    "MAO", "POL POT", "PETAIN", "ROBESPIERRE", "FRANCO", "CON", "CONS", "MERDE",
    "PUTAIN", "SALOPE", "SHIT", "FUCK", "DAMN", "BITCH",
}

describe("cryptogram phrases", function()
    local Board

    setup(function()
        Board = require("board")
    end)

    for _, lang in ipairs({ "fr", "en" }) do
        describe(lang, function()
            it("holds at least 500 distinct, well-formed phrases", function()
                local list = Board.phrases(lang)
                assert.is_true(#list >= 500, lang .. " has only " .. #list)
                local seen = {}
                for i, e in ipairs(list) do
                    local text, source = e[1], e[2]
                    local where = lang .. " #" .. i .. " " .. tostring(text)
                    assert.is_string(text, where)
                    assert.is_string(source, where .. " has no source")
                    assert.is_true(#source > 0, where .. " has an empty source")
                    assert.is_nil(text:find("[^A-Z' %-]"), where .. " has a stray character")
                    assert.is_nil(text:find("  "), where .. " has a double space")
                    assert.is_true(#text >= 12 and #text <= 64, where .. " is " .. #text .. " long")
                    for word in text:gmatch("[^ ]+") do
                        assert.is_true(#word <= 16, where .. ": " .. word .. " is too long a word")
                    end
                    assert.is_nil(seen[text], where .. " is listed twice")
                    seen[text] = true
                end
            end)

            it("names nobody and nothing out of place", function()
                for _, e in ipairs(Board.phrases(lang)) do
                    local hay = " " .. e[1] .. " " .. e[2]:upper() .. " "
                    hay = hay:gsub("[^A-Z]", " ")
                    for _, bad in ipairs(BANNED) do
                        assert.is_nil(hay:find(" " .. bad .. " ", 1, true), e[1] .. " / " .. e[2] .. ": " .. bad)
                    end
                end
            end)
        end)
    end

    it("draws every phrase once before any repeat, across two sessions", function()
        local store = {}
        local n = #Board.phrases("fr")
        local seen = {}
        local b1 = Board:new{ lang = "fr", plugin = fakePlugin(store), defer = true }
        for _ = 1, 100 do
            b1:newGame()
            assert.is_nil(seen[b1.phrase], b1.phrase .. " came back in session 1")
            seen[b1.phrase] = true
        end
        -- a new session (new board, new plugin object, same settings)
        local b2 = Board:new{ lang = "fr", plugin = fakePlugin(store), defer = true }
        for _ = 101, n do
            b2:newGame()
            assert.is_nil(seen[b2.phrase], b2.phrase .. " came back in session 2")
            seen[b2.phrase] = true
        end
        -- list used up: the next game starts a new cycle
        b2:newGame()
        assert.is_string(b2.phrase)
    end)

    it("keeps one history per language", function()
        local store = {}
        local b = Board:new{ lang = "en", plugin = fakePlugin(store) }
        b.lang = "fr"
        b:newGame()
        assert.are.equal(1, #store.seen_phrases_en)
        assert.are.equal(1, #store.seen_phrases_fr)
    end)

    it("does not draw (nor mark) a phrase when deferred", function()
        local store = {}
        Board:new{ lang = "en", plugin = fakePlugin(store), defer = true }
        assert.is_nil(store.seen_phrases_en)
    end)

    it("keeps the source with the game and restores it", function()
        local b = Board:new{ lang = "fr" }
        assert.is_string(b.source)
        local b2 = Board:new{ lang = "fr", defer = true }
        assert.is_true(b2:load(b:serialize()))
        assert.are.equal(b.source, b2.source)
    end)

    it("leaves apostrophes and hyphens unciphered", function()
        local b = Board:new{ lang = "fr", defer = true }
        b.newGame = Board.newGame
        b._pickEntry = function() return { "AUJOURD'HUI VAS-Y", "test" } end
        b:newGame()
        assert.are.equal("'", b.ciphered:sub(8, 8))
        assert.are.equal("-", b.ciphered:sub(16, 16))
        for c, p in pairs(b.decipher_map) do b.user_map[c] = p end
        assert.is_true(b:isComplete())
    end)
end)
