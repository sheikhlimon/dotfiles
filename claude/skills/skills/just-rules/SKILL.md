---
name: just-rules
description: Use when wanting minimal project rules without design docs or implementation plans — just CLAUDE.md and AGENTS.md
---

# Just Rules

Creates CLAUDE.md and AGENTS.md only. No docs/, no plans, no design specs.

## Files to Create

### 1. CLAUDE.md (project root)

Project context file. Keep under 60 lines.

Must include:
- Project description (ask user)
- Tech stack and commands (ask user)
- `@AGENTS.md` — import for all coding conventions

### 2. AGENTS.md (project root)

All coding rules. Keep under 80 lines.

Must include:

```markdown
# AGENTS.md

## Working Rules
- EXPLAIN FIRST — explain WHAT and WHY before writing code
- ONE LOGICAL UNIT — one unit of work per response, one commit per unit
- COMMIT AFTER EACH FEATURE
- ANSWER QUESTIONS — pause and explain when asked
- DRY — extract shared logic

## Code Style
- Comments explain WHY not WHAT, no JSDoc unless public API
- Use CSS variables/tokens, no arbitrary colors
- Use cn() for conditional class merging
- No inline styles, use Tailwind classes

## Git
- Format: feat: one liner description
- One logical change per commit

## Anti-Patterns (Avoid)
- Generic blue/indigo everywhere
- Same border radius on everything
- Gradient backgrounds
- Template nav bars
- Bland "Welcome to..." headings
- Default shadows on all cards

## Prefer Instead
- Asymmetric layouts, mixed border radii
- Dark mode support
- Micro-interactions, skeleton loaders
- Personality over templates
```

## Rules

- CLAUDE.md = project context + imports. AGENTS.md = coding rules. No overlap.
- Adapt to user's actual stack — don't assume anything
- No fluff
