---
name: explain-code
description: Use when the user wants to understand existing code — what it does, why it exists, and how to recall it later. Not for teaching during implementation (use mentor-mode). Use when the user asks "what does this file do", "explain this code", or points at code they don't understand.
---

# Explain Code

## What This Does
Walk through existing code so the user can **recreate the core pattern from scratch**, not just understand it passively.

## The Flow

Start with the problem, walk the code, then strip it down. The steps below are a guide — skip or reorder based on what the code needs. But **always end with the skeleton** (step 5).

### 1. What problem does this solve?
Start with the pain. If the user doesn't know the technology, name the problem first, then introduce the concept.

Bad: "This implements Server-Sent Events using EventSource."
Good: "The dashboard shows stale data until you refresh. This file fixes that by pushing updates from the server to the browser in real-time — there's a browser API for this called SSE."

### 2. Walk the flow, section by section
Break the file into 2-4 logical sections. For each section:
- Show the code snippet (not described — actually visible)
- Explain what this piece does in the flow
- Explain **why it's needed** — what breaks or duplicates without it

**Always include code snippets so the user can visualize.** When explaining "why it's needed", show the broken/duplicated version next to the fix when it helps:

```
// ❌ Without it — the pain (duplicated, broken, or verbose)
// ...messy code here...

// ✅ With it — the fix
// ...clean code here...
```

Seeing the broken version next to the fix makes the "why" click instantly.

### 3. The key decision
Every non-trivial file has one decision that matters more than the rest. Call it out:

- Why `useRef` instead of `useState` here?
- Why validate in middleware not the controller?
- Why `Promise.all` instead of sequential awaits?

This is the thing worth remembering.

### 4. One mental model
Give them one sentence to anchor on:

- "One connection, many subscribers"
- "Validate at the boundary, trust internally"
- "The hook owns the pipe, components just tap into it"

If they can't recall this sentence later, the explanation didn't work.

### 5. The stripped-down skeleton (ALWAYS do this)
Show a minimal version of the file — strip types, edge cases, boilerplate. Keep only the core shape (15-25 lines). Number the pieces so the structure is visible.

This is what they'd actually recreate. The real file is just the skeleton + details they'd look up or add as needed. Say this explicitly — separate "the shape" from "the details".

### 6. Where else does this pattern show up?
Connect it to something they already know or will encounter:

- "Same idea as React Context — one provider, many consumers"
- "This is middleware — Express does the same thing"
- "Same pattern as a pub/sub event bus"

## Rules
- ONE FILE AT A TIME — never explain multiple files in one response
- Show the actual code for each section — don't just describe it in words
- For each section answer: what does this do, and why is it needed
- If the user doesn't know the technology, introduce the concept before the code
- ALWAYS show the stripped-down skeleton — this is the most important step
- Be honest about what's worth memorizing vs what they'd look up
- After the skeleton, ask: "could you recreate this from scratch?" If not, the skeleton is still too complex

## What NOT to do
- Don't describe code without showing it — "the provider wraps the hook" means nothing without the code
- Don't explain syntax — assume they can read code
- Don't use abstract descriptions when a concrete example works better
- Don't skip the skeleton — a detailed walkthrough without a skeleton leaves people understanding but unable to recreate
- Don't pretend everything is worth memorizing — separate the shape from the details
