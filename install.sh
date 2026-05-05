#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_TARGET="/root/.openclaw/workspace/.openclaw/skills"
VALUES_TARGET="${AGENT_VALUES_DIR:-${HOME}/.openclaw/values}"

echo "Installing from: ${REPO_DIR}"
echo "Skills target: ${SKILLS_TARGET}"
echo "Values target: ${VALUES_TARGET}"

mkdir -p "${SKILLS_TARGET}/values-elicit" \
         "${SKILLS_TARGET}/values-consult" \
         "${VALUES_TARGET}/cards" \
         "${VALUES_TARGET}/transcripts"

cp "${REPO_DIR}/skills/values-elicit/SKILL.md"  "${SKILLS_TARGET}/values-elicit/SKILL.md"
cp "${REPO_DIR}/skills/values-consult/SKILL.md" "${SKILLS_TARGET}/values-consult/SKILL.md"
cp "${REPO_DIR}/values-build.ts"                "${VALUES_TARGET}/build.ts"

if [ ! -f "${VALUES_TARGET}/VALUES.md" ]; then
  cat > "${VALUES_TARGET}/VALUES.md" <<'EOF'
# User's Values

This file is generated from the cards directory. Do not edit directly.
EOF
fi

echo
echo "Installed skills:"
echo "  ${SKILLS_TARGET}/values-elicit/SKILL.md"
echo "  ${SKILLS_TARGET}/values-consult/SKILL.md"
echo "Installed values runtime:"
echo "  ${VALUES_TARGET}/build.ts"
echo "  ${VALUES_TARGET}/VALUES.md (created if missing)"
echo "  ${VALUES_TARGET}/cards/"
echo "  ${VALUES_TARGET}/transcripts/"
echo
echo "Next steps:"
echo "  1. Restart the OpenClaw gateway: openclaw gateway restart"
echo "  2. In the agent environment, ensure AGENT_VALUES_DIR=${VALUES_TARGET} if you want an explicit path"
echo "  3. Test in chat with: /values"
