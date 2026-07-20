// staunton — the parts SHARED by every Staunton piece in the set (pawn, bishop,
// rook, queen, king).
//
// Each of the five is a rotate_extrude of one measured [r, z] profile. Rather
// than trace each profile whole, we build it bottom-up from three shared parts
// plus the piece's own unique middle:
//
//     head    (per piece)  — the mark on the axis: ball, mitre, coronet, crown,
//                            crenellated tower
//     collar  (SHARED)     — collar_pts(): the flared collar bead
//     neck    (SHARED)     — neck_pts():   the slim straight neck
//     body    (per piece)  — the piece's own bell / trumpet
//     foot    (SHARED)     — foot_pts():   the two-tier stacked foot on the
//                            32 mm footprint (base_r = 16), cut flat at z = 0
//
// The three shared parts are defined ONCE here from the PAWN's measured profile
// — the canonical shape — and reused by every piece with per-piece scale
// factors. Changing the collar/neck/foot here changes the whole set at once, so
// the pieces can never drift apart: a shared footprint and family of turned
// parts is what makes them read as one set (see ../CLAUDE.md).
//
// The foot's RADIUS is NEVER scaled — the 16 mm footprint must sit within the
// board's 40 mm platform stage on every piece — so foot_pts() takes only a
// height scale (zs); taller pieces get a taller foot, never a wider one.
//
// Coordinates: each shared part is authored in a LOCAL frame with its bottom
// edge at z = 0 and its points listed top-first (as they appear reading down a
// profile). The part functions scale it (rs radially, zs vertically) and lift it
// to an absolute z0. A piece stacks the parts by placing each part's z0 at the
// top of the part below it; foot_h and collar_h give the canonical (zs = 1)
// heights needed for that arithmetic.
//
// This file defines named geometry only — including it renders nothing on its
// own. Pull it into a piece with `include <../../lib/staunton.scad>`.

base_r   = 16;      // shared foot radius (32 mm dia) — NEVER scale this
foot_h   = 14.22;   // canonical foot height   at zs = 1 (top tier to bed)
collar_h = 10.67;   // canonical collar height at zs = 1 (neck pinch to neck)

// ---- foot: the two-tier stacked base, canonical from the pawn ----
// Local frame: flat base edge at z = 0 (bed contact), top tier at z = foot_h.
// Only the height scales (zs); the radius is the fixed shared footprint, so the
// foot always lands on base_r. z0 lifts the whole foot (normally 0 — on the bed).
function foot_pts(zs = 1, z0 = 0) = [ for (p = _FOOT) [p[0], p[1] * zs + z0] ];
_FOOT = [
    [ 10.90, 14.22 ],  // top tier
    [ 10.90, 13.51 ],
    [ 10.43, 12.80 ],  // groove
    [ 10.67, 12.09 ],
    [ 11.50, 11.38 ],
    [ 12.44, 10.67 ],
    [ 12.92,  9.96 ],  // second tier
    [ 12.44,  9.24 ],
    [ 11.61,  8.53 ],  // groove
    [ 12.33,  7.82 ],
    [ 13.39,  7.11 ],
    [ 14.46,  6.40 ],
    [ 15.29,  5.69 ],
    [ 15.64,  4.98 ],  // flaring foot
    [ 15.64,  4.27 ],
    [ 15.41,  3.56 ],
    [ 15.53,  2.84 ],
    [ 15.88,  2.13 ],
    [ 16.00,  1.42 ],
    [ 16.12,  0.71 ],
    [ 16.12,  0.00 ],  // flat base edge
];

// ---- collar: the flared collar bead, canonical from the pawn ----
// Local frame: bottom at z = 0 (r = 4.27, meeting the neck), top neck-pinch at
// z = collar_h (r = 2.84, meeting the head). rs widens the brim, zs stretches it
// taller; z0 lifts it to sit on top of the neck.
function collar_pts(rs = 1, zs = 1, z0 = 0) =
    [ for (p = _COLLAR) [p[0] * rs, p[1] * zs + z0] ];
_COLLAR = [
    [ 2.84, 10.67 ],  // neck pinch (meets the head above)
    [ 4.62,  9.96 ],
    [ 5.45,  9.24 ],  // top lip
    [ 4.74,  8.53 ],
    [ 5.10,  7.82 ],
    [ 6.52,  7.11 ],
    [ 8.18,  6.40 ],
    [ 9.13,  5.69 ],
    [ 9.48,  4.98 ],  // brim widest
    [ 8.77,  4.27 ],
    [ 6.87,  3.56 ],  // underside steps back in
    [ 6.16,  2.84 ],
    [ 5.69,  2.13 ],
    [ 5.33,  1.42 ],
    [ 4.39,  0.71 ],
    [ 4.27,  0.00 ],  // meets the neck below
];

// ---- neck: the slim straight neck between collar and body ----
// A plain cylinder of radius r and height h, bottom edge at z0, so it spans
// [z0, z0 + h]. Set r to the collar's bottom radius (4.27 * collar_rs) so the
// collar seats on the neck without a step; the piece's body attaches below at z0.
function neck_pts(r, h, z0 = 0) = [ [r, z0 + h], [r, z0] ];
