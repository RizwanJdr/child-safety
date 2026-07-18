#!/bin/bash
cd "$(dirname "$0")/.."
if grep -r -n "sorry\|admit\|axiom\|unsafe\|partial" ChildSafety; then
  echo "Error: Found forbidden keywords (sorry, admit, axiom, unsafe, partial) in the Lean source."
  exit 1
else
  echo "Success: No forbidden keywords found."
  exit 0
fi
