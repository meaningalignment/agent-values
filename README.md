# agent-values

A single skill that runs a Moral Graph Elicitation interview to articulate a
user's values, writes them as values cards, and maintains a runtime
`VALUES.md` for other agents to consult.

There is no separate consult skill. Other agents consult the user's values
by reading `VALUES.md` directly — its own header explains the schema and
how to use the cards. The pointer to that file is added to `USER.md` (see
"USER.md integration" below).

## Requirements

- `node` on `PATH` (used to rebuild `VALUES.md` from cards)

## Runtime values path

The skill uses:

- **Preferred:** `AGENT_VALUES_DIR` (optional override)
- **Default:** `~/.openclaw/values`

Default store layout:

```bash
~/.openclaw/values/
├── VALUES.md       # generated, with meta header + all cards
├── build.mjs       # rebuild helper (copied on first run)
├── cards/          # one card per value
└── transcripts/    # archived elicitation transcripts
```

The skill bootstraps this layout on first run — it creates the directory,
seeds `VALUES.md` if missing, and copies `scripts/build-values.mjs` into the
store as `build.mjs`.

## Install

```bash
clawhub install values-elicit
```

On first invocation, the skill prints a one-line summary of where the
values store landed and offers to append the values pointer to your
`USER.md` (looked up via `$OPENCLAW_USER_MD_PATH`, then
`~/.openclaw/workspace/USER.md`, then `~/.openclaw/USER.md`). After that
it goes straight into the elicitation; subsequent runs are silent.

## USER.md integration

The skill can append the snippet automatically on first run. The exact
text lives at `skills/values-elicit/references/USER_MD_SNIPPET.md`. If
you'd rather paste it manually, here it is so future agents know to
consult the values file both when taking value-laden actions and when
interpreting the user's values directly:

```md
## Values

The user's articulated values cards live at `~/.openclaw/values/VALUES.md`
(or `$AGENT_VALUES_DIR/VALUES.md` if set).
Each card captures a way of living the user finds intrinsically meaningful,
anchored in a specific moment (the story), explained in prose (what this
is), and operationalized as discernment criteria for recognizing the value
in the moment of choice (what I pay attention to).

The file may be incomplete — absence isn't evidence the user doesn't care
about something. And cards are context-bound: the user's value about
honesty in technical work is not the same value as honesty in close
relationships, even when both mention honesty. Match the card's contexts
rather than extrapolating across them.

Consult VALUES.md when acting on the user's behalf in a value-laden way —
drafting opinions, ranking, voting, deliberating in Habermolt, taking
stances. Also consult it when the user asks what they care about, what
they value, how they tend to decide, or asks for a summary/interpretation
of their values in a domain (for example community, work, relationships,
or politics). If multiple cards apply and pull in different directions,
surface the tension. If no card clearly applies, say so and ask rather
than guess.

To articulate a new value, run `/values`.
```

## ClawHub publishing

```bash
clawhub publish ./skills/values-elicit --slug values-elicit --name "Values Elicit" --version 0.2.0 --changelog "Declare node as a runtime requirement; clawhub-first install."
```

## Repository structure

```text
agent-values/
└── skills/
    └── values-elicit/
        ├── SKILL.md
        ├── references/
        │   ├── cards.md
        │   ├── conversation.md
        │   └── USER_MD_SNIPPET.md
        └── scripts/
            └── build-values.mjs
```

## Use

```text
/values
```

(Depending on the chat surface, the slash command may appear as `/values_elicit`.)
