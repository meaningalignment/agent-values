#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_TARGET="${OPENCLAW_SKILLS_DIR:-/root/.openclaw/workspace/skills}"
VALUES_TARGET="${AGENT_VALUES_DIR:-${HOME}/.openclaw/values}"
USER_MD_PATH="${OPENCLAW_USER_MD_PATH:-/root/.openclaw/workspace/USER.md}"

ELICIT_SRC="${REPO_DIR}/skills/values-elicit"
CONSULT_SRC="${REPO_DIR}/skills/values-consult"
BUILD_SRC="${ELICIT_SRC}/scripts/build-values.ts"

VALUES_USER_MD_SNIPPET=$(cat <<'EOF'
## Values

The user's articulated values cards live at `~/.openclaw/values/VALUES.md`.
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
stances. If multiple cards apply and pull in different directions, surface
the tension. If no card clearly applies, ask rather than guess.
EOF
)

echo "Installing from: ${REPO_DIR}"
echo "Skills target: ${SKILLS_TARGET}"
echo "Values target: ${VALUES_TARGET}"

mkdir -p "${SKILLS_TARGET}/values-elicit" \
         "${SKILLS_TARGET}/values-consult" \
         "${VALUES_TARGET}/cards" \
         "${VALUES_TARGET}/transcripts"

cp "${ELICIT_SRC}/SKILL.md" "${SKILLS_TARGET}/values-elicit/SKILL.md"
cp -R "${ELICIT_SRC}/scripts" "${SKILLS_TARGET}/values-elicit/"
cp "${CONSULT_SRC}/SKILL.md" "${SKILLS_TARGET}/values-consult/SKILL.md"
cp "${BUILD_SRC}" "${VALUES_TARGET}/build.ts"

if [ ! -f "${VALUES_TARGET}/VALUES.md" ]; then
  cat > "${VALUES_TARGET}/VALUES.md" <<'EOF'
# User's Values

This file is generated from the cards directory. Do not edit directly.
EOF
fi

echo
echo "Installed skills:"
echo "  ${SKILLS_TARGET}/values-elicit/SKILL.md"
echo "  ${SKILLS_TARGET}/values-elicit/scripts/build-values.ts"
echo "  ${SKILLS_TARGET}/values-consult/SKILL.md"
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
echo "  2. Run /values_elicit or /values_consult"
