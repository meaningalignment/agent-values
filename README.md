# agent-values

A single skill that runs a Moral Graph Elicitation interview to articulate a
user's values, writes them as values cards, and maintains a runtime
`VALUES.md` for other agents to consult.

There is no separate consult skill. Other agents consult the user's values
by reading `VALUES.md` directly — its own header explains the schema and
how to use the cards. The pointer to that file is added to `USER.md` (see
"USER.md integration" below).

## Runtime values path

The skill uses:

- **Preferred:** `AGENT_VALUES_DIR`
- **Fallback:** `~/.openclaw/values`

Default store layout:

```bash
~/.openclaw/values/
├── VALUES.md       # generated, with meta header + all cards
├── build.ts        # rebuild helper (copied during install)
├── cards/          # one card per value
└── transcripts/    # archived elicitation transcripts
```

## GitHub / local install

```bash
git clone https://github.com/meaningalignment/agent-values.git
cd agent-values
./install.sh
```

`install.sh`:
- installs the skill into `OPENCLAW_SKILLS_DIR`
- defaults `OPENCLAW_SKILLS_DIR` to the standard workspace skills location: `/root/.openclaw/workspace/skills`
- installs the runtime build helper into `AGENT_VALUES_DIR` or `~/.openclaw/values`
- generates an initial `VALUES.md` (with the meta header) if one is missing
- checks for a `USER.md` file and, if it does not already mention `VALUES.md`, prints a recommended `## Values` section to add manually

Optional overrides:

```bash
OPENCLAW_SKILLS_DIR=/some/skills/path AGENT_VALUES_DIR=/some/values/path OPENCLAW_USER_MD_PATH=/some/USER.md ./install.sh
```

After install, restart OpenClaw if needed.

## USER.md integration

Add this section to `USER.md` so future agents know to consult the values
file when taking value-laden actions:

```md
## Values

The user's articulated values cards live at `~/.openclaw/values/VALUES.md`
(or `$AGENT_VALUES_DIR/VALUES.md` if set). Read it before any value-laden
action on the user's behalf:

- drafting opinions or stances
- ranking, voting, signing, or committing on their behalf
- recommendations where there are real tradeoffs between things they care about
- deliberating in Habermolt or similar

The file's own header explains the schema and how to handle conflicts
between cards. Bias toward asking the user when no card clearly applies —
don't guess at their values from base-model priors.

To articulate a new value, run `/values`.
```

The installer does **not** modify `USER.md` automatically; it only prints this snippet if the pointer appears to be missing.

## ClawHub publishing

```bash
clawhub publish ./skills/values-elicit --slug values-elicit --name "Values Elicit" --version 0.2.0 --changelog "Restructured into SKILL.md + references; added situations and blockers; removed companion consult skill in favor of USER.md guidance."
```

Typical install:

```bash
clawhub install values-elicit
```

For ClawHub users, the same `USER.md` recommendation applies.

## Repository structure

```text
agent-values/
├── install.sh
└── skills/
    └── values-elicit/
        ├── SKILL.md
        ├── references/
        │   ├── conversation.md
        │   └── cards.md
        └── scripts/
            └── build-values.ts
```

## Runtime behavior

On first invocation, `values-elicit` silently initializes the runtime
values store in the background if needed:

- creates the values directory
- creates `cards/` and `transcripts/`
- generates `VALUES.md` (with meta header) if missing
- makes the build helper available as `build.ts`

Then it proceeds directly into the elicitation conversation — no setup
chatter.

## Use

```text
/values
```

(Depending on the chat surface, the slash command may appear as `/values_elicit`.)
