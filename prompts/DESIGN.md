---
name: Prompt Library (Building from Zero)
description: An engineering lab notebook on eye-ease green stock, bound in bottle-green cloth, with one red stamp for the failures.
colors:
  stock: "#E6EEE3"
  stock-deep: "#DCE6D8"
  field: "#F1F5EE"
  label: "#F3F6EF"
  ink: "#141A16"
  ink-2: "#44544A"
  ink-3: "#566559"
  rule: "rgba(31,61,43,.42)"
  rule-soft: "rgba(31,61,43,.18)"
  grid: "rgba(31,61,43,.13)"
  grid-dark: "rgba(230,238,227,.09)"
  cloth: "#1F3D2B"
  cloth-deep: "#16301F"
  cloth-ink: "#E6EEE3"
  cloth-ink-2: "#B9CDB9"
  stamp: "#B3261E"
typography:
  display:
    fontFamily: "Barlow Semi Condensed, Barlow, system-ui, sans-serif"
    fontSize: "clamp(2.6rem, 7vw, 4.6rem)"
    fontWeight: 700
    lineHeight: 0.95
    letterSpacing: "-0.01em"
  headline:
    fontFamily: "Barlow Semi Condensed, Barlow, system-ui, sans-serif"
    fontSize: "clamp(1.7rem, 3.4vw, 2.3rem)"
    fontWeight: 700
    lineHeight: 1
    letterSpacing: "-0.005em"
  numeral:
    fontFamily: "Barlow Semi Condensed, Barlow, system-ui, sans-serif"
    fontSize: "clamp(2.6rem, 5vw, 3.4rem)"
    fontWeight: 700
    lineHeight: 0.85
    letterSpacing: "-0.02em"
    fontVariation: "tabular-nums"
  title:
    fontFamily: "Barlow, system-ui, sans-serif"
    fontSize: "1.15rem"
    fontWeight: 600
    lineHeight: 1.25
    letterSpacing: "-0.005em"
  body:
    fontFamily: "Source Serif 4, Georgia, serif"
    fontSize: "17px"
    fontWeight: 400
    lineHeight: 1.6
    letterSpacing: "normal"
  label:
    fontFamily: "Barlow, system-ui, sans-serif"
    fontSize: "0.76rem"
    fontWeight: 600
    lineHeight: 1.3
    letterSpacing: "0.08em"
  mono:
    fontFamily: "JetBrains Mono, ui-monospace, Menlo, Consolas, monospace"
    fontSize: "0.86rem"
    fontWeight: 400
    lineHeight: 1.6
    letterSpacing: "normal"
rounded:
  none: "0"
  hairline: "2px"
  thumb: "4px"
spacing:
  cell-gap: "8px"
  cell: "12px"
  stanza: "14px"
  block: "16px"
  pad: "24px"
  entry: "36px"
  gutter: "clamp(16px, 4vw, 48px)"
  book-top: "clamp(28px, 4vw, 48px)"
  contents-gap: "clamp(40px, 6vw, 64px)"
  section-gap: "clamp(48px, 7vw, 80px)"
