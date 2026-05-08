# agent-values

Two related skills for building and consulting a user's elicited values.

- **`values-elicit`** — runs a Moral Graph Elicitation interview, creates and maintains the runtime values store, writes value cards, archives transcripts, and rebuilds `VALUES.md`.
- **`values-consult`** — reads `VALUES.md` when the agent is about to take a value-laden stance, recommendation, or action on the user's behalf.

Designed for OpenClaw/ClawHub-style skill installation.

## Recommended shape

This repo is a **two-skill suite** with one shared runtime values store.

- `values-elicit` owns setup and maintenance of the store
- `values-consult` reads from the store
- both skills share the same runtime path convention

## Runtime values path

Both skills use:

- **Preferred:** `AGENT_VALUES_DIR`
- **Fallback:** `~/.openclaw/values`

So by default the live store is:

```bash
~/.openclaw/values
```

That directory contains runtime state such as:

- `cards/`
- `transcripts/`
- `VALUES.md`
- `build.ts`

## GitHub / local install

If someone is installing directly from GitHub rather than through ClawHub:

```bash
git clone https://github.com/meaningalignment/agent-values.git
cd agent-values
./install.sh
```

`install.sh`:
- installs the two skills into `OPENCLAW_SKILLS_DIR`
- defaults `OPENCLAW_SKILLS_DIR` to the standard workspace skills location: `/root/.openclaw/workspace/skills`
- installs the runtime build helper into `AGENT_VALUES_DIR` or `~/.openclaw/values`
- creates a minimal `VALUES.md` if missing
- checks for a `USER.md` file and, if it does not already mention `VALUES.md`, prints a recommended `## Values` section to add manually

Optional overrides:

```bash
OPENCLAW_SKILLS_DIR=/some/skills/path AGENT_VALUES_DIR=/some/values/path OPENCLAW_USER_MD_PATH=/some/USER.md ./install.sh
```

After install, restart OpenClaw if needed.

## Recommended USER.md integration

For best results, `USER.md` should include a pointer to the canonical values file.

Suggested section:

```md
## Values

The user's articulated values cards live at `~/.openclaw/values/VALUES.md`.
Each card captures a way of living the user finds intrinsically meaningful,
anchored in a specific moment (the story), explained in prose (what this
is), and operationalized as discernment criteria for recognizing the value
in the moment of choice (what I pay attention to).

The file may be incomplete — absence isn't evidence the user doesn't care
about something. And cards are situation-bound: the user's value about
honesty in technical work is not the same value as honesty in close
relationships, even when both mention honesty. Match the card's
situations and tags rather than extrapolating across them.

Consult VALUES.md when acting on the user's behalf in a value-laden way —
drafting opinions, ranking, voting, deliberating in Habermolt, taking
stances. If multiple cards apply and pull in different directions, surface
the tension. If no card clearly applies, ask rather than guess.
```

The installer does **not** modify `USER.md` automatically; it only prints this recommendation if the pointer appears to be missing.

## ClawHub publishing

Publish the two skill folders separately:

```bash
clawhub publish ./skills/values-elicit --slug values-elicit --name "Values Elicit" --version 0.1.0 --changelog "Initial release"
clawhub publish ./skills/values-consult --slug values-consult --name "Values Consult" --version 0.1.0 --changelog "Initial release"
```

Typical install flow:

```bash
clawhub install values-elicit
clawhub install values-consult
```

For ClawHub users, the same `USER.md` recommendation applies: add the `## Values` section manually so future agents know to consult `~/.openclaw/values/VALUES.md` when acting in value-laden ways.

## Repository structure

```text
agent-values/
├── install.sh
└── skills/
    ├── values-elicit/
    │   ├── SKILL.md
    │   ├── references/
    │   │   ├── conversation.md
    │   │   └── cards.md
    │   └── scripts/
    │       └── build-values.ts
    └── values-consult/
        └── SKILL.md
```

## Runtime behavior

### First run of `values-elicit`

On first invocation, `values-elicit` should silently initialize the runtime
values store in the background if needed:

- create the values directory
- create `cards/`
- create `transcripts/`
- create a minimal `VALUES.md` if missing
- make the build helper available as `build.ts`

Then it should proceed directly into the elicitation conversation without any
setup chatter.

### `values-consult` without prior elicitation

If no `VALUES.md` exists yet, `values-consult` should say so plainly and
suggest running `values-elicit` first.

## Use

Manual invocation examples:

```text
/values_elicit
/values_consult
```

Depending on the chat surface, dashed skill names may appear as underscored
slash commands.
