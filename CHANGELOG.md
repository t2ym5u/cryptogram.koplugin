# Changelog

All notable changes to this project will be documented in this file.

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
