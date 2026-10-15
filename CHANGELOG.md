# Changelog

## [1.9.0] - 2026-10-15

### Added
- **Date popup on hover** (off by default): a small popup styled to match the active theme that shows the full date, in your system language, when you rest the mouse over the clock. It appears after a short delay so it does not flash while the pointer passes by, never takes mouse or keyboard focus, and stays hidden while the alarm is ringing. Enable it in the Effects page, under Mouse, with "Show date popup on hover".
  - Added the `hoverDate` configuration property (bool, default `false`) in `main.xml`.

## [1.8.1] - 2026-10-15

### Fixed
- Seconds could appear out of sync with the default KDE digital clock and other system clocks. The display now refreshes from Plasma's own time data source, the same one the default clock reads, instead of a free-running timer whose phase depended on when the widget was loaded. If that module is not available, it falls back to a timer that re-aligns itself to the start of every second.

## [1.8.0] - 2026-10-14

### Fixed
- Configuration dialog: the clock style, font family, font style and alarm AM/PM selectors saved their value immediately, so Cancel no longer reverted them. They now follow the standard `cfg_*` binding like the rest of the options and are committed with Apply. The preview box in the Appearance page still updates instantly.
- Alarm time: the hour spin box range (0-23 or 1-12) now follows the "24-hour format" checkbox right away instead of waiting for Apply.
- Alarm time: switching between 24-hour and 12-hour format now converts the saved alarm (for example 15:00 becomes 3 PM) instead of reinterpreting the same numbers, which could silently move the alarm to a different time or keep it from ringing.
- The alarm dialog is now anchored to the widget. Its `visualParent` referenced an id that was not reachable from that scope, so it was never set.
- `AlarmDot` no longer redefines the built-in `enabled` property of `Item`.

### Changed
- Alarm dialog moved to its own component. Its Stop and Snooze buttons are now real buttons, so they can be focused and activated with the keyboard, and the hover highlight also works on black themes. Sizes use Kirigami units instead of fixed pixels.
- Configuration pages use Kirigami units for spacing and control sizes.
- `main.qml` reduced from 944 to about 670 lines: the colon separator (previously repeated six times) is now `ColonSeparator.qml`, and the eight font loaders shared by the clock and the preview are now `ClockFonts.qml`.
- `main.qml` reads settings directly from `Plasmoid.configuration`. The per-setting fallbacks for missing values were removed, since `main.xml` already defines every default.

### Documentation
- README lists the Qt 6 Multimedia QML module as a requirement.

## [1.7.1] - 2026-10-14

### Fixed
- License metadata: `KPlugin.License` in `metadata.json` now uses the valid SPDX identifier `GPL-3.0-or-later` instead of the deprecated `GPL-3.0`, which tools such as Discover did not recognize (shown as "Unknown").
- `LICENSE` now contains the complete, unmodified text of the GNU GPL version 3 instead of the abbreviated notice, so license detectors (GitLab, REUSE, distribution tooling) can identify it.

### Changed
- The license grant is now stated explicitly as "version 3 or (at your option) any later version", via SPDX headers (`SPDX-License-Identifier: GPL-3.0-or-later`) in every source file.
- `README.md` and `NOTICE.md` updated to match; the README third-party list now also credits DotMatrix and the icon.
- CI validation now fails on invalid `metadata.json` or a missing/non-SPDX `License` value instead of only printing a warning.

## [1.7.0] - 2026-08-22

### Added
- **DotMatrix font family**: a new dot-matrix printer-style typeface, selectable independently from the existing 4 style variants (Regular, Bold, Italic, Bold Italic), which now apply to whichever family is active. Licensed under SIL OFL 1.1, attribution in `NOTICE.md`.
- **Reset to defaults** button on the Appearance page, restoring all settings to their original values in one click.
- The configuration panel is now split into three pages — **Appearance**, **Effects**, and **Clock and Alarm** — instead of a single long scrolling list.

