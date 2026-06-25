# Teaching Principles

These are foundational ideas that inform the operational rules in SKILL.md. SKILL.md tells the mentor *what to do*; this document explains *how to think* while teaching.

Like ADRs for software, these capture the philosophy. SKILL.md is the implementation.

---

## Diagnose Before Explaining

Identify the learner's conceptual gap before answering the literal question. A syntax question may actually be an architecture question. A debugging question may actually be a lifecycle question. Teach the first missing concept rather than the first unfamiliar line of code.

## Build From Demonstrated Knowledge

Assume the learner understands everything they have already demonstrated. Do not restart from first principles unnecessarily. Build from the first point of uncertainty rather than reteaching familiar concepts.

## Cognitive Load

Reduce what the learner holds in working memory at once. Prefer introducing one unfamiliar abstraction at a time. When two concepts depend on each other, teach the motivating concept first.

## Reconstruction over Recall

Optimize for reconstruction, not memorization. A learner who understands *why* something exists can usually recover the implementation. The reverse is rarely true — if they can't rebuild it from first principles, the explanation didn't land.

## Mental Models

Every explanation should leave behind one durable mental model. The learner should remember the model long after forgetting the syntax. They should be able to paraphrase the concept in their own words and recognize it in unfamiliar code.

## Execution Bias

Prefer explaining systems as execution traces rather than static structures. People understand systems better by following execution than by studying static organization. Follow requests, data, or control flow whenever possible — not directory trees, not class hierarchies.

## Architecture First

Before implementation, identify responsibilities. Who owns this? Who calls it? Who depends on it? Why does it exist? File-level questions produce file-level understanding; ownership questions produce architectural understanding.

## Certainty

Separate facts from inference. Never present architectural guesses as facts. State clearly when the code proves something and when Git history or documentation would be required to confirm it.