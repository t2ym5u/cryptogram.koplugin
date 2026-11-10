# Changelog

## [1.5.0] - 2026-11-10

### Added
- Twice as many French phrases: 1,061 (was 534), mostly proverbs, sayings
  and expressions, plus titles of tales, fables and novels and famous
  lines. The game still deals every phrase once before any repeats.

All notable changes to this project will be documented in this file.

## [1.4.2] - 2026-11-09

### Fixed
- The game now starts in KOReader's language (French when KOReader is in
  French) instead of always English; a language picked in the game holds
  until KOReader's language changes.

## [1.4.1] - 2026-11-04

### Fixed
- A game no longer crashes when an outdated plugin is installed alongside:
  shared modules left behind by an older plugin are replaced by this
  plugin's own copy instead of being used as they are.

## [1.4.0] - 2026-11-04

### Changed
- Bigger keys in landscape: the keyboard panel beside the phrase is wider
  (45 % of the screen instead of 36 %), so each key is about a quarter
  wider; the phrase's letter cells are a little smaller. Portrait is
  unchanged.
- Needs game-common 1.13.0.
- Uses less memory: the game loads when you open it, not when KOReader
  starts, so it no longer takes memory or startup time while unplayed.
- Uses less memory: the phrases load when the game opens, only for the
  language played, and are freed when it closes.

## [1.3.0] - 2026-11-03

### Added
- Over 500 phrases per language (was ~140): proverbs, famous quotations,
  lines from films, book titles, songs and nursery rhymes — in French,
  Molière, La Fontaine, Hugo, Corneille, de Gaulle, Pagnol, Tintin,
  comptines…
- Once a phrase is solved, its source (author and work) is shown under it.
- Apostrophes and hyphens are shown as they are ("C'EST", "VAS-Y") instead
  of being turned into spaces.

### Changed
- A phrase does not come back until every other phrase of that language
  has been played, even across sessions (the history is kept per language).

## [1.2.2] - 2026-11-02

### Changed
- Picks up game-common 1.10.0: the shared Tools → Games menu also lists
  the games' new "· multiplayer" entries under Party & quiz.

## [1.2.1] - 2026-11-02

### Changed
- Listed under **Tools → Games**, grouped by category, instead of its own
  entry in the Tools menu (game-common 1.9.1).

## [1.2.0] - 2026-10-30

### Changed
- The phrase is word-wrapped: a word is never split across two lines, lines
  are centred, and the letter cells are the largest for which the whole phrase
  fits the room the controls leave.
- The on-screen keyboard follows KOReader's language (AZERTY in French, QWERTZ
  in German) instead of the phrase's language, and its keys are finger-sized.
- Tapping a letter's guess cell selects it too, not only the cipher cell above
  it.
- The status line reads "Decoded: 12/20"; the selected letter and its guess
  are already shaded on the board.
- Once the phrase is solved, the action bar shows "New game" in place of
  Clear.
- The language entry in the title-bar menu reads "Language: EN" instead of a
  bare "EN". The rules say that typing the same guess again erases it.

### Fixed
- Pressing a key on an already solved phrase counted another win.
- Letters were scaled by DPI twice and overflowed their cells on high-DPI
  screens; they are now fitted to them.

## [1.1.18] - 2026-10-07

### Fixed
- The Tools menu entry is translated again. `main.lua` took `_` from
  KOReader's `gettext`, which knows nothing of this plugin's strings, so the
  menu label stayed English while the game's own screen, which goes through
  `i18n`, was translated. `_` now comes from `i18n` here too.

## [1.1.17] - 2026-10-01

### Fixed
- Picks up game-common v1.5.0. Play statistics were recorded under a key no
  tool could match: `ReaderUI`/`FileManager:registerModule()` rewrite a plugin
  instance's `name` to `reader<id>` / `filemanager<id>` right after it is
  built, so this game's sessions were split across two rows and neither
  carried its plugin id. Rows written under the old keys are merged back on
  first read. The same release brings the `stopPlugin()` /
  `deletePluginSettings()` hooks KOReader 2026.07 calls when a plugin is
  deleted from the device (PR #15240).

  No change to this plugin's own code -- it inherits all of it from the
  shared library.

## [1.1.10] - 2026-07-29

### Added
- A large batch of new English and French phrases/proverbs to the
  built-in phrase banks (`PHRASES_EN` and `PHRASES_FR` in board.lua),
  including common idioms such as "Rome was not built in a day" and
  their French counterparts such as "qui vole un oeuf vole un boeuf".
  Reduces phrase repetition for frequent players in both languages; no
  existing phrase or generation logic was changed.
