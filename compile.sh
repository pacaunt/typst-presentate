#!/bin/bash
echo "🎬 Compiling Typst Presentate..."
cd "$(dirname "$0")"

# Docs
typst compile --root .. assets/manual/themes-guide.typ

# Examples
echo "\n--- Compiling Examples ---"
for file in assets/examples/features/*.typ; do
    name=$(basename "$file" .pdf)
    echo "$name compiling..."
    [ -f "$file" ] && typst compile --root .. "$file"
done

for file in assets/examples/themes/*.typ; do
    name=$(basename "$file" .pdf)
    echo "$name compiling..."
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
echo "\n--- Compiling Tests ---"
for file in assets/tests/*.typ; do
    name=$(basename "$file" .pdf)
    echo "$name compiling..."
    [ -f "$file" ] && typst compile --root .. "$file"
done

# Manuals 
echo "\n--- Compiling Manual ---"
for file in assets/manual/img/*.typ; do
    name=$(basename "$file" .pdf)
    echo "$name compiling..."
    [ -f "$file" ] && typst compile --root ../.. "$file"
done

for file in assets/manual/*.typ; do
    name=$(basename "$file" .pdf)
    echo "$name compiling..."
    [ -f "$file" ] && typst compile --root .. "$file"
done