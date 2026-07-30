# CLAUDE.md — chess

Project-specific guidance for AI agents. This sits beside the repo-root
`CLAUDE.md` (which still applies); the rules here are chess-only and win where
they add detail.

## Five Staunton turned pieces and a flat-blade knight

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

The **knight** (`models/knight/`) is the set's one **non-turned** piece — no
`rotate_extrude` body. Its head is a precise 2D **horse-head silhouette**
**image-traced** from the reference picture: the outline was thresholded, its largest
blob boundary walked (Moore tracing) and simplified (Douglas–Peucker), then scaled to
mm (0.0879 mm/px) and centred. Re-run that same image-tracing pipeline and paste the
emitted points into `horse_head()` to re-trace. The horse has a long **dished face**, a
squared **muzzle with an open mouth**, ears, and — its signature — a **mane rendered as
a comb of separated locks** down the curved back of the neck, kept **CRISP** (not
smoothed into a blob). It faces **-X** (muzzle LEFT, mane down the +X back) and keeps
the **whole horse including the breast**, closed at the base by a short **neck column**.
It shares only the turned **foot** (`foot_pts(1.0, 0)` from `lib/staunton.scad` — the
EXACT foot the bishop uses) — not the collar or a turned body. The face bevel uses
**BOSL2** (`include <BOSL2/std.scad>` + `<BOSL2/rounding.scad>`) — the one piece that
needs it.

It is printed as **TWO parts** (one model, several parts — like `board/`), which makes
it the easiest piece to print, plus a fused one-piece variant:

- `models/knight/foot.scad` — the EXACT bishop foot (`foot_pts(1.0, 0)`) plus a
  **hex pin** on top. Prints upright; the pin is self-supporting.
- `models/knight/horse.scad` — the traced blade with a **short neck column** at the
  bottom and a **hex socket** bored up it, its two faces carrying a **45° bevel**.
  The `horse()` module is authored standing (neck-bottom at `z = 0`), but the file's
  default top-level render is `print_pose()`, which lays it **flat on a face** — the
  whole silhouette flat on the bed, **zero support**. (`$hide` suppresses the
  auto-render so an assembly/fit file can `include` the parts and reposition them —
  but note you must `include`, not `use`: BOSL2's attachable machinery needs its
  special vars set by a top-level include, so `use <horse.scad>` throws.)
- `models/knight/connector.scad` — shared pin/socket + neck dims and the `hex_prism()`
  helper, so the fit can't drift. Renders nothing; both parts `include` it (it pulls
  in `staunton.scad`).
- `models/knight/knight.scad` — the OPTIONAL fused one-piece variant: it `include`s
  foot + horse (with `$hide` set), then unions `foot_body()` (no pin) with `blade()`
  (no socket) plunged `overlap` mm into the solid foot so they merge into ONE shell (a
  flush seat alone touches only on a coplanar face → two shells). Prints upright and
  wants light support under the muzzle/jaw and mane undersides — the flat-blade trade
  the two-part version sidesteps by printing the horse lying flat. Exports as
  `knight-knight.stl`.

