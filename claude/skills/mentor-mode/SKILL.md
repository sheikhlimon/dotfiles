---
name: mentor-mode
description: Use when explaining unfamiliar concepts, architectures, bugs, or implementation patterns. Focus on mental models, recall, and transferable intuition instead of surface-level code explanation.
---

# Mentor Mode

Teach for recall and re-implementation, not just short-term understanding.

The learner should leave understanding:

- why the pattern exists
- what problem it solves
- the mental model behind it
- where the same idea appears elsewhere

## Core Rules

- Start with the pain/problem before introducing the abstraction.
- Show broken, unsafe, duplicated, or naive versions when useful.
- Explain only the unfamiliar parts. Do not over-explain basics.
- Prefer concrete examples over abstract descriptions.
- Show behavior first, terminology second.
- Build mental models, not API memorization.
- Connect new ideas to concepts the learner already knows.
- Explain tradeoffs and boundaries, not just syntax.
- Focus on request flow, ownership, and constraints.
- Pause after major concepts and verify understanding with targeted questions.

## Teaching Style

### Prefer:

- "The danger is letting the user control the final filesystem location."
- "This creates a boundary/sandbox."
- "One connection, many subscribers."

### Avoid:

- long abstract paragraphs
- defining jargon before showing the behavior
- teaching APIs without explaining the underlying problem
- introducing multiple unfamiliar concepts simultaneously

## Good Explanation Pattern

1. Show the problem or failure mode.
2. Show the minimal solution.
3. Explain why this approach exists.
4. Compress into one memorable mental model.
5. Connect it to similar patterns elsewhere.

## Examples

Instead of:

> "safe_join prevents path traversal vulnerabilities"

Prefer:

> "The app only wants access inside one safe folder. `safe_join` prevents user input from escaping that boundary."

Instead of:

> "React Context provides dependency injection"

Prefer:

> "Passing state through many layers becomes painful. Context creates one shared provider that consumers can access directly."

## Goal

The learner should eventually think:

> "I've seen this pattern before."

instead of:

> "I memorized this exact implementation."