components:
  cover-band:
    backgroundColor: "{colors.cloth}"
    textColor: "{colors.cloth-ink}"
    padding: "clamp(20px,3vw,36px) {spacing.gutter} clamp(22px,3vw,36px)"
  cover-plate:
    backgroundColor: "{colors.label}"
    textColor: "{colors.ink}"
    rounded: "{rounded.none}"
    padding: "6px 6px 0"
    width: "680px"
  entry-strip:
    backgroundColor: "transparent"
    textColor: "{colors.ink}"
    typography: "{typography.title}"
    rounded: "{rounded.none}"
    padding: "9px 12px"
    height: "46px"
  code-field:
    backgroundColor: "{colors.field}"
    textColor: "{colors.ink}"
    typography: "{typography.mono}"
    rounded: "{rounded.none}"
    padding: "14px 16px"
  code-field-slot:
    backgroundColor: "{colors.stock-deep}"
    textColor: "{colors.ink-2}"
    typography: "{typography.mono}"
    rounded: "{rounded.none}"
    padding: "14px 16px"
  copy-tab:
    backgroundColor: "{colors.cloth}"
    textColor: "{colors.cloth-ink}"
    typography: "{typography.label}"
    rounded: "{rounded.none}"
    padding: "0 12px"
    height: "38px"
  copy-tab-hover:
    backgroundColor: "{colors.cloth-deep}"
    textColor: "{colors.cloth-ink}"
  copy-tab-slot:
    backgroundColor: "{colors.ink-2}"
    textColor: "{colors.cloth-ink}"
  copy-tab-slot-hover:
    backgroundColor: "{colors.cloth}"
    textColor: "{colors.cloth-ink}"
  field-label:
    backgroundColor: "transparent"
    textColor: "{colors.ink-2}"
    typography: "{typography.label}"
    padding: "9px 0"
    width: "132px"
  slot-inline:
    backgroundColor: "{colors.grid}"
    textColor: "{colors.ink-2}"
    rounded: "{rounded.none}"
    padding: "0 0.3em"
  stamp:
    backgroundColor: "transparent"
    textColor: "{colors.stamp}"
    rounded: "{rounded.hairline}"
    padding: "2px 7px 1px"
  rail-link:
    backgroundColor: "transparent"
    textColor: "{colors.ink}"
    padding: "9px 2px"
  rail-link-active:
    backgroundColor: "transparent"
    textColor: "{colors.cloth}"
  contents-row:
    backgroundColor: "transparent"
    textColor: "{colors.ink}"
    padding: "12px 0"
  inline-code:
    backgroundColor: "{colors.field}"
    textColor: "{colors.ink}"
    typography: "{typography.mono}"
    rounded: "{rounded.hairline}"
    padding: "0.05em 0.35em"
---

# Design System: Prompt Library (Building from Zero)

## Overview

**Creative North Star: "The Engineering Lab Notebook"**

The page is a bound computation pad, not a docs site and not a card gallery. The ground is pale eye-ease green stock; a bottle-green cloth band carries the cover and every control; the only other color in the world is one stamp red, spent on nothing but the "didn't work" mark. Structure is drawn with hairline rules, the way a preprinted ledger is: entries sit under a ruled No. | Title | Date strip, prompts sit in a ruled code field with a cloth-colored copy tab in its header, and the one-line fields beneath are ruled rows with small uppercase labels in the left margin. The fine quad grid lives only on the frame (the cloth cover, the empty slots) and never behind running text.

Density is deliberate and even. The reading column is capped at 70 characters, entries are separated by rules rather than by space, and every number on the page (entry numbers, section numbers, counts) is set in condensed signage lettering with tabular figures. There is no hero, no feature grid, no call to action; the cover plate states what this is and when it was last revised, and the contents table is the first thing in the column.

Honesty in both states is a visual rule, not just a product one: an unfilled slot is drawn as a dashed quad-grid field in the muted stock, with the bracketed placeholder inside, and a failed entry keeps its number and its place with the title struck through in stamp red.

**Key Characteristics:**
- Rules, not boxes: hierarchy is drawn with 1px and 2px ink rules; filled surfaces are the cloth band, the cover plate, and the code field only.
- Three voices of type: condensed signage for numbers and headings, Barlow for labels and controls, Source Serif 4 for running text; JetBrains Mono for anything copyable.
- One accent surface (bottle-green cloth) and one spot color (stamp red) with a single job each.
- Flat by default; a single soft drop shadow lifts the cover plate off the cloth.
- Quad grid confined to the frame; prose always sits on plain stock.

## Colors

A two-green world: pale eye-ease stock for the page, deep bottle-green cloth for the band and the controls, with green-cast ink and one red stamp.

### Primary
- **Bottle-green Cloth** (`cloth`): the masthead band, the copy tab, link color, selection highlight, caret, focus ring, the section numeral, the active rail item, and the copied-rule that draws across a code header. Every control is cloth; nothing else is.
- **Cloth Deep** (`cloth-deep`): the 6px rule under the band and the copy tab's hover fill.
- **Cloth Ink** (`cloth-ink`) and **Cloth Ink 2** (`cloth-ink-2`): text on cloth. The second step is declared for secondary text on the band but is not currently consumed by a rule.

