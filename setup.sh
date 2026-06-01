#!/usr/bin/env bash
#
# One-time setup for the /img command.
# Stores your Pexels (and optional Pixabay) API key in your shell profile.
#
# Your key is typed with hidden input and written only to a local file on your
# own machine. It is never entered into an AI chat session and never committed.

set -euo pipefail

# Pick the right shell profile.
case "${SHELL##*/}" in
  bash) profile="$HOME/.bashrc" ;;
  *)    profile="$HOME/.zshrc" ;;
esac
touch "$profile"

save_key() {
  # $1 = variable name, $2 = label, $3 = signup url
  local name="$1" label="$2" url="$3" value
  printf 'Get a free %s key at: %s\n' "$label" "$url"
  read -rs -p "Paste your $label key (hidden, press Enter to skip): " value
  echo
  if [ -z "$value" ]; then
    printf 'Skipped %s.\n\n' "$label"
    return 0
  fi
  # Replace any existing definition, then append the new one.
  if grep -q "^export ${name}=" "$profile" 2>/dev/null; then
    grep -v "^export ${name}=" "$profile" > "${profile}.tmp" && mv "${profile}.tmp" "$profile"
  fi
  printf '\nexport %s="%s"\n' "$name" "$value" >> "$profile"
  printf 'Saved %s to %s\n\n' "$label" "$profile"
}

echo "Setting up /img. Your keys are stored only on this machine."
echo

save_key PEXELS_API_KEY  "Pexels"  "https://www.pexels.com/api/"
save_key PIXABAY_API_KEY "Pixabay (optional, for illustrations and vectors)" "https://pixabay.com/api/docs/"

echo "Done. Open a new terminal, or run:  source $profile"
