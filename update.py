import sys 
import re

new_url_prefix = sys.argv[1]

with open("README.md", "r+") as readme_file:
    content = re.sub(r'https://github.com/pacaunt/typst-presentate/blob/[^/]+', new_url_prefix, readme_file.read())
    readme_file.seek(0)
    readme_file.write(content)