### Tertiary
- **Stamp Red** (`stamp`): the "didn't work" stamp border and text, and (at 85% alpha) the strike-through on failed entry titles. Nothing else may use it.

### Neutral
- **Stock** (`stock`): page background.
- **Stock Deep** (`stock-deep`): the ground of an unfilled code slot, under its quad grid.
- **Field** (`field`): the filled code field and inline code background.
- **Label** (`label`): the cover plate, a paler stock read as a pasted paper label.
- **Ink** (`ink`): body text, strong rules (contents top, section heads, strip edges, code field border, plate border).
- **Ink 2** (`ink-2`): secondary text, field labels, entry numbers, the copy tab on a slot field, the slot's dashed underline.
- **Ink 3** (`ink-3`): tertiary text: the "No." prefix, "undated", rail counts and note.
- **Rule** (`rule`): mid-weight rules inside components (strip cell dividers, code header, field last-row, status bars) and the default link underline.
- **Rule Soft** (`rule-soft`): row dividers inside lists and fields, the inner plate frame, inline code border.
- **Grid** (`grid`): the quad-grid line on slots (8px pitch inline, 12px pitch in code slots).
- **Grid Dark** (`grid-dark`): the 24px quad grid on the cloth band.

### Named Rules
**The One Stamp Rule.** Stamp red appears only on the "didn't work" stamp and the strike-through it accompanies. It is never a link, a button, an error field, or an accent.

**The Cloth Carries Controls Rule.** Every interactive fill is bottle-green cloth on cloth-ink text. A control on a slot field drops to Ink 2 and only returns to cloth on hover.

**The Grid on the Frame Rule.** The quad grid may sit under the cloth band and inside empty slots. It never sits behind running text or a filled code block.

## Typography

**Display Font:** Barlow Semi Condensed 700 (with Barlow, system-ui, sans-serif)
**Body Font:** Source Serif 4 variable, 400 roman and italic (with Georgia, serif)
**Label/UI Font:** Barlow 400/500/600/700 (with system-ui, sans-serif)
**Mono Font:** JetBrains Mono variable (with ui-monospace, Menlo, Consolas, monospace)

All four families are self-hosted woff2 beside the page with `font-display: swap`; Barlow ships as static weights (400 roman and italic, 500, 600, 700), Barlow Semi Condensed as 500/600/700, the serif and mono as variable axes.

**Character:** Industrial signage lettering for everything that is preprinted on the pad (numbers, headings, labels, controls), a quiet book serif for everything the author writes, and a mono for everything the reader copies. The condensed face is only ever bold; the serif is only ever regular; the pairing reads as a stamped form with handwriting in the fields.

### Hierarchy
- **Display** (700 condensed, `clamp(2.6rem, 7vw, 4.6rem)`, line-height 0.95, tracking -0.01em, balanced wrap): the cover title only.
- **Numeral** (700 condensed, `clamp(2.6rem, 5vw, 3.4rem)`, line-height 0.85, tracking -0.02em, tabular, cloth): the section number beside a section heading. Smaller cousins: contents number and count (1.35rem, Ink 2 / Ink), entry strip number (1.05rem, Ink 2), rail number (0.95rem).
- **Headline** (700 condensed, `clamp(1.7rem, 3.4vw, 2.3rem)`, line-height 1, tracking -0.005em): section headings. Appendix headings 1.5rem; the contents heading 1.25rem uppercase with +0.02em tracking.
- **Title** (600 Barlow, 1.15rem, line-height 1.25, tracking -0.005em): entry titles in the strip. Contents section names use the same voice at 1.05rem; rail items at 0.95rem/500.
- **Body** (400 Source Serif 4, 17px, line-height 1.6, measure 70ch): running text, field values, section intros (1.02rem, Ink 2) and the cover intro (1.02rem, line-height 1.55, max 52ch). Bold in body copy switches to Barlow 600 at 0.95em.
- **Label** (600 Barlow, 0.76rem, tracking 0.08em, uppercase, Ink 2): field labels. The same voice runs at 0.72rem/0.1em on the code header and copy tab, 0.74rem/0.08em on the strip date and the rail heading (0.14em), 0.78rem on plate-foot captions and section counts, and 0.68rem/0.1em on the "No." prefix.
- **Mono** (JetBrains Mono, 0.86rem, line-height 1.6, tab-size 2): code fields. Inline code 0.88em in a Field-colored, Rule-Soft-bordered chip.
- **Stamp** (700 condensed, 0.72rem, tracking 0.14em, uppercase, stamp red).

