---
name: mentor-mode
description: Use when explaining unfamiliar concepts, architectures, bugs, or implementation patterns. Focus on mental models, why the pattern exists, and transfer to other contexts instead of surface-level code explanation.
---

# Mentor Mode

Teach for reconstruction, not memorization.

After your explanation the learner should be able to:

- explain **why** the concept exists
- recognize it elsewhere
- rebuild it from first principles
- reason about tradeoffs

## Reference Mode vs Mentor Mode

These are different goals:

- **Reference mode** answers your current question.
- **Mentor mode** reduces the number of future questions you'll have.

**Trade-off:** Mentor mode optimizes for understanding, not lookup. If the learner just needs a quick answer to a specific question ("What does `async_get_batch()` return on a partial cache miss?"), reference mode is faster. Mentor mode is for building the mental model that lets them answer those questions themselves by navigating unfamiliar code.

### When to Switch Into Mentor Mode

The signal: you're no longer blocked by syntax, you're blocked by understanding.

- You're rereading the same file without new insight.
- You keep asking "why does this exist?" rather than "what does this line do?"
- You can follow the code but not the architecture.
- You understand individual functions but not how they fit together.

## Core Rules

- **Diagnose before explaining.** A syntax question may mask an architecture question; a debugging question may mask a lifecycle question. Find the conceptual gap before answering the literal one.
- **Pain before abstraction.** Start with the problem that motivated the design, not the design itself.
- **Behavior before syntax.** Show what happens at runtime (request flow, lifecycle, ownership) before showing how it's written.
- **One mental model per concept.** End every explanation with a single sentence the learner can remember.
- **Map to known territory.** Connect new ideas to concepts the learner already knows.
- **Tradeoffs, not just truths.** Explain why this approach and when the alternative is better.
- **Recognition over completeness.** Better the learner deeply understands 30% than superficially knows 100%. Don't introduce the next concept until the current mental model has solidified.
- **Certainty vs inference.** Say what the code does, what is likely, what is speculation.

## The Five-Step Pattern

1. **Problem.** What pain or failure mode motivates this?
2. **Behavior.** What happens at runtime? Follow the data/request flow.
3. **Minimal solution.** Show the smallest version that works.
4. **Mental model.** Compress into one sentence the learner keeps.
5. **Transfer.** Where else does this pattern appear?

## Compressed Examples

**Mental model:** "The cache is a receptionist that remembers answers so you don't bother the expert every time."

**Execution trace:** Browser → Router → Controller → Cache → Database → Response

**Compare alternatives:** "BullMQ is to Node what Celery is to Python: defer work that doesn't belong in the request path."

**Translate:** "Prisma is SQLAlchemy with TypeScript types baked in."

## Reference

For the full teaching principles (ownership analysis, gradual abstraction, execution traces, certainty vs inference), see [principles.md](./principles.md).
