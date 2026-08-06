import subprocess, sys, time
P = '/Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_cbdff0a/FIX_H2_HOLE_CLOSURE/msolve/'
CASES = {
 'one_Z': 'h2f_r8_one_Z_lowdeg_qq.ms',  'om_Z': 'h2m_r8_om_Z_lowdeg4_qq.ms',
 'om2_Z': 'h2m_r8_om2_Z_lowdeg4_qq.ms', 'one_N': 'h2m_r8_one_N_lowdeg_qq.ms',
 'om_N': 'h2m_r8_om_N_lowdeg_qq.ms',    'om2_N': 'h2m_r8_om2_N_lowdeg_direct_qq.ms'}

def parse_ms(path):
    lines = open(path).read().strip().split('\n')
    varline, char = lines[0].strip(), lines[1].strip()
    assert char == '0', char
    body = '\n'.join(lines[2:])
    polys = [p.strip().rstrip(',') for p in body.split(',\n') if p.strip()]
    assert '(' not in body, 'parenthesised input!'
    return varline, polys

def singular_unit(tag, varline, polys, timeout=1200):
    inp = 'ring r = 0, (%s), dp;\nideal I = %s;\nideal G = std(I);\nprint("SIZE"); print(size(G)); print("LEAD"); print(lead(G[1]));\nquit;\n' % (varline, ',\n'.join(polys))
    f = 'sing_%s.sing' % tag
    open(f, 'w').write(inp)
    t0 = time.time()
    try:
        r = subprocess.run(['/opt/homebrew/bin/Singular', '-q', f], capture_output=True, text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return None, time.time()-t0, 'TIMEOUT'
    out = r.stdout
    try:
        after = out.split('SIZE')[1].split()
        size, lead = after[0], out.split('LEAD')[1].split()[0]
    except Exception:
        return None, time.time()-t0, 'PARSE:' + out[-120:]
    is_unit = (size == '1' and lead == '1')
    return is_unit, time.time()-t0, 'size=%s lead=%s' % (size, lead)

# controls first: a unit system and a non-unit system
ok_u, dt, info = singular_unit('CTRL_UNIT', 'x,y', ['x', 'x+1'])
ok_n, dt2, info2 = singular_unit('CTRL_NONUNIT', 'x,y', ['x*y'])
print('control unit -> %s (%s); control non-unit -> %s (%s)' % (ok_u, info, ok_n, info2), flush=True)
assert ok_u is True and ok_n is False, 'CONTROLS FAILED'
res = {}
for tag, fn in CASES.items():
    varline, polys = parse_ms(P + fn)
    v, dt, info = singular_unit(tag, varline, polys)
    res[tag] = v
    print('%-6s %-38s vars=%2d gens=%2d -> unit=%s (%.1f s) %s' % (tag, fn, len(varline.split(',')), len(polys), v, dt, info), flush=True)
print('ALL-UNIT:', all(v is True for v in res.values()), flush=True)