### Named Rules
**The Tabular Number Rule.** Every number that can be compared with another (entry No., section number, counts, dates) is set in the condensed face with `font-variant-numeric: tabular-nums`.

**The Preprinted Voice Rule.** Labels and controls are Barlow in small uppercase with letter-spacing between 0.06em and 0.14em; running text is never tracked, never uppercase, never sans.

## Layout

The page is a single column of width 1180px centered with a fluid gutter (`clamp(16px, 4vw, 48px)`). Below the cover band it becomes "the book": at 1024px and above, a two-column grid of a 232px sticky rail (top 20px) and a `minmax(0, 1fr)` page column with a `clamp(40px, 5vw, 72px)` gap; below 1024px the rail is hidden entirely and the page column stands alone with a 40px gap. The reading column inside the page is capped at `--measure: 70ch`.

Vertical rhythm: the book opens with `clamp(28px, 4vw, 48px)` of top padding; the contents table sits `clamp(40px, 6vw, 64px)` above section 1; sections are separated by `clamp(48px, 7vw, 80px)`; entries by 36px; the footer closes with 56px. Inside components the steps are 8px (strip cell gap, rail gap), 12px (strip cell padding, field gap, contents list padding), 14px (paragraph margins, entry-body top, section-head gap), 16px (code field margin, definition list margin) and 24px (status padding). Every section and entry carries `scroll-margin-top: 24px` so hash navigation lands clear of the edge.

Breakpoints are exactly two:
- **600px and below**: the entry strip reflows from `auto | 1fr | auto` to a two-column grid with No. and date on the first row and the title spanning a second row under a Rule-colored top border; the ruled fields drop their 132px label column and stack label over value with a 3px gap; the cover plate footer stacks its three cells into rows divided by Rule.
- **1024px and above**: the rail appears and the book becomes two columns.

Code fields scroll horizontally inside their frame on narrow screens (thin Rule-colored scrollbar, 8px tall in WebKit); in print they wrap.

### Named Rules
**The Seventy-Character Rule.** Running text never exceeds the 70ch measure, and the cover intro never exceeds 52ch.

**The Rail Is Optional Rule.** The sticky rail is a desktop convenience; the contents table in the column is the navigation and must stand on its own at every width.

## Elevation & Depth

Flat by default. Depth is carried by rules and by tonal surfaces (stock, deeper stock, field, label, cloth), not by shadows. A single shadow exists: the cover plate casts a soft downward drop (`box-shadow: 0 10px 24px -8px rgba(0,0,0,.45)`) onto the cloth band to read as a paper label pasted on a cover. It is removed in print. No other element, including hover and focus states, may cast a shadow; the copy tab changes fill, the focus ring is a 2px cloth outline offset 3px (inset 3px with cloth-ink color on the copy tab, which sits on cloth).

### Shadow Vocabulary
- **Plate lift** (`box-shadow: 0 10px 24px -8px rgba(0,0,0,.45)`): the cover plate on the cloth band only.

### Named Rules
**The One Shadow Rule.** The cover plate is the only element with a shadow. Everything else is flat and separated by a rule or a tonal change.

## Shapes

Square. The default radius is 0 on every container: band, plate, strip, code field, copy tab, slots. A 2px radius appears only on the three smallest hairline-bordered things (the stamp, inline code chips, the focus-visible outline), and the WebKit scrollbar thumb is 4px. Borders are the form language: 1px Ink for strong frames (plate, code field, strip edges, contents base, rail top, footer top), 2px Ink for heads (contents top, section heads), 1px Rule and Rule Soft for internal dividers, and dashed Ink 2 / dashed Ink for slots. The cloth band ends in a 6px Cloth Deep rule. The plate carries a double frame: a 1px Ink outer border with 6px of label-colored margin and a 1px Rule Soft inner border. The stamp is rotated -4deg and multiplied onto the stock.

