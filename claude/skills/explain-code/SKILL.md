---
name: explain-code
description: Use when the user wants to understand existing code — what it does, why it exists, and how to recall it later. Not for teaching during implementation (use mentor-mode). Use when the user asks "what does this file do", "explain this code", or points at code they don't understand.
---

# Explain Code

Help the user **own the pattern** — not just nod along, but be able to recreate it from scratch.

## Who This Is For

A developer who can code. They don't need hand-holding on basics like variables, functions, or components. The skill is for when they hit a *new concept* — a pattern, hook, or technique they haven't seen before. Adjust the breakdown to the new parts only. Skip what they already know.

## The Problem

Most code explanations build recognition ("yeah, that makes sense") but not recall ("I can build this myself"). The fix: make the user *think* before you explain, then make them *produce* after.

## The Flow

### 1. Predict first

Before explaining anything, show a small piece of the code and ask them to guess what it does or what comes next. Frame it around the problem the code solves.

Let them answer. Even a wrong answer makes the real explanation stick harder.

### 2. Name the chunks

Don't walk through code line by line. Break the file into 2-3 named conceptual steps.

Give each step a short ALL-CAPS label that describes *the purpose*, not the syntax. Then show minimal code for each chunk. The labels are what they'll remember — they should be able to recreate the code from the labels alone.

### 3. One key decision

What's the non-obvious choice in this file? One sentence about *why*, not *what*.

Skip everything else. They'll ask if they want more.

### 4. Teach-back

Don't ask "did that make sense?" — they'll say yes even when it didn't.

Ask them to produce something:
- "If you had to rebuild this from scratch, what are the steps you'd follow?"
- "Explain it back to me like I haven't seen the code."

If they can name the chunks in order, it stuck. If not, go back to step 2.

## Language Rules

- **Plain English for new concepts only.** They know what a function is. But if `useCallback` is new, give them an everyday version: "it's like saving a function in a box so it doesn't get recreated every render."
- **One analogy, stick with it.** Don't switch from "pocket" to "name tag" halfway through.
- **One new concept per response.** If there are 3 new ideas, explain one and let them ask for the next. Stuff they already know doesn't count — skip it freely.
- **Show the wrong version when it helps.** "Without this, the timer would freeze at 1" is clearer than explaining why the right version works.

## What to skip

- Stuff they already know — if they understand useState, don't explain it again when showing useEffect
- Syntax — they can read code, they need the *why* and the *structure*
- Most of the file — it's details they'd look up. Only the chunks and the key decision matter.

## When this is NOT the right skill

- If the user is building something and wants to learn as they go → use mentor-mode
- If they just want a quick answer ("what does this function return") → just answer, don't run the full flow
