# Changelog

All notable changes to this project will be documented in this file.

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
