local PHRASES_EN = {
    "THE QUICK BROWN FOX",
    "TO BE OR NOT TO BE",
    "ALL THAT GLITTERS IS NOT GOLD",
    "ACTIONS SPEAK LOUDER THAN WORDS",
    "BETTER LATE THAN NEVER",
    "EVERY CLOUD HAS A SILVER LINING",
    "PRACTICE MAKES PERFECT",
    "TIME FLIES WHEN YOU HAVE FUN",
    "YOU ONLY LIVE ONCE",
    "KNOWLEDGE IS POWER",
    "LOOK BEFORE YOU LEAP",
    "BIRDS OF A FEATHER FLOCK TOGETHER",
    "A PENNY SAVED IS A PENNY EARNED",
    "THE EARLY BIRD CATCHES THE WORM",
    "HONESTY IS THE BEST POLICY",
    "LAUGHTER IS THE BEST MEDICINE",
    "FORTUNE FAVORS THE BRAVE",
    "WHERE THERE IS WILL THERE IS WAY",
    "ABSENCE MAKES THE HEART GROW FONDER",
    "UNITED WE STAND DIVIDED WE FALL",
    "ROME WAS NOT BUILT IN A DAY",
    "WHEN IN ROME DO AS THE ROMANS DO",
    "THE GRASS IS ALWAYS GREENER ON THE OTHER SIDE",
    "A WATCHED POT NEVER BOILS",
    "TOO MANY COOKS SPOIL THE BROTH",
    "THE PEN IS MIGHTIER THAN THE SWORD",
    "WHEN THE GOING GETS TOUGH THE TOUGH GET GOING",
    "A PICTURE IS WORTH A THOUSAND WORDS",
    "BEGGARS CANNOT BE CHOOSERS",
    "CURIOSITY KILLED THE CAT",
    "EASY COME EASY GO",
    "DO NOT COUNT YOUR CHICKENS BEFORE THEY HATCH",
    "DO NOT JUDGE A BOOK BY ITS COVER",
    "DO NOT PUT ALL YOUR EGGS IN ONE BASKET",
    "DO NOT BITE THE HAND THAT FEEDS YOU",
    "DO NOT CRY OVER SPILLED MILK",
    "IF IT IS NOT BROKEN DO NOT FIX IT",
    "NO PAIN NO GAIN",
    "NO NEWS IS GOOD NEWS",
    "NOTHING VENTURED NOTHING GAINED",
    "ONCE BITTEN TWICE SHY",
    "OUT OF SIGHT OUT OF MIND",
    "PATIENCE IS A VIRTUE",
    "THE APPLE DOES NOT FALL FAR FROM THE TREE",
    "THE EXCEPTION PROVES THE RULE",
    "TWO WRONGS DO NOT MAKE A RIGHT",
    "WHAT GOES AROUND COMES AROUND",
    "WHEN LIFE GIVES YOU LEMONS MAKE LEMONADE",
    "YOU CANNOT HAVE YOUR CAKE AND EAT IT TOO",
    "ACTIONS HAVE CONSEQUENCES",
    "AN APPLE A DAY KEEPS THE DOCTOR AWAY",
    "BETTER SAFE THAN SORRY",
    "BLOOD IS THICKER THAN WATER",
    "DO NOT PUT THE CART BEFORE THE HORSE",
    "EVERY DOG HAS ITS DAY",
    "FAMILIARITY BREEDS CONTEMPT",
    "FIRST COME FIRST SERVED",
    "FORGIVE AND FORGET",
    "GOOD THINGS COME TO THOSE WHO WAIT",
    "GREAT MINDS THINK ALIKE",
    "HOME IS WHERE THE HEART IS",
    "IGNORANCE IS BLISS",
    "IMITATION IS THE SINCEREST FORM OF FLATTERY",
    "IT NEVER RAINS BUT IT POURS",
    "IT TAKES TWO TO TANGO",
    "LET SLEEPING DOGS LIE",
    "LIGHTNING NEVER STRIKES TWICE",
    "MONEY CANNOT BUY HAPPINESS",
    "MONEY DOES NOT GROW ON TREES",
    "NECESSITY IS THE MOTHER OF INVENTION",
    "NEVER LOOK A GIFT HORSE IN THE MOUTH",
    "TRASH TO ONE IS TREASURE TO ANOTHER",
    "SILENCE IS GOLDEN",
    "SLOW AND STEADY WINS THE RACE",
    "STRIKE WHILE THE IRON IS HOT",
    "THE BEST THINGS IN LIFE ARE FREE",
    "THE SQUEAKY WHEEL GETS THE GREASE",
    "THERE IS NO PLACE LIKE HOME",
    "THERE IS NO SUCH THING AS A FREE LUNCH",
    "THINK BEFORE YOU SPEAK",
    "VARIETY IS THE SPICE OF LIFE",
    "WHEN ONE DOOR CLOSES ANOTHER OPENS",
    "WHERE THERE IS SMOKE THERE IS FIRE",
    "YOU CANNOT TEACH AN OLD DOG NEW TRICKS",
    "YOU REAP WHAT YOU SOW",
    "ALL IS FAIR IN LOVE AND WAR",
    "ALL GOOD THINGS MUST COME TO AN END",
    "BEAUTY IS IN THE EYE OF THE BEHOLDER",
    "BETTER THE DEVIL YOU KNOW",
    "BREVITY IS THE SOUL OF WIT",
    "CHARITY BEGINS AT HOME",
    "CLEANLINESS IS NEXT TO GODLINESS",
    "DESPERATE TIMES CALL FOR DESPERATE MEASURES",
    "FOOLS RUSH IN WHERE ANGELS FEAR TO TREAD",
    "GOOD FENCES MAKE GOOD NEIGHBORS",
    "HASTE MAKES WASTE",
    "HISTORY REPEATS ITSELF",
    "HOPE FOR THE BEST PREPARE FOR THE WORST",
    "IF THE SHOE FITS WEAR IT",
    "LIKE FATHER LIKE SON",
    "LOVE IS BLIND",
    "MAKE HAY WHILE THE SUN SHINES",
    "MISERY LOVES COMPANY",
    "NEVER SAY NEVER",
    "OLD HABITS DIE HARD",
    "ONE GOOD TURN DESERVES ANOTHER",
    "WHAT IS MEAT TO ONE IS POISON TO ANOTHER",
    "OUT OF THE FRYING PAN INTO THE FIRE",
    "PRIDE COMES BEFORE A FALL",
    "SEEING IS BELIEVING",
    "SPARE THE ROD AND SPOIL THE CHILD",
    "THE BIGGER THEY ARE THE HARDER THEY FALL",
    "THE PROOF IS IN THE PUDDING",
    "THE ROAD TO HELL IS PAVED WITH GOOD INTENTIONS",
    "THE TRUTH WILL SET YOU FREE",
    "TIME HEALS ALL WOUNDS",
    "TIME IS MONEY",
    "TO ERR IS HUMAN TO FORGIVE DIVINE",
    "WHEN IT RAINS IT POURS",
    "A CHAIN IS ONLY AS STRONG AS ITS WEAKEST LINK",
    "A FRIEND IN NEED IS A FRIEND INDEED",
    "A LEOPARD CANNOT CHANGE ITS SPOTS",
    "A ROLLING STONE GATHERS NO MOSS",
    "ACTIONS SPEAK LOUDER THAN PROMISES",
    "ALL ROADS LEAD TO ROME",
    "BETTER LATE THAN NOT AT ALL",
    "DO NOT LOOK A GIFT HORSE IN THE MOUTH",
    "EVERY CLOUD EVENTUALLY PASSES",
    "GOOD ADVICE IS BEYOND PRICE",
    "IF THE CAP FITS WEAR IT",
    "IT IS BETTER TO GIVE THAN TO RECEIVE",
    "LAUGH AND THE WORLD LAUGHS WITH YOU",
    "LITTLE STROKES FELL GREAT OAKS",
    "MANY HANDS MAKE LIGHT WORK",
    "ONE SWALLOW DOES NOT MAKE A SUMMER",
    "OUT OF THE MOUTHS OF BABES",
    "PRACTICE WHAT YOU PREACH",
    "STILL WATERS RUN DEEP",
    "THE BEST DEFENSE IS A GOOD OFFENSE",
    "THE CUSTOMER IS ALWAYS RIGHT",
    "THE FIRST STEP IS ALWAYS THE HARDEST",
    "THE GRASS IS NOT ALWAYS GREENER",
    "YOU CANNOT PLEASE EVERYONE",
}

