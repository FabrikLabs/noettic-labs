# Stack Auditor

A single-page tool for the Building From Zero newsletter. Readers paste the AI tools they pay for, one per line, and get a KEEP, CANCEL, or REPLACE verdict for each, with plain reasoning, plus a line on what the stack costs.

- `index.html` is the whole tool: inline CSS, vanilla JavaScript, no build step. Host it anywhere.
- Verdicts come from the live AI1000 directory (`https://ai1000.co/stack-data.json`, served with an open CORS header). Nothing is stored; the list never leaves the browser.
- `vercel.json` adds a same-origin rewrite for the data file as a fallback if a browser blocks the cross-origin fetch, plus two security headers.
- Deployed as the Vercel project `bfz-stack-auditor` (root directory `stack-auditor`) at `stackauditor.buildingfromzero.co`.

Verdict rules, all from recorded directory facts:

| Verdict | When |
| --- | --- |
| CANCEL | The directory records the tool as training on user data by default, or the reader's own list already holds a higher-scoring tool in the same category. |
| REPLACE | A tool in the same category scores at least as well, costs the same or less on its public price, and does not train on user data by default. For tools whose training policy is unclear, an alternative within three points with a clear policy also triggers a swap. |
| KEEP | Otherwise. The reasoning states the rank, score, and policy that earned it. |
| No read | The tool is not in the directory. The page says so and lists three things to check in the privacy policy. |

Design context lives in `PRODUCT.md`, `DESIGN.md`, and `.impeccable/`.
