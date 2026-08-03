local DIR = debug.getinfo(1, "S").source:sub(2):match("(.*[/\\])") or "./"
package.path = DIR .. "?.lua;" .. package.path

describe("CryptogramBoard", function()
    local Board

    setup(function()
        Board = require("board")
    end)

    describe("new / newGame", function()
        it("picks a phrase and enciphers it with a derangement (no letter maps to itself)", function()
            local b = Board:new()
            assert.is_true(#b.phrase > 0)
            for k, v in pairs(b.cipher_map) do
                assert.are_not.equal(k, v)
            end
        end)

        it("cipher_map and decipher_map are inverses", function()
            local b = Board:new()
            for plain, cipher in pairs(b.cipher_map) do
                assert.are.equal(plain, b.decipher_map[cipher])
            end
        end)

        it("ciphered text is the same length as the phrase, letters substituted", function()
            local b = Board:new()
            assert.are.equal(#b.phrase, #b.ciphered)
            for i = 1, #b.phrase do
                local pch, cch = b.phrase:sub(i, i), b.ciphered:sub(i, i)
                if pch >= "A" and pch <= "Z" then
                    assert.are.equal(b.cipher_map[pch], cch)
                else
                    assert.are.equal(pch, cch)
                end
            end
        end)
    end)

    describe("selectCipher / assignLetter", function()
        it("assigns a plain letter to the selected cipher letter", function()
            local b = Board:new()
            local cipher = b.ciphered:sub(1, 1)
            if cipher >= "A" and cipher <= "Z" then
                b:selectCipher(cipher)
                b:assignLetter("Q")
                assert.are.equal("Q", b.user_map[cipher])
            end
        end)

        it("re-assigning the same letter clears it (toggle off)", function()
            local b = Board:new()
            local cipher = b.ciphered:sub(1, 1)
            if cipher >= "A" and cipher <= "Z" then
                b:selectCipher(cipher)
                b:assignLetter("Q")
                b:assignLetter("Q")
                assert.is_nil(b.user_map[cipher])
            end
        end)

        it("assigning a plain letter already used elsewhere moves it", function()
            local b = Board:new()
            b.user_map = {}
            b:selectCipher("X")
            b:assignLetter("Q")
            b:selectCipher("Y")
            b:assignLetter("Q")
            assert.is_nil(b.user_map["X"])
            assert.are.equal("Q", b.user_map["Y"])
        end)
    end)

    describe("isComplete / decodedCount", function()
        it("is complete once every cipher letter maps to its true plain letter", function()
            local b = Board:new()
            b.user_map = {}
            for cipher, plain in pairs(b.decipher_map) do
                b.user_map[cipher] = plain
            end
            assert.is_true(b:isComplete())
        end)

        it("decodedCount reports 0 of N on a fresh game and N of N once solved", function()
            local b = Board:new()
            local decoded, total = b:decodedCount()
            assert.are.equal(0, decoded)
            assert.is_true(total > 0)

            for cipher, plain in pairs(b.decipher_map) do
                b.user_map[cipher] = plain
            end
            decoded, total = b:decodedCount()
            assert.are.equal(total, decoded)
        end)
    end)

    describe("clearAll", function()
        it("empties user_map and selection", function()
            local b = Board:new()
            b:selectCipher("X")
            b:assignLetter("Q")
            b:clearAll()
            assert.are.same({}, b.user_map)
            assert.is_nil(b.selected_cipher)
        end)
    end)

    describe("serialize / load", function()
        it("round-trips phrase, maps and progress", function()
            local b = Board:new()
            b:selectCipher(b.ciphered:sub(1, 1))
            b:assignLetter("Q")
            local data = b:serialize()

            local b2 = Board:new()
            assert.is_true(b2:load(data))
            assert.are.equal(b.phrase, b2.phrase)
            assert.are.equal(b.ciphered, b2.ciphered)
            for k, v in pairs(b.user_map) do
                assert.are.equal(v, b2.user_map[k])
            end
        end)

        it("load returns false for invalid data", function()
            local b = Board:new()
            assert.is_false(b:load(nil))
            assert.is_false(b:load({}))
        end)
    end)
end)
