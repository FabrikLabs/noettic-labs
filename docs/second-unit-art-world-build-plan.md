# Second Unit for the art world: how it's put together

Galleries first, artists second, museums third. Art consultants and art fairs added. This covers where each bot's information comes from, how it gets in, the stack, and what we build today.

## 1. The short version

Every bot needs three things: a place to read from, a place to write to, and a person who says yes. For the art world the answer is the same every time.

- **It reads from** the client's inbox, their calendar, photos they upload, and a small set of Notion databases.
- **It writes to** those same Notion databases, and drafts emails in their Gmail.
- **The person** is the director, the artist, or the consultant, who approves every send and every change to price, provenance, or ownership.

We don't build our own database. Notion is the system of record for every client, and we hand each client a ready-made Notion workspace, the kit, at install.

## 2. The stack

| Layer | Tool | Who pays | About |
|---|---|---|---|
| The agents | Grok Bot | Client, to xAI | Included in the X Subscription Premium plan, $30 a month per person. The $8 Plus plan does not include it. There is no $20 tier. |
| System of record | Notion | Client, to Notion | Free plan works for one artist. A gallery with two or three people needs Plus, about $10 a seat a month on annual billing. Verify the day we quote it. |
| Inbox and calendar | Gmail and Google Calendar | Client already has it | Grok Bot connects to both. |
| Files and images | Google Drive | Client already has it | Install shots, PDFs, consignment agreements. |
| Existing art database | Artlogic, Artsy, or a spreadsheet | Client already has it | If a gallery runs Artlogic, that stays the inventory. Notion holds only what Artlogic doesn't: collector notes, follow-ups, production checklists. |

A solo artist runs the whole thing for about $30 a month. A small gallery, about $60. That's the number for the page.

## 3. Where the information comes from, gallery by bot

Each row: what goes in, how it gets in, what comes out, who approves.

**Inquiry desk.** In: inquiry emails and website form submissions, which already land in the gallery inbox. Reference: the Artworks database in Notion with price, availability, and the rule for who gets a price. Out: a drafted reply in Gmail and a new row in Contacts. Approves: the director, every reply, until the tune-up shows it's safe to auto-send "it's available, here's the sheet" replies only.

**Collector follow-up.** In: the sign-in book. Someone photographs the page after the opening and uploads it to the bot in chat. The bot reads the names and emails, matches them against Contacts, adds the new ones, and logs a visit for each. Same for a stack of business cards from a fair. Out: one drafted follow-up per person, with the right images attached from Drive, waiting in Gmail drafts the next morning. Approves: the director, one click each.

**Collector profiles.** In: nothing new. The bot reads the gallery's sent mail, the Contacts database, and the sales history, and keeps each profile current. Out: a one-page profile in Notion per collector: what they own, what they asked about, last visit, what to show them next. Routine: refresh weekly. Approves: nobody needs to. It's read-only until a human acts on it.

**Consignment tracker.** In: the consignment agreement as a PDF, dropped into a Drive folder or uploaded to the bot. The bot reads artist, works, term dates, commission split, and insurance, and fills the Consignments database. Out: a reminder 30 days before each term ends, with the renewal or return email drafted. Approves: the director.

**Fair prep.** In: the fair's exhibitor manual and deadlines, uploaded as a PDF, plus the works list for the booth. Out: a checklist in Notion with dates, the shipping quote request, and the preview email to collectors in that city. Routine: six weeks out, then weekly. Approves: the director.

**Press and preview kit.** In: the exhibition text, the checklist, and the artist bio, which the gallery writes anyway. Out: press release, preview email, social captions, newsletter block, all drafted in the gallery's voice from samples the Getting Started interview collected. Approves: the director.

**Exhibition production.** In: the show date and the works list. Out: a checklist in Notion across framing, shipping, install, photography, and labels, with the vendor nudge emails drafted on schedule. Approves: whoever runs production.

