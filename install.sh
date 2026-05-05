#!/usr/bin/env bash
# Installs the values-elicit and values-consult skills into ~/.agents/.
# Safe to re-run: skips card/transcript/VALUES.md if they already exist.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${HOME}/.agents"

echo "Installing from: ${REPO_DIR}"
echo "Installing to:   ${TARGET}"

mkdir -p "${TARGET}/values/cards" \
         "${TARGET}/values/transcripts" \
         "${TARGET}/skills/values-elicit" \
         "${TARGET}/skills/values-consult"

# Skills always overwrite — they're the source of truth in the repo.
cp "${REPO_DIR}/skills/values-elicit/SKILL.md"   "${TARGET}/skills/values-elicit/SKILL.md"
cp "${REPO_DIR}/skills/values-consult/SKILL.md"  "${TARGET}/skills/values-consult/SKILL.md"
cp "${REPO_DIR}/values/build.ts"                 "${TARGET}/values/build.ts"

# Don't clobber an existing VALUES.md (user may have generated one already).
if [ ! -f "${TARGET}/values/VALUES.md" ]; then
  cp "${REPO_DIR}/values/VALUES.md" "${TARGET}/values/VALUES.md"
fi

echo
echo "Installed:"
echo "  ${TARGET}/skills/values-elicit/SKILL.md"
echo "  ${TARGET}/skills/values-consult/SKILL.md"
echo "  ${TARGET}/values/build.ts"
echo "  ${TARGET}/values/VALUES.md (preserved if existed)"
echo
echo "Next steps:"
echo "  1. Restart your agent gateway so it picks up the new skills."
echo "     (e.g. 'openclaw gateway restart')"
echo "  2. In a chat, run /values to start your first elicitation."
