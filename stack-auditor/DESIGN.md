---
name: Stack Auditor
description: A black-and-white verdict sheet with one bright blue, set in condensed Archivo over Source Serif 4; inverts cleanly in dark mode.
colors:
  paper: "#FFFFFF"
  ink: "#0B0B0B"
  ink-2: "color-mix(in srgb, #0B0B0B 66%, #FFFFFF)"
  ink-3: "color-mix(in srgb, #0B0B0B 58%, #FFFFFF)"
  rule: "#0B0B0B"
  rule-soft: "color-mix(in srgb, #0B0B0B 22%, #FFFFFF)"
  field: "color-mix(in srgb, #0B0B0B 3%, #FFFFFF)"
  blue: "#0030E0"
  on-blue: "#FFFFFF"
  paper-dark: "#0A0A0A"
  ink-dark: "#F4F4F1"
  blue-dark: "#5B86FF"
  on-blue-dark: "#0A0A0A"
typography:
  display:
    fontFamily: "Archivo, system-ui, Helvetica Neue, Arial, sans-serif"
    fontSize: "clamp(2.1rem, 7.2vw, 4.4rem)"
    fontWeight: 800
    lineHeight: 0.96
    letterSpacing: "-0.015em"
    fontVariation: "'wdth' 82"
  verdict:
    fontFamily: "Archivo, system-ui, Helvetica Neue, Arial, sans-serif"
    fontSize: "1.9rem"
    fontWeight: 800
    lineHeight: 1
    letterSpacing: "-0.005em"
    fontVariation: "'wdth' 78"
  sum:
    fontFamily: "Archivo, system-ui, Helvetica Neue, Arial, sans-serif"
    fontSize: "clamp(2rem, 6vw, 3rem)"
    fontWeight: 800
    lineHeight: 1
    letterSpacing: "-0.02em"
    fontVariation: "'wdth' 82"
    fontFeature: "tnum"
  headline:
    fontFamily: "Archivo, system-ui, Helvetica Neue, Arial, sans-serif"
    fontSize: "1.5rem"
    fontWeight: 800
    lineHeight: 1.2
    letterSpacing: "-0.01em"
    fontVariation: "'wdth' 85"
  title:
    fontFamily: "Archivo, system-ui, Helvetica Neue, Arial, sans-serif"
    fontSize: "1.25rem"
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: "-0.005em"
  body:
    fontFamily: "Source Serif 4, Georgia, Times New Roman, serif"
    fontSize: "17px"
    fontWeight: 400
    lineHeight: 1.55
    letterSpacing: "normal"
  body-lede:
    fontFamily: "Source Serif 4, Georgia, Times New Roman, serif"
    fontSize: "1.08rem"
    fontWeight: 400
    lineHeight: 1.5
  label:
    fontFamily: "Archivo, system-ui, Helvetica Neue, Arial, sans-serif"
    fontSize: "0.8rem"
    fontWeight: 600
    lineHeight: 1.45
    letterSpacing: "0.08em"
  meta:
    fontFamily: "Archivo, system-ui, Helvetica Neue, Arial, sans-serif"
    fontSize: "0.78rem"
    fontWeight: 400
    lineHeight: 1.5
    letterSpacing: "normal"
    fontFeature: "tnum"
rounded:
  sm: "2px"
spacing:
  2xs: "4px"
  xs: "6px"
  sm: "8px"
  md: "10px"
  lg: "14px"
  xl: "18px"
  2xl: "22px"
  gutter: "clamp(16px, 4vw, 40px)"
  section: "clamp(40px, 7vw, 72px)"
  budget: "clamp(44px, 6vw, 64px)"
