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

## Package vs runtime state

This repo contains the **portable skill package** only.

Your actual values data lives in a separate **runtime values store** outside
this repo. That includes:

- value cards
- transcripts
- generated `VALUES.md`
- the installed `build.ts`

That is the intended shape. The repo should not contain live values data or
template cards/transcripts.

## Runtime values path

The skills use this path convention:

- **Preferred:** `AGENT_VALUES_DIR`
- **Fallback:** `~/.openclaw/values`

So if `AGENT_VALUES_DIR` is unset, runtime state lives under:

```bash
~/.openclaw/values
```

## Install

For local OpenClaw testing:

```bash
git clone https://github.com/meaningalignment/agent-values.git
cd agent-values
./install.sh
openclaw gateway restart
```

What `install.sh` does:
- installs the skills into the local OpenClaw skills directory
- creates the runtime values directory if needed
- installs `build.ts` into the runtime values directory
- creates a minimal `VALUES.md` if missing
- preserves existing cards/transcripts/`VALUES.md`

By default, `install.sh` uses:

- skills: `/root/.openclaw/workspace/.openclaw/skills/`
- values runtime: `~/.openclaw/values`

If you want a different runtime values location:

```bash
AGENT_VALUES_DIR=/some/other/path ./install.sh
```

## ClawHub publish/install path

The portable payload is the `skills/` directory.

Typical publish flow:

```bash
clawhub publish ./skills/values-elicit --slug values-elicit --name "Values Elicit" --version 0.1.0 --changelog "Initial release"
clawhub publish ./skills/values-consult --slug values-consult --name "Values Consult" --version 0.1.0 --changelog "Initial release"
```

ClawHub publishes individual skill folders, so this repo currently maps most
cleanly to **two published skills**.

Typical install flow after publishing:

```bash
clawhub install values-elicit
clawhub install values-consult
```

## Repository structure

```text
agent-values/
├── skills/
│   ├── values-elicit/
│   │   └── SKILL.md
│   └── values-consult/
│       └── SKILL.md
├── values-build.ts
├── install.sh
└── clawhub.json
```

## Use

**Run an elicitation:**

```text
/values
```

Or just say:

```text
run values elicitation
```

If `AGENT_VALUES_DIR` is unset, the runtime outputs land here:

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
./install.sh
```

Re-running the installer overwrites the installed skill files and `build.ts`
but preserves your existing runtime values data.

## Uninstall

Remove the installed skills:

```bash
rm -rf /root/.openclaw/workspace/.openclaw/skills/values-elicit
rm -rf /root/.openclaw/workspace/.openclaw/skills/values-consult
```

Runtime values data is separate and remains until you delete it explicitly.
