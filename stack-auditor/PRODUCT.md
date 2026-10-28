# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Stack

Static: one self-contained `index.html` with inline CSS and vanilla JavaScript, no build step. The user asked for this explicitly so the file can be hosted anywhere. Deployed as its own Vercel project (root directory `stack-auditor/`) at `stackauditor.buildingfromzero.co`. A `vercel.json` rewrite may proxy the AI1000 data file as a same-origin fallback; it is a convenience, not a dependency.

## Users

Readers of the Building From Zero newsletter (buildingfromzero.co), arriving from an issue or a link. They pay for several AI subscriptions, suspect some are dead weight, and want a blunt second opinion in under a minute. They are not buyers for a team; they are individuals and small operators auditing their own stack. (Inferred from the brief; the user confirmed the audience is the newsletter's readers.)

## Product Purpose

The Stack Auditor takes a pasted list of AI tools, optionally with what the reader pays, and returns a verdict per tool: KEEP, CANCEL, or REPLACE, with one or two plain sentences of reasoning. Under the list it names what is draining the budget: the monthly total when prices were entered, or a nudge to add them. Success is a reader cancelling or swapping at least one tool with a reason they could repeat to a friend.

## Positioning

Verdicts come from the AI1000 directory (ai1000.co, a Noettic Labs property), which ranks 1,000 AI tools and records, from each company's own pages, whether it trains on user data by default, its public price, and its rank and score inside its category. Neighbouring "audit your subscriptions" tools guess or flatter. This one refuses to: an unrecognised tool gets "I don't have a read on this one yet" and three things to check in its privacy policy, never a guessed verdict.

## Operating Context

The page is used once, quickly, often on a phone from an email link. Readers paste names one per line, in whatever casing or punctuation they have ("Notion AI", "chatgpt plus", "Otter.ai $17"). The live data is `https://ai1000.co/stack-data.json`, served with an open CORS header, one row per tool: name, category, score out of 100, overall rank, per-seat monthly price, flat monthly price, audience (personal or team), whether pricing is sales-only, training status (`notrain`, `optin`, `trains`, `unclear`, `unknown`), and logo path. Each tool also has a public page at `https://ai1000.co/tool-<slug>.html` carrying the company's own quoted words, the source link, and the date checked.

## Capabilities and Constraints

- Input: a textarea, one tool per line, with an optional price on the same line.
- Output: one verdict block per tool, in input order, plus a budget line, a one-line disclaimer, and one newsletter link.
- Verdict rules, all derived from recorded directory facts, never composed from memory:
  - CANCEL when the directory records the tool as training on user data by default, or when the reader's own list holds a higher-scoring tool in the same category (paying twice for one job).
  - REPLACE when a tool in the same category scores at least as well, costs the same or less on its public price, and does not train on user data by default; the alternative is named.
  - KEEP otherwise, with the reasoning stating the facts that earned it. When the directory records the training policy as unclear or unstated, KEEP says so bluntly rather than hiding it.
  - Unrecognised tool: no verdict. "I don't have a read on this one yet" plus three privacy-policy checks.
- Never cite popularity, fame, or "everyone uses it" as a reason. Rank is reported as a fact, not a reason to keep.
- Never invent prices or data policies. Prices shown are either the reader's own entry or the directory's public price, labelled as such.
- The directory does not record whether a tool has a free plan in this data file, so "a free tool does the same job" is expressed as "a cheaper or equally priced tool in the same category scores as well", which the data supports.
- Lookup is live against ai1000.co at page load; when that fetch fails, the page says it could not reach the directory and offers to retry. It never falls back to a guess.
- Dark-mode friendly: follows the system preference, with a manual switch.
- Disclaimer line: verdicts are the author's editorial judgment based on the AI1000 directory, not financial advice.
- One link at the end: "Get the full reasoning in my newsletter" to https://buildingfromzero.co. No popups, no email wall.

## Brand Commitments

- Name: Stack Auditor. Newsletter: Building From Zero (buildingfromzero.co). The subdomain is stackauditor.buildingfromzero.co (chosen by the user).
- Voice: warm, plain, first person. "Build it, watch what happens, report back." No hype, no "unlock", no "consolidate your stack". Specific and blunt: name the job the tool does and who does it for less.
- Visual constraint pinned by the user: clean, minimal, black-and-white editorial aesthetic with one bright blue accent, dark-mode friendly.
- The sibling site prompts.buildingfromzero.co uses its own green book-cloth world; this surface does not inherit it.

## Evidence on Hand

- Live AI1000 directory data at the URL above (1,000 tools, 72 categories, checked on 2026-10-28).
- No testimonials, reader counts, or results claims exist for this tool; the page makes none.

## Product Principles

1. Say only what the directory supports, and link the company's own words for the rest.
2. A non-answer is a real answer. Unknown beats guessed, every time.
3. Blunt and specific beats gentle and vague.
4. One screen, one minute, no account.
5. The newsletter earns the click; it never blocks the result.
