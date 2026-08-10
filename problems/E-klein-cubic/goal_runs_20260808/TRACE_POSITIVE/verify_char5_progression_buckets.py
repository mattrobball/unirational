#!/usr/bin/env python3
"""Fixed finite check of the five-bucket indexing in equations (2.4)-(2.7)."""

for d in range(1, 5):
    inv_3d = pow(3 * d, -1, 5)
    for r in range(1, 5):
        seen = []
        for s in range(5):
            bucket = []
            for j, term_count in enumerate((1, 2, 2, 1)):
                i = ((r * j - d - s) * inv_3d) % 5
                exponent = r * j - d * (3 * i + 1)
                assert (exponent - s) % 5 == 0
                ell = (exponent - s) // 5
                bucket.extend([(i, j, ell)] * term_count)
            assert len(bucket) == 6
            seen.extend((s, i, j) for i, j, _ in bucket)
        assert len(seen) == 30
        assert len(set(seen)) == 20  # P_1 and P_2 each contain two terms.

print("F55-CHAR5-PROGRESSION-FIVE-SIX-TERM-BUCKETS-OK")
