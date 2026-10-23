# Gallery kit: Notion schema

Six databases. Relations are two-way unless noted.

## Contacts
| Property | Type | Notes |
|---|---|---|
| Name | Title | |
| Email | Email | Match key for the follow-up bot |
| Phone | Phone | |
| Type | Select | Collector, Curator, Press, Artist, Advisor, Vendor, Other |
| Source | Select | Sign-in book, Website inquiry, Fair, Referral, Walk-in, Other |
| City | Text | |
| Interests | Multi-select | Artist names, populated by the bot from touches |
| Follow-up status | Select | New, Drafted, Sent, Replied, Cold |
| First visit | Date | |
| Last touch | Date | Kept current by the follow-up bot |
| Owns | Relation to Artworks | Set only by a person |
| Touches | Relation to Touches | |
| Notes | Text | |
| Owner | Person | Who at the gallery holds the relationship |

## Touches
| Property | Type | Notes |
|---|---|---|
| Summary | Title | One line: "Opening, Oct 18, asked about the large canvases" |
| Contact | Relation to Contacts | |
| Date | Date | |
| Channel | Select | Opening, Visit, Email, Fair, Call, Website |
| Exhibition | Relation to Exhibitions | |
| Draft status | Select | Not needed, Drafted, Approved, Sent |
| Draft link | URL | The Gmail draft the bot wrote |
| Source image | Files | The sign-in book photo or business card |
| Logged by | Select | Bot, Person |

## Artworks
| Property | Type | Notes |
|---|---|---|
| Title | Title | |
| Artist | Select | |
| Year | Text | |
| Medium | Text | |
| Dimensions | Text | |
| Inventory no. | Text | |
| Price | Number, dollar | |
| Price visibility | Select | Public, On request, Director only. Decides what the inquiry desk may say |
| Status | Select | Available, On hold, Sold, Consigned out, Not for sale |
| Location | Text | |
| Image | Files | |
| Owner | Relation to Contacts | Set only by a person |
| Consignment | Relation to Consignments | |
| Exhibitions | Relation to Exhibitions | |
| Notes | Text | |

## Consignments
| Property | Type | Notes |
|---|---|---|
| Agreement | Title | "Artist name, 2026 consignment" |
| Artist | Text | |
| Works | Relation to Artworks | |
| Start | Date | |
| End | Date | The tracker watches this |
| Commission split | Number, percent | Gallery share |
| Insurance value | Number, dollar | |
| Agreement PDF | Files | |
| Status | Select | Active, Expiring, Renewed, Returned |
| Reminder sent | Checkbox | |

## Exhibitions
| Property | Type | Notes |
|---|---|---|
| Title | Title | |
| Type | Select | Solo, Group, Fair, Offsite |
| Artists | Text | |
| Opens | Date | |
| Closes | Date | |
| Opening reception | Date | The follow-up bot uses this to date sign-in book touches |
| Works | Relation to Artworks | |
| Press text | Files | |
| Fair booth | Text | |
| Touches | Relation to Touches | |

## Tasks
| Property | Type | Notes |
|---|---|---|
| Task | Title | |
| Status | Status | To do, Doing, Waiting, Done |
| Due | Date | |
| Owner | Person | |
| Exhibition | Relation to Exhibitions | |
| Contact | Relation to Contacts | |
| Created by | Select | Bot, Person |
| Notes | Text | |
