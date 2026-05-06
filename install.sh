#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_TARGET="${OPENCLAW_SKILLS_DIR:-/root/.openclaw/workspace/skills}"
VALUES_TARGET="${AGENT_VALUES_DIR:-${HOME}/.openclaw/values}"

ELICIT_SRC="${REPO_DIR}/skills/values-elicit"
CONSULT_SRC="${REPO_DIR}/skills/values-consult"
BUILD_SRC="${ELICIT_SRC}/scripts/build-values.ts"

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
echo
echo "Next steps:"
echo "  1. Restart OpenClaw if needed"
echo "  2. Run /values_elicit or /values_consult"
