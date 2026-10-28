---
version: 1
slug: "prompts-index-html"
primary_target: "prompts/index.html"
related_targets: ["prompts/PROMPT-LIBRARY.md"]
---

# Surface: prompts/index.html (prompts.buildingfromzero.co)

Scope: one static Read-mode page, the Building from Zero prompt library. Renders `prompts/PROMPT-LIBRARY.md` client-side so the author only edits markdown. Unlisted link, no index, no login.

Audience and job: paid subscribers arriving from an email, often on a phone. Two jobs weighted equally: find one entry and copy its prompt; browse the sections to read the learnings, failures included.

Content: four fixed sections (Build prompts, Research, Agent configs, Failed prompts). Every entry: name, prompt or config in a code block, one line "what it's for", one line "what I learned" (section 4: "what it was for" / "what went wrong"). At launch every entry is a labeled placeholder slot.

Constraints: no hero, no feature grid, no calls to action, no marketing copy. Copy-to-clipboard on every code block is the only interactivity. Fonts ship as files beside the page. No build step.

## Direction contract

THESIS: A prompt library kept as a bound engineering lab notebook, not a catalog. Entries are numbered in one running sequence and dated, nothing is erased, and the failures sit in the same ledger as the hits, struck through but legible. It refuses the docs-site arrangement (a sidebar tree of equal pages around gray code boxes) and the SaaS gallery of same-size cards.

OWN-WORLD: Eye-ease pale green stock, the engineering computation pad, with a fine quad grid confined to the frame (masthead ground, rail, empty slots) and never behind running text. Ink is a near-black with a green cast. A deep bottle-green cloth band carries the masthead and every control. One stamp red exists and is spent only on the "didn't work" mark in section 4. Type: Barlow and Barlow Semi Condensed (industrial signage lettering) for the cover label, numbers, field labels, and controls; Source Serif 4 for running text; JetBrains Mono for prompts and configs. Components: the preprinted entry header row (No. | Title | Date) as a ruled strip above each entry; ruled "For" and "Learned" fields; a copy control drawn as a small label tab on the ruled strip; empty slots drawn as dashed quad-grid fields with the placeholder text inside; the masthead as a cover label block. With all content removed the page is a green computation pad with a dark cloth spine.

STORY: The reader sees within a second that this is one person's notebook, revised on a stated date and still being filled. They find their section in the contents, jump to it, hit copy on the prompt, and read the one line underneath it. A browsing reader scrolls the ledger in order and reaches the failures last, where the struck-through names make the honesty visible without a word of explanation.

FIRST VIEWPORT (desktop 1440 wide): A bottle-green band across the top, about a third of the viewport tall, holding the cover label block left-aligned on a pale label: "Building from Zero" small in Barlow caps, "Prompt Library" large, the two-sentence how-to-read line in Source Serif 4 beneath it, and a ruled footer row on the label reading "Last revised [date]" and "[n] entries, [m] slots open". Below the band, on the green stock: a left rail (sticky, about 240px) with the contents as a ruled list with entry counts; to its right the reading column at 68ch holding the contents table as the first ruled block (No., section, what it holds, count) and the start of section 1 with its first entry strip visible at the fold. Primary action: the section links in the contents; secondary: the first entry's copy tab. Mobile 390: band compressed to the label block; contents as a ruled list; rail hidden; the entry strip stacks (No. and date on one line, title below), code blocks scroll horizontally inside their field, copy tab stays reachable with the thumb.

FORM: Engineering lab notebook. Candidate 1 on my ordered grounded list, presented as the pick card and chosen by the user over the assigned candidate 5 (type specimen sheet). seed: none (the roll ran degraded with the catalog unreachable and printed no SEED REFERENCE line). Code-led (no image generation).

SIGNATURE INTERACTION: Copy tab on every code field. On press the tab reads "Copied" with a drawn check, and a thin bottle-green rule draws across the code field's header left to right, exponential ease-out, 600ms, then settles back after 1.8s. Reduced motion: text swap only.

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance.

## Unresolved
- Dates and entry numbers come from the markdown when the author adds them; the renderer numbers entries in sequence and shows "undated" until a date line exists.