components:
  button-primary:
    backgroundColor: "{colors.blue}"
    textColor: "{colors.on-blue}"
    rounded: "{rounded.sm}"
    padding: "14px 22px"
    height: "48px"
  button-ghost:
    backgroundColor: "transparent"
    textColor: "{colors.ink}"
    rounded: "{rounded.sm}"
    padding: "5px 9px"
    height: "28px"
  button-ghost-hover:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.paper}"
  button-text:
    backgroundColor: "transparent"
    textColor: "{colors.blue}"
    padding: "0"
  textarea:
    backgroundColor: "{colors.field}"
    textColor: "{colors.ink}"
    rounded: "{rounded.sm}"
    padding: "14px 16px"
    height: "208px"
  verdict-keep:
    textColor: "{colors.blue}"
    typography: "{typography.verdict}"
  verdict-cancel:
    textColor: "{colors.ink}"
    typography: "{typography.verdict}"
  verdict-replace:
    textColor: "{colors.ink}"
    typography: "{typography.verdict}"
  verdict-none:
    textColor: "{colors.ink-3}"
    typography: "{typography.verdict}"
  link:
    textColor: "{colors.blue}"
  folio:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    padding: "18px 0 14px"
---

# Design System: Stack Auditor

## Overview

**Creative North Star: "The Verdict Sheet"**

