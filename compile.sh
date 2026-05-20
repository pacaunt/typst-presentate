#!/bin/bash
echo "🎬 Compiling Typst Presentate..."
cd "$(dirname "$0")"

# Docs
typst compile --root .. assets/manual/themes-guide.typ

# Examples
for file in assets/examples/features/*.typ; do
    [ -f "$file" ] && typst compile --root .. "$file"
done

for file in assets/examples/themes/*.typ; do
    [ -f "$file" ] && typst compile --root .. "$file"
done

cd ./assets/examples/
for file in ./features/*.pdf; do 
    name=$(basename "$file" .pdf)
    echo "$name compiling..."
    typst compile --root ../.. examples.typ --input name="$file" --format=png --ppi 400 features/"$name".png
done
cd ../..

# Tests
for file in assets/tests/*.typ; do
    [ -f "$file" ] && typst compile --root .. "$file"
done
