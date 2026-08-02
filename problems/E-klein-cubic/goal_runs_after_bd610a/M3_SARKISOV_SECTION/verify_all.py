#!/usr/bin/env python3
"""Replay all portable M3 checks and verify the packet seal."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess
import sys

HERE=Path(__file__).resolve().parent


def sha256(path:Path)->str:
    h=hashlib.sha256()
    with path.open('rb') as f:
        while chunk:=f.read(1<<20):h.update(chunk)
    return h.hexdigest()


def run(name):
    subprocess.run([sys.executable,str(HERE/name)],check=True,cwd=HERE)


def main():
    run('verify_residual_galois.py')
    run('verify_section_search.py')
    residual=json.loads((HERE/'residual_galois.json').read_text())
    section=json.loads((HERE/'section_search_payload.json').read_text())
    classes=json.loads((HERE/'SECTION_CLASSES.json').read_text())
    manifest=json.loads((HERE/'INPUT_MANIFEST.json').read_text())
    assert residual['index_four']['exists'] is False
    assert residual['arithmetic_conclusion']['quartic_subfield_in_line_splitting_field'] is False
    assert section['exit']=='M3-SECTION-COMPONENT-PASS'
    assert section['headline']=='OPEN'
    assert section['characteristic_zero_conclusions']['rational_section_produced'] is False
    assert classes['components'][0]['model']=='C_012'
    assert classes['components'][3]['geometric_status']=='HORIZONTAL_PROJECTIVE_DIMENSION_4_COMPONENT'
    assert manifest['pinned_state']=='bd610a032bb9561d2daeb91a2cb60c48c082ca2f'
    status=(HERE/'STATUS.md').read_text()
    assert status.startswith('M3-SECTION-COMPONENT-PASS\n')
    assert 'headline remains **OPEN**' in status
    seal=json.loads((HERE/'SEAL.json').read_text())
    assert seal['exit']=='M3-SECTION-COMPONENT-PASS'
    assert seal['headline']=='OPEN'
    for relative,expected in seal['local_files'].items():
        actual=sha256(HERE/relative)
        assert actual==expected,(relative,actual,expected)
    print('PASS packet documents, payload boundaries, and recursive local hashes')
    print('M3_SARKISOV_SECTION_PACKET_OK')


if __name__=='__main__':main()
