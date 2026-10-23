# Second Unit: Gallery Kit

The gallery kit is what we install for a gallery client. It has four parts.

1. **Notion template.** Six linked databases: Contacts, Touches, Artworks, Consignments, Exhibitions, Tasks. Schema in `notion-template.md`. The master copy is the private page "Second Unit: Gallery Kit (template)" in the Fabrik Labs Notion workspace (https://app.notion.com/p/40236ad484df816f9167ca58e079cd97). Duplicate it into the client's workspace at install.
2. **Getting Started interview.** `skills/getting-started/SKILL.md`. Run once per client. Writes the gallery's rules, voice, and preferences into the bot's memory.
3. **Bots.** One skill folder per job. Starting set: Inquiry Desk, Collector Follow-up. Consignment Tracker next.
4. **Routines.** `routines.md`. The schedules each bot runs on, set during install.

Skills are written as SKILL.md files. Grok Bot imports them unchanged, and so does Claude, so the kit is portable if the runtime changes.

## Install order

1. Client signs up for Grok Bot on their own account.
2. Duplicate the Notion template into the client's workspace. Connect Notion, Gmail, Google Calendar, and Drive in Grok Bot from the client's side.
3. Create one Bot per job in Grok Bot. Install its SKILL.md. Run the Getting Started interview in the first Bot and copy its memory to the others.
4. Import existing contacts and inventory (CSV or spreadsheet) into Notion with the bot's help.
5. Switch on the routines from `routines.md` at the client's chosen times.
6. Two weeks of tuning. Review every draft together.
