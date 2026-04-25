#!/bin/bash
echo "🎬 Compiling Typst Presentate..."
cd "$(dirname "$0")"

# Docs
typst compile --root .. assets/manual/themes-guide.typ

# Examples
for file in assets/examples/*.typ; do
    [ -f "$file" ] && typst compile --root .. "$file"
done

# Tests
for file in assets/tests/*.typ; do
    [ -f "$file" ] && typst compile --root .. "$file"
done