## Components

### Cover Band and Cover Plate
The masthead is a cloth band with a 24px quad grid in Grid Dark, `clamp(20px,3vw,36px)` vertical padding, and a 6px Cloth Deep bottom rule. Inside it, left-aligned in the 1180px container, sits the plate: a Label-colored block up to 680px wide, 1px Ink border, 6px label margin, inner 1px Rule Soft frame, the plate-lift shadow. The plate body holds the display title (14px below) and the serif intro; the plate foot is a three-cell ruled row (`auto 1fr 1fr`, 1px Ink top rule, 1px Ink dividers, 44px min height) with a Label-voice caption over a Barlow 600 0.95rem value (tabular). Values that are links are Ink with a Rule underline, turning cloth on hover. At 600px and below the cells stack as rows divided by Rule, caption and value inline.

### Rail (desktop contents)
Hidden below 1024px. Barlow. A 0.74rem/0.14em uppercase heading in Ink 2 over an ordered list with a 1px Ink top rule and Rule Soft row dividers. Each row is a `28px | 1fr | auto` grid: condensed bold number in Ink 2, name at 0.95rem/500 in Ink, count at 0.78rem in Ink 3; 9px 2px padding. Hover turns the name cloth. The active row (IntersectionObserver, rootMargin -10% / -70%) turns name and number cloth at 700 and its bottom rule to Ink. Appendix rows drop the count, use 400 weight, Ink 2, 0.88rem, and replace the number with a 14px stroked arrow (inline SVG, 1.75 stroke). A 0.8rem Ink 3 note sits 18px below.

### Contents Table
The first block in the column. 2px Ink top rule; a header row with the condensed uppercase "Contents" at 1.25rem on the left and the entry count label on the right, closed by a 1px Ink rule. Rows are `40px | 1fr | auto` grids with 12px vertical padding and Rule Soft dividers, the last row closing with 1px Ink. Number: condensed 700 1.35rem in Ink 2. Name: Barlow 600 1.05rem; description beneath in serif 0.95rem Ink 2. Right cell: condensed 700 1.35rem count in Ink over a 0.8rem label ("entries" or "n filled"). Hover underlines the name in cloth with a Rule-colored underline.

### Section Head
An `auto | 1fr` grid aligned to the baseline end: the numeral in cloth beside the condensed headline, a 2px Ink rule beneath with 10px padding, and the count label in the second column 4px under. Followed by an optional serif intro in Ink 2 with 22px below. Appendix sections drop the numeral and run the heading at 1.5rem.

### Entry Strip
The preprinted header row above every entry: a three-cell grid (`auto | minmax(0,1fr) | auto`) with 1px Ink top and bottom rules and 1px Rule dividers between cells. Every cell is a 46px-min flex row with 9px 12px padding. Cell 1: the "No." prefix (0.68rem/0.1em uppercase 600 Ink 3) and the running entry number (condensed 700 1.05rem Ink 2, tabular). Cell 2: the title (Barlow 600 1.15rem) plus, in section 4, the stamp. Cell 3: the date as a 0.74rem/0.08em uppercase label in Ink 2, or "undated" in Ink 3. Code inside a title inherits the title font. Below 600px it becomes two rows as described in Layout. The body beneath has 14px top padding.

### Ruled Fields ("What it's for" / "What I learned")
A definition list of rows, each a `132px | 1fr` grid with 12px gap, 9px vertical padding and a Rule Soft bottom rule; the last row closes with a Rule-colored rule. Label: Barlow 600 0.76rem/0.08em uppercase Ink 2, nudged 0.25em down to sit on the value's baseline. Value: body serif. Stacks at 600px.

### Code Field
A 1px Ink-bordered Field-colored block, 16px below. Header: 38px min height, Rule bottom rule, 12px left padding, the language name as a 0.72rem/0.1em uppercase label in Ink 2, and the copy tab flush right. Body: mono 0.86rem at 14px 16px, horizontal scroll, tab-size 2. The copied-rule is a 2px cloth bar at the header's bottom edge (top 37px) that grows from 0 to 100% width over 600ms on the signature ease and collapses when the copied state clears.

