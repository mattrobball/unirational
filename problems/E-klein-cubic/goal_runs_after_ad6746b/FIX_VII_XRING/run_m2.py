"""Instantiate hessian_curve.m2 for a prime and run it."""
import os, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))


def run(p):
    src = open(os.path.join(HERE, "hessian_curve.m2")).read()
    outfile = os.path.join(HERE, "results", "IC_p%d.txt" % p)
    src = src.replace("PPP", str(p)).replace("OUTFILE", '"%s"' % outfile)
    os.makedirs(os.path.join(HERE, "tmp"), exist_ok=True)
    script = os.path.join(HERE, "tmp", "hc%d.m2" % p)
    open(script, "w").write(src)
    r = subprocess.run(["M2", "--script", script], capture_output=True, text=True)
    if r.returncode != 0:
        print(r.stdout[-4000:])
        print(r.stderr[-4000:])
        raise SystemExit("M2 failed")
    return outfile


if __name__ == "__main__":
    print(run(int(sys.argv[1])))