Stack Auditor is one typeset column of judgments, not a dashboard. Everything on the page is ink on paper: black text, black hairlines, a white field, and one bright blue that appears only where the page is pointing (the headline's key phrase, the KEEP verdict, the one button, links, selection, caret, focus). Greys do not exist as independent colours; secondary text and soft rules are tints of ink mixed into paper, so the palette inverts in dark mode by swapping two values and the tints follow.

Type does the structural work. Archivo on its width axis is the voice of judgment: verdict words are condensed to 78% and set at display size, section heads at 85%, the headline and budget total at 82%. Source Serif 4 carries every sentence of reasoning and the intro, at 17px with a 66ch measure. Prices, ranks, and scores are tabular so columns of numbers line up like a receipt.

The page refuses the card grid, the score gauge, the coloured badge row, and the hero metric. Depth is conveyed by rule weight alone: 1px hairlines between rows, a 2px rule under the sheet heading, a 3px rule above the budget total. Nothing has a shadow and nothing is rounded past 2px. The build landed the brief's world as pinned by the user (clean, minimal, black-and-white editorial, one bright blue, dark-mode friendly); the finish review disposition was ship after one fix round.

**Key Characteristics:**
- Two colours plus one accent; secondary tones are ink tints, never separate greys
- Condensed Archivo verdict words (800 weight, 78% width) as the loudest element on the page
- Serif reasoning prose at a 66ch measure
- Structure by hairline rule weight (1px / 2px / 3px), no cards, no shadows
- Blue is a pointer, not a decoration: eight named uses and no others
- Tabular numerals wherever money or scores appear
- Dark mode is a true inversion with a brighter blue (#5B86FF) for contrast on ink

## Colors

The palette is paper and ink with one blue; every other tone is a mix of the two.

### Primary
- **Signal Blue** (`blue`, #0030E0 on paper; `blue-dark`, #5B86FF on ink): the single accent. It marks the headline's key phrase ("earn their seat?"), the KEEP verdict word, the primary button, every link (including a REPLACE alternative's name after the arrow), text selection, the caret, the focus ring, and the "ok" status dot once the directory has loaded. Button text on blue is `on-blue` (paper in light, ink in dark).

### Neutral
- **Paper** (`paper`, #FFFFFF; `paper-dark`, #0A0A0A): the page. There is no second surface colour; the textarea's `field` is a 3% ink tint so the writing area reads as a form without becoming a card.
- **Ink** (`ink`, #0B0B0B; `ink-dark`, #F4F4F1): all primary text, the CANCEL and REPLACE verdict words, the 1px/2px/3px structural rules (`rule` is an alias of ink), the strike through a cancelled tool's name, and the ghost button's hover fill.
- **Ink 66** (`ink-2`, ink mixed 66% into paper): secondary text: the form label, the hint, meta lines, the footer disclaimer, the REPLACE arrow, placeholder text, and the small caption under the budget total.
- **Ink 58** (`ink-3`, ink mixed 58% into paper): tertiary text: the loading status line, the "no price given" and "a month, your figure" captions, the "No read yet" verdict, and the middle-dot separators in meta lines.
- **Soft Rule** (`rule-soft`, ink mixed 22% into paper): the hairline between ledger rows, the ruled lines inside the textarea, and the folio link's underline at rest.

### Named Rules
**The One Blue Rule.** Blue appears only on: the headline key phrase, KEEP, the primary button, links (including a REPLACE alternative's name), selection, caret, focus, and the loaded-status dot. CANCEL and REPLACE are ink. Nothing else on the page is blue, and no second accent exists.

**The Ink-Tint Rule.** There are no grey tokens. Any tone between paper and ink is `color-mix(in srgb, var(--ink) N%, var(--paper))` so it inverts with the theme. Do not introduce a hex grey.

**The Inversion Rule.** Dark mode swaps `paper`, `ink`, `blue`, and `on-blue` and nothing else. It is reached by `prefers-color-scheme: dark` (unless `[data-theme="light"]`) or `[data-theme="dark"]`, and `color-scheme` follows so native controls match.

## Typography

**Display Font:** Archivo, variable, width axis 75–125 and weight 400–800 (with system-ui, Helvetica Neue, Arial)
**Body Font:** Source Serif 4, variable, optical size 8–60 and weight 400–600 (with Georgia, Times New Roman)

**Character:** A condensed grotesk delivers the verdicts; a serif explains them. The pairing reads as a printed judgment sheet, blunt in the heads and plain in the sentences. Both families load from Google Fonts because the deliverable is a single file. Fallback risk: the system sans stack has no width axis, so if the font request is blocked the verdict words, headline, and budget total render at normal width and lose their condensed signature; the hierarchy still holds through weight and size.

### Hierarchy
- **Display** (Archivo 800, `wdth` 82, clamp(2.1rem, 7.2vw, 4.4rem), line-height 0.96, tracking -0.015em): the h1 only, balanced, max 16ch, one phrase in blue.
- **Verdict** (Archivo 800, `wdth` 78, 1.9rem, line-height 1, uppercase): the KEEP / CANCEL / REPLACE word that opens each ledger row; 1.55rem under 640px. The "Which one?" and "No read yet" non-verdicts step down to 700 weight, `wdth` 85, 1.15rem, in Ink 58.
- **Sum** (Archivo 800, `wdth` 82, clamp(2rem, 6vw, 3rem), line-height 1, tracking -0.02em, tabular): the monthly total under the 3px rule.
- **Headline** (Archivo 800, `wdth` 85, 1.5rem, uppercase): the sheet heading "The verdicts"; the budget heading uses the same voice at 1.2rem.
- **Title** (Archivo 700, 1.25rem, line-height 1.2): the tool name in each row; a REPLACE alternative's name sits after the arrow in the same weight, in blue.
- **Body** (Source Serif 4 400, 17px, line-height 1.55, 66ch measure): all reasoning prose and the budget sentences at 1.02rem; the intro paragraph at 1.08rem / 1.5.
- **Label** (Archivo 600, 0.8rem, tracking 0.08em, uppercase, Ink 66): the form label. The same voice at 0.72rem / 0.04–0.08em captions the paid cell and the budget total.
- **Meta** (Archivo 400, 0.78rem, line-height 1.5, tabular, Ink 66): the category / rank / score / price / training line under each tool name, the status line, source links, and the results count.

### Named Rules
**The Width-Axis Rule.** Archivo's width is a hierarchy instrument: 78% for verdict words, 82% for the display headline and budget total, 85% for section heads, 90% for the folio name, 100% for everything else. Do not fake condensation with letter-spacing.

**The Tabular Rule.** Any price, rank, score, or count is set with `font-variant-numeric: tabular-nums` in Archivo.

**The Serif-Reasons Rule.** Sentences the reader is meant to read (intro, reasoning, budget prose, newsletter line) are Source Serif 4. Archivo is for words that are judged, labelled, or counted.

## Layout

One centred column, max-width 820px, with a fluid gutter of clamp(16px, 4vw, 40px). The page runs top to bottom as folio, lede, form, results, budget, close, with no sidebar and no grid of modules.

The ledger row is a three-column grid: a 9.5rem verdict column, a flexible tool column, and an auto-width right-aligned paid column, with gaps of 6px row / 20px column and padding 18px 0 20px. Under 640px the row collapses to two columns: the verdict spans the full width on top, the tool name sits left, and the price moves right on the second line. Under 480px the folio's "Building From Zero" link hides, leaving the name and the theme switch.

Vertical rhythm is dense inside the sheet and generous around it: lede padding clamp(26px, 7vw, 72px) above and clamp(18px, 4vw, 40px) below; results open clamp(40px, 7vw, 72px) under the form; the budget block sits clamp(44px, 6vw, 64px) under the last row; the close is clamp(40px, 7vw, 64px) below that, ending with 56px of air. Small steps inside components are 4, 6, 8, 10, 14, 18, and 22px.

Prose is capped at 66ch (`--measure`); the hint at 40ch; the headline at 16ch. The budget block is a flex row (heading and prose left, the sum right) that stacks under 640px with the sum left-aligned.

## Elevation & Depth

No shadows anywhere. The page is flat paper, and depth is conveyed by rule weight and ink tint alone: a 1px soft-ink hairline between rows and inside the textarea, a 1px full-ink rule under the folio, above the form, under the last row, and above the close; a 2px rule under the sheet heading; a 3px rule above the budget total, so the sheet closes like a receipt. The only fills are the 3% field tint on the textarea, the ghost button inverting to solid ink on hover, and the skip link in solid ink. Motion is the other depth cue: rows rise 8px into place over 0.42s with a 70ms stagger, and the CANCEL strike draws left to right over 0.5s, both on `cubic-bezier(.16, 1, .3, 1)` and both disabled under `prefers-reduced-motion`.

### Named Rules
**The Rule-Weight Rule.** Hierarchy of containment is 1px soft / 1px ink / 2px ink / 3px ink. Add structure by choosing a rule weight, never by adding a background, border box, or shadow.

## Shapes

Square by default. The only radius in the system is 2px, applied to the textarea, the primary button, and the theme switch so their edges do not look chipped at retina scale; no container, row, or field goes past it. Rows are open on the left and right (rule only underneath), never boxed. The two drawn marks are a 2px ink strike through a cancelled tool's name (positioned at 52% height, overhanging 2px each side) and a 26×14 SVG arrow at 1.6px stroke, round caps, between a replaced tool and its alternative. The 7px status dot and the favicon's blue square with a square-capped tick are the only other geometry.

## Components

### Buttons
Blunt, square, one voice per role.
- **Shape:** near-square (2px radius), no border, no shadow.
- **Primary ("Audit my stack"):** Signal Blue fill, `on-blue` text, Archivo 700 at 0.98rem, 14px 22px padding, 48px min height. Hover brightens 8% (`filter: brightness(1.08)`); active drops 1px; disabled shows the progress cursor at 72% opacity and reads "Checking…". One per page.
- **Ghost (theme switch):** transparent with a 1px ink border, Archivo 600 at 0.74rem, uppercase, 0.06em tracking, 5px 9px padding, 28px min height, 12px line icon. Hover inverts to solid ink with paper text.
- **Text ("Try again", "Start over"):** no box; Signal Blue underlined in the status line, Ink 66 underlined in the footer, inheriting the surrounding size.
- **Focus:** every control takes the global `2px solid blue` outline at 3px offset.

### Inputs / Fields
- **Style:** full-width textarea on the 3% field tint, 1px ink border, 2px radius, 14px 16px padding, 208px min height growing with content (`field-sizing: content`, JS fallback) to 60vh. Set in Archivo at 1.05rem on a 32px line, with a repeating 1px soft-rule gradient every 32px so pasted lines sit on ruled paper. Tabular numerals; placeholder in Ink 66 teaches the format.
- **Focus:** 2px blue outline at 0 offset and the border turns blue.
- **Error:** a serif-free Archivo message in ink with a 1px ink left rule and 10px indent, 12px under the form foot.

### Navigation
- **Folio:** a single flex line, Archivo 0.82rem with 0.02em tracking, 18px above / 14px below, closed by a 1px ink rule. Name at left in 700 weight, `wdth` 90, uppercase, 0.95rem. At right, a plain-ink link underlined in soft rule (ink on hover) and the ghost theme switch. The link hides under 480px. A skip link in solid ink appears at the top-left on focus.

### Links
Signal Blue text, 1px underline at 0.16em offset, underline colour at 55% blue rising to full blue on hover. In the folio, links are ink with a soft-rule bottom border instead. Source links under a verdict are Archivo 0.78rem; the newsletter link is serif 500.

### Verdict Row (signature)
Each result is a ruled ledger line, not a card. Left, the verdict word in condensed Archivo (800, `wdth` 78, 1.9rem, uppercase): KEEP in blue, CANCEL and REPLACE in ink, non-verdicts in Ink 58 at 1.15rem. Centre, the tool name (Archivo 700, 1.25rem) followed, on REPLACE, by an Ink-66 arrow and the alternative's name in blue; then a tabular meta line, the serif reasoning at 66ch, and source links. Right, the reader's own figure (Archivo 600, 1rem, tabular, right-aligned) over a 0.72rem uppercase caption; an em dash in Ink 58 when no price was given. Rows share a soft 1px hairline and the last row closes on a full-ink 1px rule. On reveal each row rises 8px over 0.42s with a 70ms stagger; on CANCEL a 2px ink strike draws through the name 0.38s after the row lands.

### Budget Total (signature)
Opens on a 3px ink rule with 16px padding above. Heading in Archivo 800, `wdth` 85, 1.2rem, uppercase; one or two serif sentences; and at right the sum in Archivo 800, `wdth` 82, clamp(2rem, 6vw, 3rem), tabular, over a 0.72rem uppercase caption in Ink 66. With no prices the sum is hidden and the prose asks for them.

### Status Line
Archivo 0.78rem in Ink 58 with a 7px dot: the dot turns blue when the directory has loaded, and both dot and text turn full ink on failure, with an inline blue "Try again".

## Do's and Don'ts

### Do:
- **Do** keep blue to the eight sanctioned uses in The One Blue Rule and set CANCEL and REPLACE in ink.
- **Do** build every secondary tone as an ink-into-paper `color-mix` so it survives the dark-mode inversion.
- **Do** set verdict words in Archivo 800 at `font-stretch: 78%`, uppercase, and never fake the condensation with tracking.
- **Do** separate content with 1px hairlines and reserve 2px for the sheet heading and 3px for the budget total.
- **Do** set every price, rank, score, and count with tabular numerals.
- **Do** cap prose at 66ch and keep reasoning in Source Serif 4 at 17px / 1.55.
- **Do** respect `prefers-reduced-motion`: rows appear in place and the strike is already drawn.
- **Do** keep the 2px focus outline in blue at 3px offset on every control.

### Don't:
- **Don't** add cards, boxed rows, background panels, or any box-shadow; depth is rule weight.
- **Don't** exceed a 2px radius on any container, field, or button.
- **Don't** introduce a hex grey, a second accent, or status colours (no red CANCEL, no green KEEP).
- **Don't** use a score gauge, badge row, hero metric, or icon set; the arrow and the theme glyph are the only icons.
- **Don't** set reasoning prose in Archivo or verdict words in the serif.
- **Don't** let the fallback stack stand in for Archivo on a surface where the condensed verdict is the point; the width axis only exists in the loaded font.
