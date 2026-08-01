# Work scope

This directory contains only the low-memory exact investigation of pure-power
membership in the full cubic Stage-B contraction module.  Inputs are read from
the sibling `stageb_global_basis` packet; no files outside this directory are
modified.

Targets are `q_i^5 e_j` for `0 <= i < 37`, `0 <= j < 6`, followed by exponent
six only if the exponent-five identities fail.  Sampling is never a verdict.

`axis0_border_tails.npy` is a reproducible dense intermediate above GitHub's
100 MB per-file limit and is intentionally local.  The portable
`axis0_border_packet.npz` and `axis0_border_manifest.json` retain the compact
data and exact SHA-256 boundary.
