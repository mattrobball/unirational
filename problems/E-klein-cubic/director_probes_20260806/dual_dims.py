exec(open('hess_window.py').read().split('print("d | mult')[0])
print("d : Wb(S) Wb(L) ideal>= | W(S) W(L) ideal>=")
for d in list(range(2,13))+[25,28,31,34,36,43]:
    mSb = mult('Wb', {c: molien[c][d] for c in CL}); mSw = mult('W', {c: molien[c][d] for c in CL})
    if d >= 3:
        vals = {c: chiL(d, c) for c in CL}
        mLb, mLw = mult('Wb', vals), mult('W', vals)
        print(f"{d:3d}: {mSb:4d} {mLb:3d} {mSb-mLb:4d}  | {mSw:4d} {mLw:3d} {mSw-mLw:4d}")
    else:
        print(f"{d:3d}: {mSb:4d}  -    -   | {mSw:4d}  -    -")
