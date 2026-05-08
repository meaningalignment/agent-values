# Sources of Meaning, Attention Policies, and Card Format

## What a source of meaning is

A way of living that's intrinsically meaningful to me — not just something
I prefer or enjoy. More specific than words like "honesty" or
"authenticity"; it specifies a particular *kind* of honesty or authenticity
through what I pay attention to.

A source of meaning opens a space of possibility, rather than satisfying a
preference. It's constitutive of what I think a good life is — not
instrumental to some other goal.

## Attention policies — the format

Each policy is a precise thing I can actively orient my attention toward,
not an abstract value or an outcome. Format:

> **PLURAL_NOUN** + qualifier phrase

The all-caps plural noun names the kind of thing to attend to ("MOMENTS",
"SENSATIONS", "OPPORTUNITIES", "CHOICES", "PEOPLE"). The qualifier provides
the specifics.

Example, for a value about group decision-making:

```
- CHANGES in people when entrusted with the work of self-determination
- INSIGHTS that emerge through grappling with morally fraught questions
- CAPACITIES that develop when a person tries to be free and self-directed
- WISDOM that emerges in a discursive, responsible context
```

### Rules

1. **Constitutive, not instrumental.** Every policy must be something the
   user would attend to because *attending to it is part of living well*,
   not because it serves a separate goal. A driver tracking "DRIFTS of the
   car toward the lane line" is instrumental — they care about not
   crashing, full stop. "SENSATIONS in my body that tell me whether I'm
   following what I actually believe" is constitutive — attending to that
   just *is* part of what a good life is for this person. If unsure, ask
   the user: "if there were another way to get the underlying goal, would
   you still attend to this?" If they'd drop it, it's instrumental. If
   they'd keep attending to it anyway, it's constitutive.

   Other examples:
   - Constitutive: "MOMENTS when someone drops their professional persona"
   - Instrumental: "LEADS ACQUIRED at a networking event"
   - Constitutive: "FEELINGS of capacity in my body after a meal"
   - Instrumental: "MEALS with a low calorie count"

   A source of meaning whose policies are mostly instrumental is not a
   source of meaning — it's a strategy. Push back gently and re-ask.
2. **Precise, not vague.** I should be able to actively look for the thing.
   Good: "tension in someone's voice", "the rhythm of conversation",
   "instincts I'm tempted to override". Too vague: "the energy in a room",
   "moments of alignment", "presence" (present to what?), "connection"
   (connected how?).
3. **From the actor's perspective.** Read like instructions to someone
   trying to live this value. "SENSATIONS that point to misgivings I have
   about the current path."
4. **General words.** "strangers" not "customers". "objects" not "trees".
5. **No "meaningful" or synonyms ("deep", "profound").** Say more
   specifically what's worth attending to.
6. **Together they cohere.** 3-6 policies that fit as a single way of
   distinguishing quality in a domain — not a grab bag.

## Card format

Save to `$AGENT_VALUES_DIR/cards/<slug>.md` (or
`~/.openclaw/values/cards/<slug>.md` if unset).

```markdown
---
title: <Title>
elicited_at: <YYYY-MM-DD>
tags: [<kebab-case>, <kebab-case>]
---

## Story

<one-sentence first-person present-continuous moment>

## Where this shows up

- <In <natural-language situation>>
- <In <natural-language situation>>

## What this is

<2-4 paragraphs of explication>

## What I pay attention to

- <PLURAL_NOUN qualifier>
- <PLURAL_NOUN qualifier>

## What gets in the way

<one or two sentences>
```

### Frontmatter

- `title` — 2-5 words. Not cheesy. Distinguishes this from similar cards
  I might already have — check `cards/` for collisions before finalizing.
- `elicited_at` — today's ISO date.
- `tags` — 2-4 kebab-case shorthand tags for filtering
  (e.g. `[intellectuality, conversation, parenting]`).

### Story

The single-sentence moment that anchors this value.

- First person, present continuous, from my perspective.
- Describes the exact moment that felt meaningful — not the resulting
  feeling. ("...which made me feel deeply connected" — don't do this.)
- No names or sensitive PII. Replace names with "my mom", "my dad",
  "my friend", "someone I love", "someone I was talking to".
- Example: "Watching my mom lean over and kiss my dad on the forehead,
  beaming love and gratitude."

### Where this shows up

1-3 natural-language situations where this value comes up for me. These
are concrete, recognizable contexts — not categories.

- "In heated dinner conversations"
- "When a friend is half-formed about an idea"
- "Late at night, debugging alone"

### What this is

2-4 paragraphs of prose explicating the value. Written so a future
reader (a future me, another agent in a deliberation) can understand the
value without having been in the elicitation.

- Grounded in the story and the policies. Every claim should trace back.
- Says what the value is, what it's responding to, and what it isn't to
  be confused with.
- Defensive against likely misreadings. If "tending the quiet" could be
  confused with sentimentality, name that and rule it out.
- No abstract or ideological language. No "I value X" framings.

Don't show this prose in chat. Write it into the card; the user can read
it there if they want to.

### What I pay attention to

The 3-6 attention policies, formatted as above.

### What gets in the way

One or two sentences capturing the blocker the user named — what's
stopping them from living this more. Don't editorialize; just record what
they said, lightly cleaned up.