Joint: the horse's neck seats **flush** on the foot's top disc; a **HEX** pin
(`pin_af` across flats) plugs into a hex socket (`pin_af + 2*wall_gap`), a tight
friction fit meant to be glued. Hex, not round: a hex hole prints far cleaner — laid
on its side (as the horse's socket is when printed flat), `hex_prism()` sits FLAT-face
up, so the socket roof is a short flat bridge and its side walls sit at 30° from
vertical — all self-supporting, where a round hole's ceiling would sag. (Flat-up, NOT
vertex-up: a vertex-up hex puts the two upper faces at 60° from vertical, which sag —
so `hex_prism()` deliberately has no spin, since `$fn=6` already lands a flat on top.)
Both pin and socket use `hex_prism()` so they share that orientation and mate. Clearances
follow the skill's connector-fit note — `wall_gap = 0.15` on the flats, `ceiling_gap
= 0.25` extra at the blind socket roof (bridge sag) so the neck seats before the pin
bottoms. Verify the fit by exporting `intersection()` of the two parts at assembled
position: it comes back **empty** (coincident seat planes carry no volume) — the pass
for a clearance joint.

The **45° face bevel** (`blade_bevel = 2` mm, ~1/6 of the blade depth) has a hard-won
technique — do NOT "simplify" it back to a plain `offset_sweep` chamfer:
- A chamfer offsets the profile inward by its width; the mane's ~1 mm tooth gaps are
  far smaller than the bevel, so a direct `offset_sweep(horse_outline(), os_chamfer)`
  **collapses the comb into mush**. A 2D morphological-close of the outline before
  chamfering is **also** fragile — `offset()` in/out on this concave path pinches
  into multi-loop garbage (detached slivers, negative genus).
- What works: extrude the crisp silhouette **straight**, and INTERSECT it with a
  chamfer TOOL — an `offset_sweep(tool_outline(), os_chamfer)` where `tool_outline()`
  is the body outline with the **mane comb swapped for a plain rectangular block**
  (`mane_block()`) that reaches past the tooth tips by more than the bevel. The tool
  has no thin features (robust chamfer), and because the block covers the teeth
  full-thickness the bevel never touches them — the comb stays crisp and flat while
  the body gets the bevel. If you re-trace, keep `head_upper()` / `mane_comb()` split
  so the tool can still swap the comb.
- Bevel DEPTH interacts with the pointed, hollow-mouthed **muzzle**: at ~2.4 mm the
  mouth notch pinched into a sub-mm tunnel + degenerate bed slivers (a genus-1 mesh and
  a false stability fail); at the current **2 mm it is clean**. If you deepen the bevel
  and that artifact returns, either back off the depth or protect the nose with a small
  full-thickness block unioned into the tool (the same trick as `mane_block()`). The
  remaining sub-1.2 mm points are the forehead/brow tips — an accepted
  decorative-thin-wall class (like the bishop's slit rim); the mane (+X) is clean.

Other gotchas — keep them:
- The **neck column** half-width is `neck_hw = 8.5`: its Y-corners (radius
  `sqrt(8.5^2 + 6^2) ≈ 10.4`) must stay inside the foot's top disc (radius 10.9) so
  the neck seats fully on the foot. `neck_h` is short (~3.7 mm); the hex socket bores
  on **past** it into the solid body, which is fine — just keep a solid roof above the
  bore.
- Keeping the two parts SEPARATE (rather than fusing foot + horse up front) avoids two
  booleans that bite the one-piece `knight.scad` variant: a wide-chest-into-foot-wall
  union that can crawl in CGAL, and a foot-top-disc pinch. So `foot.scad` and
  `horse.scad` each pass **clean** — a single piece, thinnest solid walls 1.7 mm (foot)
  / 2.2 mm (horse), stable, the horse support-free laid flat, the foot's only flagged
  overhang the shared tier-groove ring. The fused `knight.scad` is also a single piece
  (adhesion ~2.2) but needs the light muzzle/jaw/mane support noted above.

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

(The **knight** includes `lib/staunton.scad` too, but uses ONLY `foot_pts` — no
`collar_pts`, no `body_pts`, no `rotate_extrude` body. Its body is the extruded,
edge-beveled `horse_outline()` blade seated on that shared foot; see the
flat-blade knight section above.)

## Printability (in addition to the repo-root rules)

- Every piece prints **upright on its base**. The turned Staunton pieces keep
  their profile within ~45° of vertical so most undersides bridge cleanly; their
  short classic turned overhangs — the pawn's ball and collar brim, the bishop's
  mitre and collar brim, the rook's flared crown and base rings, the queen's
  coronet rim and collar brim, the king's crown shoulders and collar brim —
  bridge acceptably, with light support optional for the crispest finish. The one
  feature that genuinely **wants support** is the **king's cross**, whose arm
  undersides and bottony end-bulbs face down (a deliberate trade for a cross
  faithful to the photo rather than a self-supporting diamond). The **knight**'s
  two-part print needs **no support**: the foot prints upright (self-supporting
  hex pin) and the horse blade prints **lying flat on a face**. Only the optional
  fused `knight.scad` prints upright, and then its
  downward-facing outline — under the muzzle and jaw, and the mane-tooth
  undersides — wants **light support**; those spans are short and bridge at this
  size, the trade for a flat-blade head. Its lone `check_overhangs` SUPPORT flag
  is the **shared foot's tier groove** — the same annular undercut every Staunton
  piece reports (an axisymmetric ring the slicer bridges; the reported ~25 mm
  "span" is the ring's diameter, not a real unsupported width), not a knight
  defect.
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
