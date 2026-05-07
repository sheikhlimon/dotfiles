---
name: md-reply
description: Format replies in clean GitHub-flavored markdown — PR descriptions, issue comments, review replies. Natural tone, not AI-sounding.
---

Format the user's text as a markdown reply following these rules:

## Format rules

- Use GitHub-flavored markdown
- Use `##` headers sparingly — only for longer replies
- Use `###` or bold for short section labels if needed
- Bullet lists with `-` not `*`
- Code in backticks, code blocks with language tags
- Use en-dash (–) or em-dash (—) where natural
- No nested lists unless necessary — keep it flat
- Links as `[text](url)` not bare URLs

## Tone rules

- Same as casual-tone skill — natural, not AI-sounding
- Humble, curious, respectful, definite
- No filler, no hedging, no corporate language
- Tight and scannable — people skim on GitHub

## Structure

For PR descriptions:
```
## What
one-liner

## Why
one or two sentences

## How
brief technical summary
```

For comments/replies — just write it naturally in markdown, no template needed.

## Output

Return only the formatted markdown — no explanations, no commentary.
