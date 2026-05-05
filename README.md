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

## Install

You need [bun](https://bun.sh) on your `PATH` (the build script is one file
of TypeScript).

```bash
git clone https://github.com/<you>/agent-values.git
cd agent-values
./install.sh
```

That's it. The script copies the skills to `~/.agents/skills/` and the
build script to `~/.agents/values/`, creating empty `cards/` and
`transcripts/` directories.

Then restart your agent gateway so it picks up the new skills:

```bash
openclaw gateway restart
```

Verify they loaded:

```bash
openclaw skills list | grep values
```

## Use

**Run an elicitation:**

```
/values
```

The agent will walk you through a 10-30 minute conversation about something
that matters to you, draft a values card, and write it to
`~/.agents/values/cards/<slug>.md`. The full transcript is archived to
`~/.agents/values/transcripts/`.

**Consult automatically:** there's nothing to do. `values-consult` is
model-invoked — when your agent is about to make a value-laden choice, it
reads `~/.agents/values/VALUES.md` and decides whether to act, surface a
tension between cards, or ask you.

## Layout

```
~/.agents/
├── values/
│   ├── cards/             one markdown file per value (source of truth)
│   ├── transcripts/       full elicitation transcripts, archived per card
│   ├── VALUES.md          generated; concatenation of all cards
│   └── build.ts           regenerates VALUES.md from cards/
└── skills/
    ├── values-elicit/SKILL.md
    └── values-consult/SKILL.md
```

`VALUES.md` is regenerated automatically at the end of each elicitation.
You can also rebuild it manually:

```bash
bun ~/.agents/values/build.ts
```

## Updating

```bash
cd agent-values
git pull
./install.sh
```

Re-running `install.sh` overwrites the skills and `build.ts` but preserves
your existing cards, transcripts, and `VALUES.md`.

## Uninstall

```bash
rm -rf ~/.agents/skills/values-elicit ~/.agents/skills/values-consult
```

Your cards stay in `~/.agents/values/` until you delete them.
