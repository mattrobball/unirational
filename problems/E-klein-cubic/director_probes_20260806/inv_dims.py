exec(open('hess_window.py').read().split('print("d | mult')[0])
rows = []
for d in range(1, 41):
    mS = {V: mult(V, {c: molien[c][d] for c in CL}) for V in CT}
    if d >= 3:
        vals = {c: chiL(d, c) for c in CL}
        mL = {V: mult(V, vals) for V in CT}
    else:
        mL = None
    rows.append((d, mS, mL))
print("d : triv(S^d) | Wb(S^d) | triv(L^d) | Wb(L^d)")
for d, mS, mL in rows:
    print(f"{d:3d}: {mS['triv']:3d} | {mS['Wb']:4d} | " + (f"{mL['triv']:3d} | {mL['Wb']:3d}" if mL else " - | -"))
