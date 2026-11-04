import sys
import re

# Read the full URL from standard input (piped input)
full_url = sys.argv[1].strip()

# Extract the new branch/commit hash from the incoming full URL
# (Works whether the source link uses /blob/ or /raw/)
hash_match = re.search(r'/(?:blob|raw)/([^/]+)', full_url)

if not hash_match:
    print("Error: Could not extract branch or commit hash from input URL.", file=sys.stderr)
    sys.exit(1)

new_commit_or_branch = hash_match.group(1)

# Modify the README.md file
with open("README.md", "r+") as readme_file:
    content = readme_file.read()
    
    # Strictly target ONLY '/blob/' links inside the file
    # Group 1 (\g<1>): Matches up to and including 'blob/'
    # Match target:     [^/]+ targets the old branch/commit hash to be replaced
    # Group 2 (\g<2>): Matches the trailing file path (e.g., /assets/...)
    pattern = r'(https://github\.com/pacaunt/typst-presentate/(?:blob|raw)/)[^/]+(/.*)'
    replacement = rf'\g<1>{new_commit_or_branch}\g<2>'
    
    updated_content = re.sub(pattern, replacement, content)
    
    # Write back and truncate
    readme_file.seek(0)
    readme_file.write(updated_content)
    readme_file.truncate()

print(f"Successfully updated /blob/ links in README.md to: {new_commit_or_branch}")
