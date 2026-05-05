# agent-values

Two skills that let your agent capture your values through guided interviews
and consult them when it's about to make a value-laden choice on your behalf.

- **`values-elicit`** — runs a Moral Graph Elicitation interview, writes a
  values card, archives the transcript, and rebuilds a consolidated
  `VALUES.md`. Triggers on `/values` or when the agent notices a moment
  worth capturing.
- **`values-consult`** — model-invoked. When the agent is about to take a
  stance, vote, draft on your behalf, or otherwise act on your values, it
  reads `VALUES.md` and either acts, surfaces a tension, or asks you.

Designed for [OpenClaw](https://openclaw.dev), but the skill files are plain
markdown — any agent harness that loads markdown skills should work.

## The split: package vs runtime state

This repo contains the **portable skill package**.

Your actual values data should live in a separate **runtime values store**.
That includes:

- value cards
- transcripts
- generated `VALUES.md`
- the local `build.ts` used to rebuild `VALUES.md`

This is the standard shape for a skill like this:
- skills/resources live in the package
- user data lives outside the package
- reinstalling or updating the skill does not overwrite the user’s values

## Runtime values path

The skills use this path convention:

- **Preferred:** `AGENT_VALUES_DIR`
- **Fallback:** `~/.openclaw/values`

So if `AGENT_VALUES_DIR` is unset, cards/transcripts/`VALUES.md` live under:

```bash
~/.openclaw/values
```

That gives you a portable default without hardcoding a machine-specific
workspace path.

## Install

### Local OpenClaw install (recommended first)

For local testing on this machine:

```bash
git clone https://github.com/meaningalignment/agent-values.git
cd agent-values
./install-openclaw-local.sh
openclaw gateway restart
```

What this does:
- installs the skills into the local OpenClaw skills directory
- installs the runtime values build scaffolding into `AGENT_VALUES_DIR`
  or `~/.openclaw/values`
- preserves existing cards/transcripts/`VALUES.md`

By default, `install-openclaw-local.sh` uses:

- skills: `/root/.openclaw/workspace/.openclaw/skills/`
- values runtime: `~/.openclaw/values`

If you want a different runtime values location:

```bash
AGENT_VALUES_DIR=/some/other/path ./install-openclaw-local.sh
```

### ClawHub publish/install path

This repo is structured so the portable payload is the `skills/` directory.
The local installer is just convenience glue for OpenClaw development.

Typical publish flow:

```bash
clawhub publish ./skills/values-elicit --slug values-elicit --name "Values Elicit" --version 0.1.0 --changelog "Initial release"
clawhub publish ./skills/values-consult --slug values-consult --name "Values Consult" --version 0.1.0 --changelog "Initial release"
```

ClawHub publishes individual skill folders, so this repo currently maps most
cleanly to **two published skills** rather than one monolithic package.

Typical install flow after publishing:

```bash
clawhub install values-elicit
clawhub install values-consult
```

### Legacy ~/.agents install

```bash
./install.sh
```

That installs the skill files into `~/.agents/skills/` and installs the
runtime values scaffolding into `AGENT_VALUES_DIR` or `~/.openclaw/values`.

## Repository structure

```text
agent-values/
├── skills/
│   ├── values-elicit/
│   │   └── SKILL.md
│   └── values-consult/
│       └── SKILL.md
├── values/
│   ├── build.ts
│   ├── VALUES.md
│   ├── cards/
│   └── transcripts/
├── install-openclaw-local.sh
├── install.sh
└── clawhub.json
```

Interpretation:
- `skills/` = portable skill package content
- `values/` = starter/runtime scaffolding shipped with the repo
- installed runtime data should live outside the repo

## Use

**Run an elicitation:**

```text
/values
```

Or just say something like:

```text
run values elicitation
```

The agent will walk you through a 10-30 minute conversation about something
that matters to you, draft a values card, and write it into the runtime
values store.

If `AGENT_VALUES_DIR` is unset, that means:

```bash
~/.openclaw/values/cards/<slug>.md
~/.openclaw/values/transcripts/<YYYY-MM-DD>-<slug>.md
~/.openclaw/values/VALUES.md
```

**Consult automatically:** `values-consult` is model-invoked — when your agent
is about to make a value-laden choice, it reads the configured `VALUES.md`
and decides whether to act, surface a tension between cards, or ask you.

## Rebuilding VALUES.md manually

```bash
node ~/.openclaw/values/build.ts
```

Or with an explicit runtime path:

```bash
AGENT_VALUES_DIR=/my/values node /my/values/build.ts
```

## Updating

```bash
cd agent-values
git pull
./install-openclaw-local.sh
```

Re-running the installer overwrites the skill files and `build.ts` but
preserves your existing cards, transcripts, and `VALUES.md`.

## Uninstall

Local OpenClaw skill uninstall:

```bash
rm -rf /root/.openclaw/workspace/.openclaw/skills/values-elicit
rm -rf /root/.openclaw/workspace/.openclaw/skills/values-consult
```

Legacy `~/.agents` skill uninstall:

```bash
rm -rf ~/.agents/skills/values-elicit ~/.agents/skills/values-consult
```

Runtime values data is separate and remains until you delete it explicitly.
