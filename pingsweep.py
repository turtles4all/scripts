import subprocess
import sys

cmdping = "ping -c1 10.10.10."

for x in range (2,255):
    p = subprocess.Popen(cmdping+str(x), shell=True, stderr=subprocess.PIPE)

    while True:
        out = p.stderr.read(1)
        if out == '' and p.poll() != None:
            break
        if out != '':
            sys.stdout.write(out)
            sys.stdout.flush()