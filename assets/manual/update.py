import subprocess 

subprocess.run([
    "for file in img/*.typ; do typst compile $file --root ../..; done"
], shell=True)

subprocess.run([
    "typst c manual.typ --root ../.."
], shell=True)
