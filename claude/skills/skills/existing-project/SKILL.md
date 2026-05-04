---
name: existing-project
description: Use when adding project structure and rules to an existing codebase that has no CLAUDE.md or AGENTS.md
---

# Existing Project Setup

Audits an existing codebase and scaffolds CLAUDE.md, AGENTS.md, and docs/plan.md.

## Process

### Step 1: Audit

Read the codebase before writing anything:
- What frameworks, libraries, tools are in use (check package.json, config files)
- What commands exist (check scripts in package.json)
- What file organization exists (ls the directory tree)
- What testing is set up (test config, existing test files)
- What patterns are already used (naming, state management, styling)
- What's broken or missing (failing tests, TODO comments, missing configs)

### Step 2: Ask

Confirm with the user:
1. Is the audit accurate? Anything I missed?
2. Any working rules they want enforced?
3. Any design preferences?

### Step 3: Create Files

#### CLAUDE.md (project root, auto-read by Claude Code)

Based on audit, not guessing. Keep under 80 lines.

Must include:
- What the project does (from audit)
- Current state (from audit — what works, what doesn't)
- Tech stack and commands (from package.json)
- `@AGENTS.md` — import for all coding conventions
- Before starting any session: read plan, follow AGENTS.md rules

#### AGENTS.md (project root, imported by CLAUDE.md)

Conventions based on patterns found in the codebase. Keep under 100 lines.

Must include:
- Working rules (explain first, one logical unit per response, commit after each feature, answer questions, DRY)
- Code style (from existing patterns — don't invent new conventions)
- Testing approach (from what's already set up)
- File organization (map what actually exists)
- Git conventions (from commit history patterns)
- Anti-patterns and preferences

#### docs/plan.md

- What's broken (from audit)
- What's missing (from audit)
- Phased plan with checkboxes

## Rules

- Audit first, write second. Never guess.
- CLAUDE.md = project context + imports. AGENTS.md = coding rules. No overlap.
- Respect existing conventions — don't force new patterns on an established codebase
- No fluff