**Artist liaison.** In: the sales history and the exhibition calendar, already in Notion. Out: a monthly update email per artist: what sold, what's on hold, what's coming up, what the gallery needs. Approves: the director.

## 4. Where the information comes from, artist by bot

**Studio inquiry desk.** In: the artist's inbox. Reference: an Artworks database with prices and a sheet of what the artist is willing to say about price and availability. Out: drafted replies. Approves: the artist, always, on anything about price.

**Inventory and provenance.** In: a one-time import from the spreadsheet or photos they already have, then one photo and a short note per new work. Out: a catalogue in Notion with location, price history, owner, and a certificate of authenticity on request. Approves: the artist on every ownership change. No exceptions.

**Application writer.** In: the artist's statement, CV, and past applications, uploaded once. The bot watches a list of open calls, residencies, and grants we give it. Out: a drafted application per deadline. Approves: the artist.

**CV, bio, and statement keeper.** In: every show, press mention, and sale as it happens, which the other bots already log. Out: the CV updated, and a bio at the length requested.

**Gallery and curator research.** In: a description of the work and the artist's goals. Out: a researched list of galleries and curators showing comparable work, with a drafted introduction each. Approves: the artist.

**Follow-up, press and social, pricing ledger, shipping, teaching admin, book project.** Same pattern: the input is a photo, an upload, or an email that already exists, the output is a draft or a Notion row, and the artist approves.

## 5. The two markets you added

**Art consultants.** One agent each: client brief intake that turns a meeting into a brief and budget sheet; sourcing desk that searches galleries, fairs, and artist lists against the brief and builds a shortlist with images; presentation builder that turns the shortlist into the client deck; availability and price check that emails galleries and logs replies; approval and invoice tracker; installation coordinator for shipping, framing, and install dates; and a client collection ledger with insurance values and locations.

**Art fairs.** One agent each: exhibitor inbox that answers logistics questions from the manual and routes the rest; application and booth tracker; deadline nudges to exhibitors for insurance, shipping forms, and wall specs; shipping and customs desk that tracks every crate; VIP and press list builder with follow-ups; and the post-fair recap per exhibitor.

Interior designers fit the consultant pattern almost exactly. Later.

## 6. What we're building

Each market is a kit. A kit is four things, and the same four every time:

1. **A Notion template** for that market. Galleries get Contacts, Artworks, Consignments, Exhibitions, and Tasks. We duplicate it into the client's workspace at install.
2. **A Getting Started interview** for that market. The gallery version asks about the price-disclosure rule, the voice, the artists, the calendar, and what the bot may send on its own.
3. **Three to five bots**, each a skill file plus routines, built by us and installed into the client's Grok Bot account.
4. **One landing page**, under noettic.com/second-unit, with the market's three starting jobs and the same pricing table.

One Second Unit page, then one sub-page per market. Galleries first.

## 7. Today

In this order. Stop at the end of the day wherever we are.

1. Build the gallery Notion template: five databases, with the fields each bot reads and writes.
2. Write the gallery Getting Started interview skill.
3. Build Inquiry Desk and Collector Follow-up as skill files with their routines.
4. Install both in a Grok Bot account and run them on Fabrik Projects Gallery's inbox and the last opening's sign-in book.
5. Draft the gallery landing page copy from the offer sheet, with the three jobs swapped for Inquiry Desk, Collector Follow-up, and Consignment Tracker.

Items 1 to 3 I can build here. Item 4 needs your Grok Bot account and your inbox. Item 5 I can draft while you test.

## 8. Things to check before quoting

- Notion plan prices and the free plan's limits for a one-person workspace.
- Whether Grok Bot's Notion connector can create database rows, not just read them. The marketplace templates list Notion as an integration, but we test it on day one.
- Whether a photo of a handwritten sign-in book reads reliably. If not, a typed sign-in on an iPad at the desk solves it.
- Artlogic has an API. If a gallery insists on Artlogic as the record, we connect to it instead of duplicating into Notion.