local PHRASES_FR = {
    "LA VIE EST BELLE",
    "LE TEMPS C EST DE L ARGENT",
    "MIEUX VAUT TARD QUE JAMAIS",
    "LA PATIENCE EST UNE VERTU",
    "L UNION FAIT LA FORCE",
    "VOULOIR C EST POUVOIR",
    "CHAQUE CHOSE EN SON TEMPS",
    "LE MIEUX EST L ENNEMI DU BIEN",
    "LA VERITE SORTIRA TOUJOURS",
    "AIDE TOI ET LE CIEL T AIDERA",
    "LES PAROLES S ENVOLENT LES ECRITS RESTENT",
    "RIEN NE SERT DE COURIR IL FAUT PARTIR A POINT",
    "A COEUR VAILLANT RIEN D IMPOSSIBLE",
    "QUI SEME LE VENT RECOLTE LA TEMPETE",
    "TOUT VIENT A POINT A QUI SAIT ATTENDRE",
    "LA NUIT PORTE CONSEIL",
    "IL N Y A PAS DE FUMEE SANS FEU",
    "PIERRE QUI ROULE N AMASSE PAS MOUSSE",
    "LES EXTREMES SE TOUCHENT",
    "LA FIN JUSTIFIE LES MOYENS",
    "QUI VOLE UN OEUF VOLE UN BOEUF",
    "IL FAUT BATTRE LE FER PENDANT QU IL EST CHAUD",
    "LES BONS COMPTES FONT LES BONS AMIS",
    "CHACUN VOIT MIDI A SA PORTE",
    "APRES LA PLUIE LE BEAU TEMPS",
    "QUI NE RISQUE RIEN N A RIEN",
    "LOIN DES YEUX LOIN DU COEUR",
    "PETIT A PETIT L OISEAU FAIT SON NID",
    "IL NE FAUT JAMAIS DIRE JAMAIS",
    "QUI VIVRA VERRA",
    "TOUT EST BIEN QUI FINIT BIEN",
    "IMPOSSIBLE N EST PAS FRANCAIS",
    "CHASSEZ LE NATUREL IL REVIENT AU GALOP",
    "LES CHIENS NE FONT PAS DES CHATS",
    "QUI TROP EMBRASSE MAL ETREINT",
    "UN TIENS VAUT MIEUX QUE DEUX TU L AURAS",
    "IL VAUT MIEUX PREVENIR QUE GUERIR",
    "L HABIT NE FAIT PAS LE MOINE",
    "LE JEU N EN VAUT PAS LA CHANDELLE",
    "QUAND LE CHAT N EST PAS LA LES SOURIS DANSENT",
    "LES MURS ONT DES OREILLES",
    "A BON ENTENDEUR SALUT",
    "AUTRES TEMPS AUTRES MOEURS",
    "CHAT ECHAUDE CRAINT L EAU FROIDE",
    "IL N Y A PAS DE ROSE SANS EPINES",
    "LES GRANDS ESPRITS SE RENCONTRENT",
    "QUI DORT DINE",
    "LA RAISON DU PLUS FORT EST TOUJOURS LA MEILLEURE",
    "TEL EST PRIS QUI CROYAIT PRENDRE",
    "IL FAUT SAVOIR RAISON GARDER",
    "LE TEMPS PERDU NE SE RATTRAPE JAMAIS",
    "DIS MOI QUI TU FREQUENTES JE TE DIRAI QUI TU ES",
    "IL N EST JAMAIS TROP TARD POUR BIEN FAIRE",
    "QUI CHERCHE TROUVE",
    "LES BONNES INTENTIONS NE SUFFISENT PAS",
    "CE QUI NE TUE PAS REND PLUS FORT",
    "QUI NE TENTE RIEN N A RIEN",
    "CHOSE PROMISE CHOSE DUE",
    "IL FAUT CULTIVER SON JARDIN",
    "LES APPARENCES SONT SOUVENT TROMPEUSES",
    "UNE HIRONDELLE NE FAIT PAS LE PRINTEMPS",
    "LE RIDICULE NE TUE PAS",
    "QUI S Y FROTTE S Y PIQUE",
    "CHARBONNIER EST MAITRE CHEZ LUI",
    "LES CONSEILLEURS NE SONT PAS LES PAYEURS",
    "LA NUIT TOUS LES CHATS SONT GRIS",
    "IL VAUT MIEUX ETRE SEUL QUE MAL ACCOMPAGNE",
    "TOUT NOUVEAU TOUT BEAU",
    "QUI PAIE SES DETTES S ENRICHIT",
    "LES OCCASIONS FONT LES LARRONS",
    "A CHEVAL DONNE ON NE REGARDE PAS LES DENTS",
    "IL N Y A QUE LA VERITE QUI BLESSE",
    "QUI AIME BIEN CHATIE BIEN",
    "LA CONFIANCE N EXCLUT PAS LE CONTROLE",
    "LES PETITS RUISSEAUX FONT LES GRANDES RIVIERES",
    "IL FAUT PRENDRE LE TEMPS COMME IL VIENT",
    "UNE MAUVAISE NOUVELLE VA PLUS VITE QU UNE BONNE",
    "QUI VEUT VOYAGER LOIN MENAGE SA MONTURE",
    "IL N Y A PAS DE FUMEE SANS UN PEU DE FEU",
    "L ARGENT NE FAIT PAS LE BONHEUR",
    "LA BEAUTE EST DANS L OEIL DE CELUI QUI REGARDE",
    "IL FAUT LAVER SON LINGE SALE EN FAMILLE",
    "LES GOUTS ET LES COULEURS NE SE DISCUTENT PAS",
    "QUI VA A LA CHASSE PERD SA PLACE",
    "UN MALHEUR NE VIENT JAMAIS SEUL",
    "TOUT LASSE TOUT CASSE TOUT PASSE",
    "LES JOURS SE SUIVENT ET NE SE RESSEMBLENT PAS",
    "QUI TERRE A GUERRE A",
    "IL NE FAUT JURER DE RIEN",
    "LES BEAUX JOURS ONT UNE FIN",
    "CHACUN POUR SOI ET DIEU POUR TOUS",
    "IL FAUT SOUFFRIR POUR ETRE BELLE",
    "QUI NE DIT MOT CONSENT",
    "L EXCEPTION CONFIRME LA REGLE",
    "QUI RIT VENDREDI DIMANCHE PLEURERA",
    "CE QUI EST FAIT N EST PLUS A FAIRE",
    "IL FAUT DEUX POUR DANSER LE TANGO",
    "LA PAROLE EST D ARGENT LE SILENCE EST D OR",
    "QUI VEUT LA FIN VEUT LES MOYENS",
    "LES BONS CUISINIERS NE JETTENT RIEN",
    "UN HOMME AVERTI EN VAUT DEUX",
    "IL FAUT SE MEFIER DE L EAU QUI DORT",
    "LA CURIOSITE EST UN VILAIN DEFAUT",
    "QUI CASSE LES VERRES LES PAIE",
    "LE MONDE APPARTIENT A CEUX QUI SE LEVENT TOT",
    "IL N Y A PAS DE SOT METIER",
    "LES ARBRES CACHENT SOUVENT LA FORET",
    "IL FAUT TOUJOURS GARDER UNE POIRE POUR LA SOIF",
    "QUI SEME LE DOUTE RECOLTE LA MEFIANCE",
    "LA FORTUNE SOURIT AUX AUDACIEUX",
    "IL VAUT MIEUX FAIRE ENVIE QUE PITIE",
    "LES DERNIERS SERONT LES PREMIERS",
    "QUI PEUT LE PLUS PEUT LE MOINS",
    "CE QUI VIENT DE LA FLUTE S EN VA PAR LE TAMBOUR",
    "APRES LA PLUIE VIENT LE BEAU TEMPS",
    "DEUX PRECAUTIONS VALENT MIEUX QU UNE",
    "IL FAUT QUE JEUNESSE SE PASSE",
    "QUI NE RISQUE PAS N A PAS",
    "IL VAUT MIEUX PLIER QUE ROMPRE",
    "LA MONTAGNE A ACCOUCHE D UNE SOURIS",
    "LES PETITES CAUSES FONT LES GRANDS EFFETS",
    "QUI MAL Y PENSE",
    "IL FAUT DONNER DU TEMPS AU TEMPS",
    "LA NUIT LA PLUS LONGUE FINIT PAR S ACHEVER",
    "LES SOTTISES NE SONT JAMAIS OUBLIEES",
    "QUI N AVANCE PAS RECULE",
    "IL N Y A PAS DE PLAISIR SANS PEINE",
    "LA MEMOIRE EST LA FIDELE GARDIENNE DES OFFENSES",
    "QUI TOUT CONVOITE TOUT PERD",
    "IL FAUT PRENDRE GARDE A CE QUE L ON SOUHAITE",
    "LA FAIM CHASSE LE LOUP HORS DU BOIS",
    "LES OISEAUX DE MEME PLUMAGE S ASSEMBLENT",
    "QUI EMBRASSE TROP MAL ETREINT",
}

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
        phrase          = "",
        ciphered        = "",
        cipher_map      = {},
        decipher_map    = {},
        user_map        = {},
        selected_cipher = nil,
        wins            = opts.wins or 0,
    }, self)
    obj:newGame()
    return obj
end

function CryptogramBoard:_phraseList()
    return self.lang == "fr" and PHRASES_FR or PHRASES_EN
end

function CryptogramBoard:newGame()
    local list   = self:_phraseList()
    local phrase = list[math.random(#list)]
    self.phrase  = phrase

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

return CryptogramBoard
