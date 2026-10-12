#!/bin/bash
# Double-click on your Apple Silicon Mac to build a drag-and-drop application.
set -uo pipefail
# If Terminal is running under Rosetta on an Apple Silicon Mac, switch to the
# native ARM64 shell so the resulting app is built for Apple Silicon.
if [[ "$(uname -s)" == 'Darwin' && "$(uname -m)" != 'arm64' ]] &&     [[ "$(/usr/sbin/sysctl -n hw.optional.arm64 2>/dev/null || true)" == '1' ]]; then
  exec /usr/bin/arch -arm64 /bin/bash "$0" "$@"
fi
cd "$(dirname "$0")" || exit 1
/bin/bash mac/build_mac.sh
status=$?
echo
if [[ "$status" -eq 0 ]]; then
  echo 'SUCCESS: The macOS app and drag-and-drop DMG are in the dist folder.'
  command -v open >/dev/null 2>&1 && open "$PWD/dist"
else
  echo 'BUILD INCOMPLETE: See the reason above and run this file again after fixing it.'
fi
if [[ -t 0 ]]; then
  read -r -p 'Press Return to close this window… ' _ || true
fi
exit "$status"
