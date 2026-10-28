# Product

<!-- impeccable:product-schema 1 -->

Scope: this record covers the Building from Zero prompt library that ships from `prompts/` (served at prompts.buildingfromzero.co). The Noettic Labs marketing page at the repository root (`index.html`) is a separate surface and is not described here.

## Platform

web

## Stack

static HTML/CSS, one page, no build step. Deployed as its own Vercel project with `prompts/` as the root directory. Confirmed by the user (hosting round, 2026-10-28).

## Users

Paid subscribers of Building from Zero, a newsletter by Chris (the author) about building things with AI agents and tools. They arrive mostly from an email about a specific build. Two jobs, weighted equally (confirmed): grab one prompt and go (find the entry, copy the prompt, leave), and browse to learn how the author thinks, including from the failures.

## Product Purpose

A single reference document of the actual prompts, agent configs, and design decisions behind what the author builds. It is the paid benefit of the newsletter. It is a working notebook turned public: it is updated as the author works, and it must never look stale or finished. Success: a subscriber finds and copies the prompt they came for in seconds, and a browsing subscriber reads the learnings and comes away with a usable judgment, not a pitch.

## Positioning

Real prompts with honest learnings, including the ones that failed and why. Most prompt libraries are curated best-of lists; this one is the author's own notebook with the misses left in. Neighbors cannot truthfully copy the failures section or the first-person account of what each prompt taught.

## Operating Context

- Four fixed sections in this order: Build prompts, Research, Agent configs, Failed prompts.
- Every entry has the same four parts: a short name, the prompt or config in a code block, one line on what it is for, one line on what the author learned.
- The author pastes real prompts in over time. At launch the entries are labeled placeholder slots. The page must read correctly in both states.
- The canonical content is a markdown file (`prompts/PROMPT-LIBRARY.md`) the author edits and also pastes into other pages. The HTML page renders the same content.
- The link is unlisted: shared only inside paid emails. No login. The page must not be indexed.
- Readers often arrive on a phone from an email client.

## Capabilities and Constraints

- Copy-to-clipboard on every code block is the one piece of interactivity.
- Long code blocks (system prompts, JSON configs) must stay readable and copyable on mobile.
- No analytics, no forms, no email capture, no pricing, no calls to action.
- No build tooling. Any font ships as files beside the page.
- Undecided: whether entries will later carry dates or version numbers. Leave room, do not invent them.

## Brand Commitments

- Name: Building from Zero. Newsletter domain: buildingfromzero.co (hosted on Substack). Library domain: prompts.buildingfromzero.co.
- Voice: plain, first person, no marketing language, no hype. The author's words: "my working notebook, turned public."
- No existing logo, palette, or typeface to preserve (confirmed: look is open, only the name is binding).
- Must not read as a SaaS landing page: no hero, no feature grid, no call-to-action buttons (confirmed).

## Evidence on Hand

- The author's brief in this session, which supplies the section list, the entry shape, and the tone.
- No real prompts yet. Do not fabricate prompts, learnings, subscriber counts, testimonials, or dates.

## Product Principles

1. The reader's prompt is the content; everything else is frame. Nothing performs behind the text.
2. Honest in both states: a placeholder slot looks like a slot, never like a finished entry.
3. Copy first. Every code block copies in one action, on every screen size.
4. Looks alive, not done. The page signals that it changes as the author works.
5. One page, one file to edit. The author maintains markdown; the site follows.
