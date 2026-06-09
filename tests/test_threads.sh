#!/usr/bin/env bash
set -euo pipefail
BURN="$(cd "$(dirname "$0")/.." && pwd)/bin/burn"
pass() { printf '  ✓ %s\n' "$1"; }
fail() { printf '  ✗ %s: %s\n' "$1" "$2"; exit 1; }
check_error() {
  local desc="$1" pattern="$2"; shift 2
  local out; out=$("$BURN" "$@" 2>&1) && fail "$desc" "expected non-zero exit" || true
  [[ "$out" =~ $pattern ]] && pass "$desc" || fail "$desc" "wrong error: $out"
}

check_error "--threads 0 rejected"       "must be a positive integer" 10000 --threads 0
check_error "--threads -1 rejected"      "must be a positive integer" 10000 --threads -1
check_error "--threads abc rejected"     "must be a positive integer" 10000 --threads abc
check_error "--threads missing value"    "requires a value"           10000 --threads
check_error "--threads=0 rejected"       "must be a positive integer" 10000 --threads=0
echo; echo "All argument validation tests passed."
