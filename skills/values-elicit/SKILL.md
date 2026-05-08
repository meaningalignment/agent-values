---
name: values-elicit
description: Run a Moral Graph Elicitation interview when the user expresses a strong feeling, a goal, a norm, or a difficult choice in a way that suggests an underlying source of meaning worth capturing. Produces a values card stored in the configured values store. Also runnable as the /values slash command.
user-invocable: true
metadata: {"openclaw": {"emoji": "🪺"}}
---

# Values Elicitation

Help me articulate a "source of meaning" — a way of living I find
intrinsically meaningful — and write it as a values card in my values store.

## When to run

Run when:
- I invoke `/values`.
- I share a story, strong feeling, role model, difficult choice, or norm
  AND signal openness to going deeper. When in doubt, ask once.

Don't run when:
- I'm asking for code, facts, or a quick answer.
- I'm in flow on another task.
- The conversation is in a public/group channel — offer to move to DM.

## How to run

The interview has four stages. Read `references/conversation.md` for the
flow, brevity rules, and how to handle goals/feelings/norms.

1. **Surface** the source of meaning (1-3 exchanges).
2. **Draft and refine** 3-6 attention policies.
3. **Ask once** what gets in the way of living this.
4. **Confirm and write** title + situations, then save the card.

Read `references/cards.md` before drafting policies or writing the card.
It covers what a source of meaning is, how to write attention policies,
and the exact card format.

## Output

Values store path:
- Preferred: `$AGENT_VALUES_DIR`
- Fallback: `~/.openclaw/values`

Before writing anything, silently ensure these exist (no setup chatter):
- `$AGENT_VALUES_DIR/` (or `~/.openclaw/values/`)
- `cards/`
- `transcripts/`
- `VALUES.md` (create a minimal file if missing)

When the user confirms the card:

1. **Pick a slug.** Kebab-cased title. "Tending the Quiet" → `tending-the-quiet`.
2. **Write the card** to `cards/<slug>.md` using the format in `references/cards.md`.
3. **Write the transcript** to `transcripts/<YYYY-MM-DD>-<slug>.md` — plain
   markdown dump with `**Me:**` / `**Agent:**` turn markers.
4. **Rebuild VALUES.md** by running `node "$AGENT_VALUES_DIR/build.ts"`
   (or `node ~/.openclaw/values/build.ts` if unset). If the build helper
   isn't there yet, copy `scripts/build-values.ts` into the values store
   as `build.ts` first.
5. **Confirm** to me with the file path.

## What I'll see vs. what goes in the file

Don't show the explication ("What this is" prose) in chat — write it
directly into the card. I'll read it there if I want to.
Don't re-render the whole card after small refinements — show only what
changed. See `references/conversation.md` for brevity rules.
