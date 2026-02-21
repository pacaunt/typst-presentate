import subprocess
import sys 

if __name__ == "__main__":
    all_args = sys.argv[1:]
    for arg in all_args: 
        subprocess.run(["typst", "compile", arg, "--root", "../.."])
        file_name = arg.removesuffix(".typ")
        subprocess.run([
            "typst", "compile", "examples.typ", "--input", "name=" + file_name + ".pdf", 
            "--format=png", "--ppi", "400", file_name + ".png", "--root", "../.." ])
    print("Done!")
    