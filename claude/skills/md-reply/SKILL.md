---
name: md-reply
description: Format responses as clean raw GitHub-flavored markdown for PR descriptions, issue comments, review replies, technical discussions, and OSS conversations.
---

# Markdown Reply

Format the response as raw GitHub-flavored markdown.

Maintain the tone and phrasing style of `collaborator-tone` unless the user requests otherwise.

## Rules

- Return ONLY the markdown output.
- Do not add explanations, introductions, or commentary.
- The output itself should already be valid markdown source.
- Keep formatting clean and scannable.
- Prefer short paragraphs and flat bullet lists.
- Use `-` for bullet lists.
- Use fenced code blocks with language tags.
- Use inline backticks for identifiers, filenames, functions, commands, and code references.
- Use markdown links: `[text](url)`

## Headers

- Use `##` only when structure improves readability.
- Avoid excessive heading nesting.
- Keep sections short and practical.

## PR Description Structure

```md
## What

Short summary.

## Why

Why the change is needed.

## How

Implementation summary.
```
