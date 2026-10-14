# Third-party notices

This plasmoid (original QML code) is licensed under **GPL-3.0-or-later**: the GNU
General Public License, version 3 or (at your option) any later version
(see `LICENSE`). Copyright (C) 2026 Carlos Corral.
The multimedia assets have their own licenses, documented here to make it clear
what can and cannot be done with each one.

## Source / Font: DSEG7-Classic

- **Included files:**
  - `contents/assets/DSEG7Classic-Regular.ttf`
  - `contents/assets/DSEG7Classic-Bold.ttf`
  - `contents/assets/DSEG7Classic-Italic.ttf`
  - `contents/assets/DSEG7Classic-BoldItalic.ttf`
- **Author:** Keshikan (https://www.keshikan.net)
- **License:** SIL Open Font License 1.1 (OFL-1.1) — free for personal and
  commercial use, can be modified and redistributed.
- **Official origin:** https://github.com/keshikan/DSEG
- **Why it was changed:** the original font included in previous versions of
  this package ("digital-7 (mono).ttf" by Sizenko Alexander / Style-7) is
  *freeware for personal use only* ("Freeware for personal use. For commercial
  use please contact us."), a license incompatible with the public redistribution
  of this plasmoid under the GPL. It was replaced by DSEG7-Classic, which
  mimics the same 7-segment LCD display style, is monospaced, and is
  completely free.
- **Font style option:** the four bundled variants (Regular, Bold, Italic,
  Bold Italic) are selectable from the widget's configuration
  (Settings → Appearance → "Font style"). The clock updates live as soon as
  the configuration dialog is applied, with no need to re-add the widget.
- **Technical note:** all four files share the exact same font family name
  ("DSEG7 Classic") in their internal name table; only their style/weight
  metadata differs. Because of this, the QML selects the variant via
  `font.bold` / `font.italic`, not by switching `font.family`.

If at any point the DSEG font files are redistributed as-is
(not just embedded/used by the program), they must be accompanied by Keshikan's
copyright notice or the text of the OFL-1.1 license, according to point 1.10
of the OFL-FAQ (this is not necessary if the fonts are only used embedded in the app,
which is the case here).

## Font: DotMatrix

- **Included files:**
  - `contents/assets/DotMatrix-Regular.ttf`
  - `contents/assets/DotMatrix-Bold.ttf`
  - `contents/assets/DotMatrix-Italic.ttf`
  - `contents/assets/DotMatrix-BoldItalic.ttf`
- **Author:** Stefan Schmidt
- **Copyright:** 2025 The DotMatrix Project Authors
  (https://github.com/Gissio/font_DotMatrix)
- **License:** SIL Open Font License 1.1 (OFL-1.1) — free for personal and
  commercial use, can be modified and redistributed.
- **Official origin:** https://github.com/Gissio/font_DotMatrix
- **Font family option:** starting with this version, the widget offers a
  choice between the original DSEG7 (7-segment LCD) look and DotMatrix
  (dot-matrix printer style), selectable from the widget's configuration
  (Settings → Appearance → "Font family"). The four style variants (Regular,
  Bold, Italic, Bold Italic) apply to whichever family is selected.
- **Technical note:** same as DSEG7-Classic above, all four DotMatrix files
  share the same internal font family name ("DotMatrix"); the QML selects
  the variant via `font.bold` / `font.italic`, not by switching `font.family`.

If at any point the DotMatrix font files are redistributed as-is
(not just embedded/used by the program), they must be accompanied by the
DotMatrix Project Authors' copyright notice or the text of the OFL-1.1
license, according to point 1.10 of the OFL-FAQ (this is not necessary if
the fonts are only used embedded in the app, which is the case here).

## Icon: contents/icons/icon.svg

- **Title:** "Digital Clock"
- **Author:** manio1
- **Origin:** Openclipart (https://openclipart.org/detail/19412/digital-clock-by-manio1-19412),
  mirrored on freesvg.org (https://freesvg.org/digital-clock-display-vector-image10845)
- **License:** Creative Commons 0 (CC0) — Public Domain, no restrictions on use,
  modification, or redistribution. Attribution is not legally required but is
  given here as a courtesy.
- **Modifications:** none, used as-is as the widget's icon for the Add Widgets
  list (`metadata.json` → `Icon: "/icons/icon.svg"`).

## Sound: alarm.ogg

- **Origin:** "alarm clock buzzer alarm beep" by Garuda1982, downloaded from Freesound.org (https://freesound.org/s/530172/).
- **License:** Creative Commons 0 (CC0) — Public Domain, no restrictions on use, modification, or redistribution.
- **Modifications:** edited by the plasmoid author so that the playback loop
  is stable and without audible skips or clicks.
