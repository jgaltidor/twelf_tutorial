#!/bin/sh
# Check every proof with Twelf: load sources.cfg (the core files, in order),
# then the two test files, then each exercise file in a fresh signature
# (reset), since the exercises declare their own typ, of, etc.
# Exits non-zero if Twelf rejects anything.
set -e
cd "$(dirname "$0")"
out=$(twelf-server <<'CMDS'
make sources.cfg
loadFile test_typing.elf
loadFile progress_testing.elf
reset
loadFile exercises/numsubtype/numsubtype_starter.elf
reset
loadFile exercises/numsubtype/numsubtype_solution.elf
quit
CMDS
)
printf '%s\n' "$out"
if printf '%s\n' "$out" | grep -q '%% ABORT %%'; then
  echo "twelf-check: FAILED" >&2
  exit 1
fi
echo "twelf-check: all files OK"
