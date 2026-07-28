# CLAUDE.md — chess

Project-specific guidance for AI agents. This sits beside the repo-root
`CLAUDE.md` (which still applies); the rules here are chess-only and win where
they add detail.

## Five Staunton turned pieces (and a planned medieval knight)

The **pawn, bishop, rook, queen and king** are plain, classic **Staunton**
pieces (`models/pawn/`, `models/bishop/`, `models/rook/`, `models/queen/`,
`models/king/`), each turned as a bare `rotate_extrude` of one `[r, z]` profile
assembled bottom-up from the shared parts of `lib/staunton.scad` plus the piece's
own head and body (head/body traced from the same reference photo):

- the pawn and queen are pure turned profiles;
- the bishop adds one subtracted diagonal mitre slit;
- the rook adds a subtracted well + crenels for its battlements;
- the king adds a flat **cross** finial — the one mark a lathe cannot turn —
  rooted into the top of its turned crown (exactly as the queen's coronet is
  turned while her ball finial sits on the axis).

The Staunton five share a family of turned parts from `lib/staunton.scad` — a
common **foot**, **neck** and **collar** — each scaled per piece and stacked under
the piece's own head and body. The **foot** carries the **32 mm footprint**
(`base_r = 16`), cut dead flat at `z = 0` for a full disc of bed contact — a
shared footprint and a shared family of parts is what makes them a set. (The rook
is the one exception: it has **no collar**, so its tower head seats directly on a
smooth `body_pts` trumpet body that absorbs the neck — it shares only the foot.)
These are the set's OWN
shared parts. **Never scale the foot's radius** — `foot_pts()` takes only a height
scale, so the foot must stay within the board's 40 mm platform stage (never wider
than ~19 mm). When adding or editing a turned piece, read `models/pawn/` first
(the canonical shape whose foot, neck and collar the shared parts are defined
from), then `models/queen/` and `models/king/` — the royals are the fullest
examples (finial/cross, coronet/crown, collar, bell body, tiered foot).

Rough height progression (taller by rank): pawn shortest (~49 mm), then
bishop/rook, then queen (~86 mm) and king (~93 mm) tallest.

The **knight** is planned separately in the set's original **medieval /
battlefield** style — a flat heraldic horse-head blade on a round stone plinth
and collar bolster — and is currently being reworked. It is not part of the
shared Staunton family and does not use `lib/staunton.scad`; when its rework
lands it will bring its own shared library. Its `models/knight/` folder and that
library are not committed yet.

## Shared geometry lives in `lib/`

**`lib/staunton.scad`** — the turned parts shared by the **Staunton five**. It
defines named geometry only, so including it renders nothing on its own. It is
the canon of the set's foot/neck/collar, defined once from the pawn:

- `foot_pts(zs, z0)` — the two-tier stacked **foot** on the shared footprint.
  Only its height scales (`zs`); the radius is fixed, so the foot always lands on
  `base_r = 16`. **Never scale the foot's radius.**
- `collar_pts(rs, zs, z0)` — the flared **collar** bead; `rs` widens the brim,
  `zs` stretches it taller.
- `body_pts(cps, h, z0, seg)` — the tapering **body**, a smooth Catmull-Rom curve
  through the piece's own `[t, r]` control points. It absorbs the neck: the curve
  simply tapers to its top radius (the collar's bottom, or the head's base on the
  rook), so no separate cylinder neck is stacked.
- `neck_pts(r, h, z0)` — a slim straight cylinder neck. **Legacy** — every piece
  now uses `body_pts` instead; kept only for reference.
- `base_r`, `foot_h`, `collar_h` — the footprint radius and the canonical
  (scale 1) part heights, used to stack the parts on the axis.

  Each piece assembles one profile as `concat(head, collar_pts(…),
  body_pts(…), foot_pts(…), [[0, 0]])` and `rotate_extrude`s it, placing each
  shared part's `z0` at the top of the part below it. `head` and `body` are the
  piece's own; the marks (bishop slit, rook well/crenels, king cross) are added
  around the revolve. The rook omits `collar_pts` — its head seats directly on
  the body.

A new turned piece includes `lib/staunton.scad`, picks its per-piece scales, and
adds its own head and body — start from `models/pawn/`.

(The medieval **knight** will bring its own shared library — a plinth and collar
bolster — when its rework lands; neither `models/knight/` nor that library is
committed yet.)

## Printability (in addition to the repo-root rules)

- Every piece prints **upright on its base**. The turned Staunton pieces keep
  their profile within ~45° of vertical so most undersides bridge cleanly; their
  short classic turned overhangs — the pawn's ball and collar brim, the bishop's
  mitre and collar brim, the rook's flared crown and base rings, the queen's
  coronet rim and collar brim, the king's crown shoulders and collar brim —
  bridge acceptably, with light support optional for the crispest finish. The one
  feature that genuinely **wants support** is the **king's cross**, whose arm
  undersides and bottony end-bulbs face down (a deliberate trade for a cross
  faithful to the photo rather than a self-supporting diamond).
- Prefer **subtracted (engraved) details** over raised bumps for faces, slits,
  and rings — they need no support. A slit engraved into a curved head has thin
  rim edges by nature; that's an accepted decorative feature, not a wall to
  thicken, as long as there is solid material behind the recess floor.
- Verify every piece with the `openscad-3d-print-design` skill and the loom MCP
  tools (validate / render from all angles / export), then run the check
  scripts on the STL before considering it done.

## Exports

Single-part pieces still follow the repo `<model>-<part>` rule, so the part
name repeats the model name, e.g.:

```sh
openscad -o projects/chess/exports/pawn-pawn.stl projects/chess/models/pawn/pawn.scad
```