### Fixed
- DotMatrix's font metrics reserve descender space our glyphs never use, which was pushing the display visually toward the top of its box; added a measured per-font vertical correction (based on the font's actual ascent/descent values) across every text element, horizontal and vertical panels alike.
- The colon separator looked oversized and off-center, especially with Condensed layout enabled. Reduced its size and corrected its horizontal centering, now scaling correctly with the condensed layout factor.

## [1.6.0] - 2026-08-19

### Added
- **Alarm snooze**: right-click the widget while the alarm is ringing for a "Snooze alarm" action, with a configurable duration (1-30 minutes, default 5). A floating dialog styled to match the active clock theme also pops up automatically when the alarm rings, offering Stop and Snooze buttons directly.
- **Startup lamp test** (off by default): a brief all-segments flash when the widget loads, mimicking the self-test on real digital clocks and microwaves.

### Changed
- The alarm dot is now roughly a quarter of its previous size.
- With Ghost segments enabled, the alarm dot's ghost now stays visible regardless of whether the alarm itself is enabled, so toggling the alarm on and off no longer resizes the display.

### Fixed
- Ghost segments and the startup lamp test no longer visually overlap with the real digits at near-full brightness; the real content now smoothly fades out while the ghost/test glyph fades in, instead of both being drawn on top of each other.

## [1.5.0] - 2026-08-17

### Added
- Two new color themes: **VFD Teal** and **Nixie Orange**, joining the existing 6 presets.
- **Ghost segments** (off by default): an optional dim "always-on" silhouette behind every digit, separator, AM/PM letter and date character, and the alarm dot, evoking the permanently-etched look of a real unlit LCD/VFD panel. The alarm dot's ghost only appears while the alarm is actually enabled, so the display stays perfectly symmetric otherwise.
- **CRT scanlines** (off by default): a subtle horizontal scanline overlay across the clock face for an old-school CRT/VFD screen feel. Rendered once per resize via `Canvas`, not per frame, so it has no ongoing performance cost.
- **Flicker on minute change** (off by default): a brief, one-shot flicker each time the displayed minute rolls over, independent of the existing continuous flicker effect and combinable with it.

## [1.4.2] - 2026-08-17

### Fixed
- Configuration dialog: the Appearance page now uses the KCM root component (`KCM.SimpleKCM`) required by Plasma 6 instead of the Plasma 5-era `ScrollView` + `FormLayout` pattern.
- Configuration dialog: checkboxes, the font scale slider and the alarm time spin boxes were writing directly to `plasmoid.configuration` on every interaction, bypassing the dialog's Apply/Discard/Cancel behavior. They now rely solely on the standard `cfg_*` binding, so Cancel correctly reverts unsaved changes again.
- Configuration dialog: the AM/PM alarm selector always opened showing "AM" regardless of the saved value. It now correctly reflects the stored setting.
- Removed three non-functional `cfg_*` aliases bound to a read-only `ComboBox.currentText` (clock style, font style, alarm AM/PM); these settings already worked correctly through their existing manual `currentIndex`/`onCurrentTextChanged` wiring.

### Changed
- `main.qml` and `contents/config/config.qml`: dropped versioned QML module imports (`QtQuick 2.12`, `QtQuick.Layouts 1.15`, `org.kde.plasma.configuration 2.0`) per the Plasma 6 porting guidelines.
- `main.qml`: extracted the repeated "text/shape + drop shadow" pattern into two reusable components, `ShadowedText.qml` and `AlarmDot.qml`, removing 7 duplicated blocks and shrinking `main.qml` from 718 to ~600 lines with no visual or behavioral change.
- `main.qml`: centralized previously inline/repeated size ratios (container radius and border width, planar-mode minimum size, vertical-panel character box width, colon-dot size and spacing) into named `readonly` properties.
- Removed the obsolete `metadata.desktop` file; Plasma 6 only reads `metadata.json`, and the leftover file had stale, inconsistent data (wrong icon, dead `X-Plasma-MainScript` key).

## [1.4.1] - 2026-08-16

