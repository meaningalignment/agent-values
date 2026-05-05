---
name: values-consult
description: Consult the user's values when about to make a value-laden choice on their behalf. Use before authoring opinions, ranking statements, voting, drafting communications that take a stance, or any task where the right action depends on what the user cares about. Reads the configured values store.
user-invocable: false
metadata: {"openclaw": {"emoji": "🧭"}}
---

# Values Consultation

Use this skill when you're about to make a choice on the user's behalf that
depends on their values, not just on facts. Examples:

- Authoring or ranking statements in a Habermolt deliberation.
- Drafting a message that takes a stance on something contested.
- Making a recommendation when there are real tradeoffs between things
  the user cares about.
- Voting, signing, or committing to anything on their behalf.

## What to do

1. **Read `$AGENT_VALUES_DIR/VALUES.md`** in full (or `~/.openclaw/values/VALUES.md` if `AGENT_VALUES_DIR` is unset). This is a concatenation
   of the user's values cards. It's not long — read all of it.

2. **Identify which cards are relevant** to the task at hand. Often more
   than one will be. Pay attention to the contexts tag and the story —
   these are your strongest signals for whether a card applies. Don't
   over-rely on the title; titles are compressed.

3. **Check for tension between relevant cards.** Many real value-laden
   questions sit at the intersection of multiple values that pull in
   different directions. The honesty/tact tradeoff is a canonical
   example — relational care and epistemic clarity can both apply.

4. **Decide between three actions:**

   a. **Cards cohere → act on them.** If the relevant cards point in a
      consistent direction for this specific question, draft the response
      using them. Cite which cards informed your reasoning when you report
      back to the user.

   b. **Cards conflict → ask the user.** If two or more cards apply and
      pull in different directions, do NOT silently paper over the
      tension. Surface the conflict to the user: "I see your card on X and
      your card on Y, and they pull in different directions here. Which
      should dominate, or does it depend on something I'm missing?"

   c. **No card clearly applies → ask the user, and offer to elicit.**
      If nothing in VALUES.md is a good fit, tell him. Offer to run a
      values-elicit interview if the question is one he wants to think
      through more deeply. Don't extrapolate from loosely related cards.

5. **Bias toward asking.** The user would rather be interrupted than
   misrepresented. When in doubt, ask.

## What NOT to do

- Do not guess at the user's values from base-model priors. If VALUES.md
  doesn't cover it, say so.
- Do not treat attention policies as preferences. They are discernment
  criteria — they tell you what to look for in the moment of choice, not
  what the user "prefers" in the abstract.
- Do not flatten context-bound values into context-free principles.
  A person's value about honesty in technical work is not the same as their
  value about honesty in close relationships, even if both cards mention
  honesty.
- Do not surface VALUES.md content to third parties (e.g., other agents
  in a deliberation) verbatim. Use it to inform what you say; don't quote
  from it.
