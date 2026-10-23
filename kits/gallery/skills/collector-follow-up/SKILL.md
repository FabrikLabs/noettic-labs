---
name: gallery-collector-follow-up
description: Turns the sign-in book from an opening, a stack of business cards from a fair, or a list of visitors into logged Touches and one drafted follow-up email per person, in the gallery's voice, with the right images attached. Also runs the weekly quiet-list. Drafts only.
---

# Gallery Collector Follow-up

One job: nobody who signed the book at an opening goes without a personal note from the gallery within a day.

## When to use

- The morning after an opening, when someone uploads a photo of the sign-in book page and says "follow up."
- After a fair, when someone uploads photos of business cards or a visitor list.
- Monday mornings, on the quiet-list routine.

## Inputs and access

- Uploaded photos or files in chat.
- Notion Contacts, Touches, Exhibitions, Artworks.
- Gmail drafts. Never send.
- Google Drive: the exhibition's install shots and work images.
- Memory: the voice note, the never list.

## Workflow: sign-in book or cards

1. Read every line in the photo. For each person, extract name, email, and anything they wrote (a phone number, "interested in the large canvases"). If a line is unreadable, list it at the end for a person to fix. Never guess an email address.
2. Match each person to Contacts by email, then by name. New people get a contact with Source = Sign-in book (or Fair), Type = Collector unless the note says otherwise, First visit = the opening date.
3. Log one Touch per person: Channel = Opening or Fair, Date = the exhibition's opening reception date from Exhibitions, Summary = what they wrote or "attended the opening," Source image = the photo, Logged by = Bot.
4. For each person, draft a follow-up email in the gallery's voice. Rules:
   - Thank them for coming, by name, and name the show.
   - If they noted an interest, speak to it and attach that work's image from Artworks or Drive.
   - If they didn't, attach one install shot and mention one work the director flagged as the show's anchor.
   - One next step: a quiet visit this week, or the price list on request.
   - Under 120 words. No prices unless the work is Public and they asked.
   - Known collectors who own work get a warmer, shorter note that mentions what they own.
5. Save each draft in Gmail. Set Draft status = Drafted and Draft link on the Touch. Set Follow-up status = Drafted and Last touch on the contact.
6. Post one summary in chat: how many people, how many new contacts, how many drafts, and the unreadable lines.

## Workflow: weekly quiet-list

1. Find contacts of Type = Collector with Last touch older than 90 days and Follow-up status not Cold.
2. Rank by Owns (people who own work first), then by Interests.
3. For the top ten, draft a light check-in: one thing that's new at the gallery that fits their interest. Under 80 words.
4. Save drafts, log Touches with Channel = Email, and post the list in chat.

## Verify before you finish

- Every email address came from the photo or from Contacts, never from a guess.
- No draft mentions a price for a work that isn't Public.
- No draft promises a hold, a discount, or a studio visit.
- Each attached image belongs to the work or show named in the draft.

## Output

Touches, updated Contacts, Gmail drafts, and the chat summary.

## Approval

The director reads and sends each draft. The target after the two-week tune-up is that most drafts go out with no edits. Reading a sign-in book is read-only; creating contacts and touches is allowed without asking; sending is never allowed.
