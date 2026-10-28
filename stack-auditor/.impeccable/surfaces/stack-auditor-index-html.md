---
version: 1
slug: "stack-auditor-index-html"
primary_target: "stack-auditor/index.html"
related_targets: []
---

# Stack Auditor surface brief

Scope: `stack-auditor/index.html`, the whole single-page tool. Visitor mode: Operate (a reader completes one task: audit a pasted list of AI tools), with Read-mode care for the reasoning prose.

Audience and job: Building From Zero readers auditing their own AI subscriptions in under a minute, often on a phone from an email link. Action: paste names, press the one button, read verdicts, act on one. Proof and content: live AI1000 directory facts (category, score, rank, public price, training status) and a link to each tool's AI1000 page for the company's own words. Constraints: single self-contained HTML file, vanilla JS, no build step, no popups, no email wall, no invented prices or policies, unrecognised tools get a non-answer with three privacy checks.

Memorable moment: the reader's own list comes back as a typeset column of verdicts, CANCEL striking the tool's name through, with a receipt-style running total at the bottom.

Unresolved: Archivo and Source Serif 4 load from Google Fonts because the deliverable is one file; the fallback stack is system sans and serif, which loses the width axis on the verdict words if the font request is blocked. Also, the directory data file does not carry free-plan status, so "a free tool does the same job" is expressed as "a cheaper or equal-priced tool in the same category scores as well".

## Direction contract

THESIS: A verdict sheet, not a dashboard. The reader's own list returns as a single column of judgments, each tool a headline-weight verdict word with two plain first-person sentences under it. It refuses the card grid, the score gauge, the coloured badge row, and the hero metric.

OWN-WORLD: Paper white on ink black in light, inverted in dark; no greys for text, only tints of ink. One bright blue (#0030E0 on paper, #5B86FF on ink) reserved for the headline’s key phrase, KEEP, the primary button, links (including a REPLACE alternative’s name), selection, caret, and focus; the headline use is the user’s “one accent color (a bright blue)” applied once, before the ledger. Archivo on its width axis for verdict words, labels, buttons, numerals (tabular); Source Serif 4 for reasoning prose and the intro. Hairline 1px ink rules carry structure; no cards, no shadows, no rounded containers past 2px; dense ledger rhythm with generous space only above the budget line.

STORY: The reader pastes, presses "Audit my stack", reads verdicts top to bottom, sees what the stack costs, leaves with at least one cancellation and a reason they can repeat, and maybe clicks through to the newsletter.

FIRST VIEWPORT: A thin folio line (Stack Auditor at left, Building From Zero at right, theme switch) over a 1px rule. One first-person intro sentence in the serif. The textarea full width and tall, ruled by hairlines, with a placeholder that teaches the format ("Notion 10" one per line). Under it, left: the blue button "Audit my stack"; right: a quiet note that nothing leaves the browser except the tool names' lookup. Results render in place below and the page scrolls to the first verdict.

SIGNATURE MOVE: verdict words set in condensed Archivo at display size, flush left, each row a ruled ledger line; CANCEL draws a 2px ink strike through the tool's name on reveal; REPLACE sets the alternative's name in the same weight after a drawn SVG arrow; the budget line closes the sheet under a 3px rule like a receipt total.

FORM: Brief-pinned. The user’s own words: “Make it look clean and minimal, dark-mode-friendly, matching a black-and-white editorial aesthetic with one accent color (a bright blue).” The concept-seed roll was skipped as a documented user pin, not an omission. Position on the ordered list: pinned, first. Seed key: none (user-pinned direction; mode operate).

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance
