#!/usr/bin/env python3
from __future__ import annotations
import hashlib,json
from pathlib import Path
from datetime import datetime,timezone
HERE=Path(__file__).resolve().parent
EXCLUDE={'SEAL.json'}

def sha(path):
    h=hashlib.sha256();h.update(path.read_bytes());return h.hexdigest()
files={p.name:sha(p) for p in sorted(HERE.iterdir()) if p.is_file() and p.name not in EXCLUDE}
payload={
  'schema':'m3-sarkisov-section-seal-v1',
  'created_utc':datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace('+00:00','Z'),
  'pinned_state':'bd610a032bb9561d2daeb91a2cb60c48c082ca2f',
  'exit':'M3-SECTION-COMPONENT-PASS',
  'headline':'OPEN',
  'markers':['M3_RESIDUAL_GALOIS_INDEPENDENT_VERIFY_OK','M3_SECTION_SEARCH_INDEPENDENT_VERIFY_OK','M3_SARKISOV_SECTION_PACKET_OK'],
  'strict_scope':'Residual Galois, binary secants, section classes through degree three, and a geometric component are certified. No K-section, point, quartic multisection, or quartic-locus emptiness is claimed.',
  'local_files':files,
}
(HERE/'SEAL.json').write_text(json.dumps(payload,indent=2,sort_keys=True)+'\n')
print('WROTE SEAL.json')
