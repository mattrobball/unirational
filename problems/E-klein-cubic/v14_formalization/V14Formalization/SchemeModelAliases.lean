/-
Copyright (c) 2026 V14Formalization contributors.
Released under Apache 2.0 license.
-/
module

public import V14Formalization.V14SchemeModel

/-!
# Shared `SchemeGeometry` aliases for the V14 scheme model

Eight modules each declared their own `abbrev k := V14SchemeModel.k` and
`abbrev G := V14SchemeModel.G` inside `V14Formalization.SchemeGeometry`.
Under the legacy elaborator the eight coexisted only because `private`
mangles a declaration's name per module.  In the module system that trick is
unavailable: a `public` signature may not mention a private declaration, so
the migration has to publish these aliases — and two *public* declarations of
one name cannot be imported into the same environment
(`environment already contains 'V14Formalization.SchemeGeometry.G'`).

They are therefore declared exactly once, here.  Both are reducible
abbreviations of the same constants the eight modules already used, so no
statement changes meaning; the published Comparator statements do not mention
these names at all (they spell `V14SchemeModel.k` / `V14SchemeModel.G` in
full, per commit 7680055a, and must keep doing so).
-/

namespace V14Formalization.SchemeGeometry

/-- The V14 base field, as used throughout the scheme-geometry namespace. -/
public abbrev k := V14SchemeModel.k

/-- The acting group `PSL₂(𝔽₁₁)`, as used throughout the scheme-geometry
namespace. -/
public abbrev G := V14SchemeModel.G

end V14Formalization.SchemeGeometry
