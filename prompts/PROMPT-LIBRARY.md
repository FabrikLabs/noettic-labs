# Building from Zero: Prompt Library

**How to read this.** This is my working notebook, turned public. It updates as I work, so what you see is where I am right now, not a finished product.

Last updated: `[DATE]`

---

## 1. Build prompts

Prompts that create or assemble a thing: a tool, a workflow, an agent.

### `[ENTRY NAME]`

```text
[PASTE THE BUILD PROMPT HERE]
```

**What it's for:** `[One line on what this creates or assembles.]`

**What I learned:** `[One honest line. What worked, what surprised me, or what I'd change next time.]`

### `[ENTRY NAME]`

```text
[PASTE THE BUILD PROMPT HERE]
```

**What it's for:** `[One line.]`

**What I learned:** `[One line.]`

### `[ENTRY NAME]`

```text
[PASTE THE BUILD PROMPT HERE]
```

**What it's for:** `[One line.]`

**What I learned:** `[One line.]`

---

## 2. Research

Prompts that investigate, compare, or rank tools.

### `[ENTRY NAME]`

```text
[PASTE THE RESEARCH PROMPT HERE]
```

**What it's for:** `[One line on what this investigates, compares, or ranks.]`

**What I learned:** `[One honest line.]`

### `[ENTRY NAME]`

```text
[PASTE THE RESEARCH PROMPT HERE]
```

**What it's for:** `[One line.]`

**What I learned:** `[One line.]`

### `[ENTRY NAME]`

```text
[PASTE THE RESEARCH PROMPT HERE]
```

**What it's for:** `[One line.]`

**What I learned:** `[One line.]`

---

## 3. Agent configs

The system prompts and settings that make an agent behave in a reliably useful way.

### `[AGENT NAME]`

```text
[PASTE THE SYSTEM PROMPT HERE]
```

```json
{
  "model": "[MODEL]",
  "temperature": "[VALUE]",
  "tools": ["[TOOL]", "[TOOL]"],
  "notes": "[Anything else that matters: max turns, memory, stop conditions]"
}
```

**What it's for:** `[One line on the job this agent does and where it runs.]`

**What I learned:** `[One honest line. Example of the kind of thing that belongs here: "this failed because the model forgets context after a long run."]`

### `[AGENT NAME]`

```text
[PASTE THE SYSTEM PROMPT HERE]
```

```json
{
  "model": "[MODEL]",
  "temperature": "[VALUE]",
  "tools": ["[TOOL]"],
  "notes": "[...]"
}
```

**What it's for:** `[One line.]`

**What I learned:** `[One line.]`

---

## 4. Failed prompts

Ones I tried that didn't work, with one line on what went wrong. I keep these because the misses teach me more than the hits.

### `[ENTRY NAME]`

```text
[PASTE THE PROMPT THAT FAILED HERE]
```

**What it was for:** `[One line on what I wanted it to do.]`

**What went wrong:** `[One honest line. Why it failed, as specifically as I can say.]`

### `[ENTRY NAME]`

```text
[PASTE THE PROMPT THAT FAILED HERE]
```

**What it was for:** `[One line.]`

**What went wrong:** `[One line.]`

### `[ENTRY NAME]`

```text
[PASTE THE PROMPT THAT FAILED HERE]
```

**What it was for:** `[One line.]`

**What went wrong:** `[One line.]`

---

## How I add an entry

Copy this block into the right section, fill the four parts, update the date at the top. The `Date:` line is optional; if I leave it out, the entry shows as undated.

````markdown
### `[ENTRY NAME]`

Date: [YYYY-MM-DD]

```text
[PROMPT OR CONFIG]
```

**What it's for:** `[One line.]`

**What I learned:** `[One line.]`
````

If it failed, it goes in section 4, and the last two lines become "What it was for" and "What went wrong."

Anything still wrapped in square brackets, like `[THIS]`, shows on the page as an open slot. Once I replace it with real text, it renders as a finished entry.
