# agent-values

Two related skills for building and consulting a user's elicited values.

- **`values-elicit`** — runs a Moral Graph Elicitation interview, creates and maintains the runtime values store, writes value cards, archives transcripts, and rebuilds `VALUES.md`.
- **`values-consult`** — reads `VALUES.md` when the agent is about to take a value-laden stance, recommendation, or action on the user's behalf.

Designed for OpenClaw/ClawHub-style skill installation.

## Recommended shape

This repo is best treated as a **two-skill suite** with one shared runtime values store.

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

That directory should contain runtime state such as:

- `cards/`
- `transcripts/`
- `VALUES.md`
- `build.ts`

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

## Repository structure

```text
agent-values/
└── skills/
    ├── values-elicit/
    │   ├── SKILL.md
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
