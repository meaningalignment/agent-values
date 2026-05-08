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