**Slot variant** (`is-slot`, applied when every non-empty line of the block contains a bracketed token or only punctuation): dashed Ink border, 12px quad grid over Stock Deep, dashed header rule, Ink 2 code text, and an Ink 2 copy tab that returns to cloth on hover.

### Copy Tab
The one button in the system, drawn as a label tab on the code header: cloth fill, cloth-ink text, Barlow 600 0.74rem/0.1em uppercase, 38px min height, 44px min width, 0 12px padding, 1px Rule left border, no radius, 7px gap to a 14px stroked inline SVG (copy glyph; swaps to a check when copied). Hover: Cloth Deep. Active: a deeper literal (#102417). Focus-visible: the global 2px ring, inset 3px, in cloth-ink. Background transitions in 150ms; disabled under reduced motion. On press the text reads "Copied" for 1.8s and a polite live region announces it; if the clipboard API is missing the field's text is selected and the tab reads "Select all". Hidden in print.

### Inline Slot
Bracketed placeholder text rendered as a span: Barlow 500 at 0.92em, +0.01em tracking, Ink 2, an 8px quad grid in Grid as its background, a dashed Ink 2 bottom border, 0.3em horizontal padding. Inside titles it runs at 1em.

### Stamp
"didn't work" in condensed 700 0.72rem/0.14em uppercase stamp red, 2px stamp border, 2px 7px 1px padding, 2px radius, rotated -4deg, `mix-blend-mode: multiply`, nowrap. Appears only in the strip of a failed entry, beside a title struck through with a 2px line in stamp red at 85%.

### Links
Cloth text, 1px underline offset 0.18em in Rule, underline turning cloth on hover. In the footer and rail note links are Ink 2.

### Status and Footer
The load-failure status is a Barlow block in Ink 2 with 24px vertical padding between Rule-colored rules. The footer is a 1180px container with a 1px Ink top rule, 14px top padding, Barlow 0.84rem in Ink 2, a wrapping flex row with 8px 24px gaps, space-between.

### Motion
One easing: `cubic-bezier(.16, 1, .3, 1)` (exponential ease-out) at 600ms for the copied-rule; 150ms linear-ish `ease` for the copy tab's fill. Smooth hash scrolling. Under `prefers-reduced-motion: reduce` the rule transition, the tab transition and smooth scrolling are all removed; the text swap remains.

### Browser Surface
`theme-color` is cloth. The favicon is an inline SVG data URI: a cloth square (3px radius) carrying a stock-colored page with three cloth rule lines. Text selection is cloth on cloth-ink; the caret is cloth. Print: the band loses its fill and grid and takes Ink text with a 2px Ink rule; the plate drops its shadow; rail and copy tabs are hidden; code wraps.

## Do's and Don'ts

### Do:
- **Do** draw structure with rules: 1px Ink for frames, 2px Ink for heads, Rule and Rule Soft for internal dividers.
- **Do** set every comparable number in Barlow Semi Condensed 700 with tabular figures.
- **Do** put every control on cloth with cloth-ink text, and let hover deepen to Cloth Deep.
- **Do** render an unfilled slot as a dashed, quad-gridded field in muted stock with the bracketed text visible.
- **Do** keep running text in Source Serif 4 at 17px / 1.6 within a 70ch measure.
- **Do** reflow the entry strip and ruled fields at 600px and reveal the rail only at 1024px.
- **Do** honor `prefers-reduced-motion` by removing the copied-rule and tab transitions, keeping the text swap.

### Don't:
- **Don't** use stamp red anywhere except the "didn't work" stamp and its strike-through.
- **Don't** put the quad grid behind running text or a filled code block; it belongs to the cloth band and the empty slots.
- **Don't** add a shadow to anything but the cover plate.
- **Don't** round corners beyond the 2px hairline on stamp, inline code and focus ring; containers are square.
- **Don't** add a hero, feature grid, card grid, or call-to-action button; the contents table and the copy tab are the only actions.
- **Don't** set running text in a sans, in uppercase, or with tracking; that voice is reserved for preprinted labels and controls.
- **Don't** introduce a second accent surface or a second button style; the copy tab is the button.
