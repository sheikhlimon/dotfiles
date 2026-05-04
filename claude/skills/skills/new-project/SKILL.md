---
name: new-project
description: Use when starting a brand new project from scratch and needing project structure, rules, and documentation files generated
---

# New Project Setup

Scaffolds CLAUDE.md, AGENTS.md, docs/design.md, and docs/plan.md for a new project.

## Required Inputs

Ask the user for:
1. **Project description** — what it does in 1-2 sentences
2. **Tech stack** — frameworks, libraries, tools
3. **Package manager** — default to pnpm if unspecified

## Files to Create

### 1. CLAUDE.md (project root, auto-read by Claude Code)

Project context file. Keep under 80 lines.

Must include:
- Project description and current state
- Tech stack summary
- Commands (dev, test, build, lint)
- `@AGENTS.md` — import for all coding conventions
- Before starting any session: read plan, follow AGENTS.md rules
- Design aesthetic (ask user, or use defaults below)

Default aesthetic if unspecified:
- CSS variables/tokens, no arbitrary colors
- cn() for conditional class merging
- Avoid: generic blue/indigo, same radius everywhere, gradient backgrounds, template nav bars
- Prefer: asymmetric layouts, mixed border radii, dark mode, micro-interactions

### 2. AGENTS.md (project root, imported by CLAUDE.md)

All coding conventions. No overlap with CLAUDE.md. Keep under 100 lines.

Must include:
- Working rules (explain first, one logical unit per response, commit after each feature, answer questions, DRY)
- Code style (TypeScript, comments explain WHY not WHAT, no JSDoc unless public API, CSS variables, cn())
- Testing approach (adapt to user's stack — Vitest, Jest, etc.)
- File organization (generate from tech stack)
- Git conventions (conventional commits, one change per commit)
- Anti-patterns (generic blue/indigo, same radius everywhere, gradients, template nav)
- Preferences (asymmetric layouts, mixed radii, dark mode, micro-interactions)

### 3. docs/design.md

Ask user about design vision, then document:
- Layout architecture
- Color scheme (CSS variables, light/dark)
- Typography scale
- Component inventory
- Interaction states (hover, active, focus, disabled, loading)

### 4. docs/plan.md

Phased implementation with checkboxes. Commit sequence: one commit per checkbox.

## Rules

- CLAUDE.md = project context + imports. AGENTS.md = coding rules. No overlap.
- Adapt testing, file org, and commands to the actual tech stack — don't assume React/Express
- No fluff, no filler paragraphs
- Keep both files concise
