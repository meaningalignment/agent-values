#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_TARGET="${OPENCLAW_SKILLS_DIR:-/root/.openclaw/workspace/skills}"
VALUES_TARGET="${AGENT_VALUES_DIR:-${HOME}/.openclaw/values}"
USER_MD_PATH="${OPENCLAW_USER_MD_PATH:-/root/.openclaw/workspace/USER.md}"

ELICIT_SRC="${REPO_DIR}/skills/values-elicit"
BUILD_SRC="${ELICIT_SRC}/scripts/build-values.ts"

VALUES_USER_MD_SNIPPET=$(cat <<'EOF'
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
EOF
)

echo "Installing from: ${REPO_DIR}"
echo "Skills target: ${SKILLS_TARGET}"
echo "Values target: ${VALUES_TARGET}"

mkdir -p "${SKILLS_TARGET}/values-elicit" \
         "${VALUES_TARGET}/cards" \
         "${VALUES_TARGET}/transcripts"

cp "${ELICIT_SRC}/SKILL.md" "${SKILLS_TARGET}/values-elicit/SKILL.md"
cp -R "${ELICIT_SRC}/scripts" "${SKILLS_TARGET}/values-elicit/"
cp -R "${ELICIT_SRC}/references" "${SKILLS_TARGET}/values-elicit/"
cp "${BUILD_SRC}" "${VALUES_TARGET}/build.ts"

if [ ! -f "${VALUES_TARGET}/VALUES.md" ]; then
  # Generate the canonical VALUES.md (with meta header) by running build.ts.
  node "${VALUES_TARGET}/build.ts" >/dev/null
fi

echo
echo "Installed skill:"
echo "  ${SKILLS_TARGET}/values-elicit/SKILL.md"
echo "  ${SKILLS_TARGET}/values-elicit/references/"
echo "  ${SKILLS_TARGET}/values-elicit/scripts/build-values.ts"
echo "Installed values runtime:"
echo "  ${VALUES_TARGET}/build.ts"
echo "  ${VALUES_TARGET}/VALUES.md"
echo "  ${VALUES_TARGET}/cards/"
echo "  ${VALUES_TARGET}/transcripts/"

if [ -f "${USER_MD_PATH}" ]; then
  if ! grep -q "~/.openclaw/values/VALUES.md" "${USER_MD_PATH}"; then
    echo
    echo "Recommended USER.md addition (not applied automatically):"
    echo
    printf '%s\n' "${VALUES_USER_MD_SNIPPET}"
    echo
    echo "Suggested target file: ${USER_MD_PATH}"
  fi
else
  echo
  echo "No USER.md found at ${USER_MD_PATH}."
  echo "If your setup uses a USER.md profile file, consider adding this section:"
  echo
  printf '%s\n' "${VALUES_USER_MD_SNIPPET}"
fi

echo
echo "Next steps:"
echo "  1. Restart OpenClaw if needed"
echo "  2. Run /values to articulate a value"