### Fixed
- Packaging: the archive uploaded to the KDE Store had `metadata.json` still reporting version `1.4.0` instead of `1.4.1`. Re-packaged from the actual running 1.4.1 build to fix the mismatch. No QML/code changes.

## [1.4.0] - 2026-07-26

### Added
- New **Font scale** slider (0.5x–2.0x) in the Appearance tab, letting you fine-tune the overall digit size independently of the panel or widget size. Helps prevent digits from overlapping on unusual setups.
  - Added the `fontScale` configuration property (Double, default `1.0`) in `main.xml`.

### Fixed
- Vertical panel: the clock now scales correctly when you adjust the font size. The date now displays vertically (stacked, one character below another) when enabled, and the time separators render as proper stacked colons instead of a single dot.
- Floating widget (desktop) mode: LCD digits now scale correctly with the font size setting when the clock is used as a desktop widget.
- Configuration window: added a scrollbar so every option is reachable without maximizing the window.
- Configuration window: checkboxes now correctly reflect the saved state on open and respond on the first click.

## [1.3.1] - 2026-07-26

### Fixed
- Vertical panels: the clock now stacks hours/minutes/seconds top to bottom instead of forcing the same wide horizontal layout into a narrow vertical strip.
- Desktop widget: resizing the widget by dragging its handles now properly scales the digits, spacing and padding to fit the box you chose, instead of overflowing past a shrunk frame.
- 12-hour AM/PM indicator and the date now also appear (stacked, smaller) in the vertical panel layout.

## [1.3.0] - 2026-07-25

### Fixed
- Fixed the clock rendering as an oversized square when placed on a horizontal panel. The widget now fits the panel's actual thickness, scaling its digits, spacing and padding to match, instead of always forcing a fixed 120px height meant for the desktop (Planar) representation. Placement on the desktop is unchanged.

### Added
- New **"Condensed layout"** option in the Appearance tab. Packs the digits closer together for a tighter, more compact readout, similar to the reference clock image on the store listing. Works with any font style (Regular, Bold, Italic, Bold Italic) and updates the live preview instantly.
  - Added the `layoutCondensed` configuration property (bool, default `false`) in `main.xml`.

## [1.2.1] - 2026-07-24

### Fixed
- The "Preview" box in the Appearance tab now renders "88:88" with the actual
  DSEG7-Classic font, matching the selected "Font style" (Regular, Bold,
  Italic, Bold Italic) and reflecting the "Show shadow" option, instead of a
  generic bold system font. No visual or behavioral change to the clock
  itself.

## [1.2.0] - 2026-07-20

### Added
- New **"Custom"** clock style. Pick any color for the digits, the `:` separators, the alarm dot and the border via a color picker in the Appearance tab. The background stays fixed (black), matching the other color themes, so contrast/legibility is preserved.
  - Added the `customColor` configuration property (string, hex color, default `#00ff00`) in `main.xml`.
  - Added a live preview ("88:88" mock display) in the Appearance tab, reflecting the currently selected style (preset or custom) so users can see the result before applying it.
  - Introduced `contents/code/colorUtils.js` as a single shared source of truth for style colors and hex conversion, used by both `main.qml` and `configAppearance.qml`.

### Changed
- Refactored the color theme lookup (`styleColors[cfg_clockStyle]`) into reactive `active*Color` properties driven by the shared color module, with no visual change for the 6 existing presets.

## [1.1.0] - 2026-07-10

### Added
- New **"Flicker effect"** option in the Appearance tab, disabled by default.
  - When enabled, the clock simulates the flicker of a vintage LCD/CRT screen by randomly varying its opacity.
  - Added the `flickerEffect` configuration property (boolean, default `false`) in `main.xml`.
  - Added the corresponding checkbox in `configAppearance.qml`.
  - Implemented a `Timer` in `main.qml` that, while the effect is active, changes the clock's opacity at random intervals (roughly 60-210 ms) to create the flicker; when disabled, opacity immediately returns to 1.0.

### Changed
- Bumped plasmoid version from 1.0.1 to 1.1.0 (`metadata.json` and `metadata.desktop`).
