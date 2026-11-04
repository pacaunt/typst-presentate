import sys
import re

# Read the full URL from standard input (piped input)
full_url = sys.stdin.read().strip()

# Match everything from the start up to the commit hash/branch segment (ends right before 'assets/')
# This captures: https://github.com/pacaunt/typst-presentate/blob/[commit_hash_or_branch]
match = re.match(r'https://github\.com/[^/]+/[^/]+/[^/]+/[^/]+', full_url)

if not match:
    print("Error: Input does not look like a valid GitHub file URL.", file=sys.stderr)
    sys.exit(1)

new_url_prefix = match.group(0)

# Modify the README.md file
with open("README.md", "r+") as readme_file:
    content = readme_file.read()
    
    # Replace the old URL prefixes with the newly extracted base URL prefix
    updated_content = re.sub(
        r'https://github\.com/pacaunt/typst-presentate/blob/[^/]+', 
        new_url_prefix, 
        content
    )
    
    # Write back and truncate to ensure no leftover data if the new file is shorter
    readme_file.seek(0)
    readme_file.write(updated_content)
    readme_file.truncate()

print(f"Successfully updated README.md with prefix: {new_url_prefix}")
