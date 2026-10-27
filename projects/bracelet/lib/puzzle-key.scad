// The PUZZLE buckle's KEY (`buckle = "puzzle"` in bracelet.scad), shared by
// the bracelet (the grooves in its two ends) and `models/puzzle-key` (the key).
//
// From a photo of a three-piece puzzle clasp (2026-10-27): two end caps and a
// middle piece that slides over both SIDEWAYS, across the cord. Here the two
// band ends butt together, each with a GROOVE across the band cut from the
// top, and a separate KEY slides into both grooves from the band's edge:
//
//   section along the band, fastened (s from the seam's middle)
//
//                  ┌───────────── key ─────────────┐   top, flush
//      last bar  ┌─┘┌─────┐                 ┌─────┐└─┐  bar 0's block
//   ─────────────┤  │ leg  \  ridge │ ridge  / leg │  ├────────────────
//                │  │       \_____  │  _____/      │  │
//                └──┴─────────────┐ │ ┌────────────┴──┘
//   ──────────────── floor ───────┘ │ └──── floor ───────────── bed
//                                 seam
//
//   * Each end's RIDGE (between the seam and its groove) leans out over the
//     groove at `pz_a`: the groove is a dovetail, wider at the floor. The
//     key's LEGS fill them, so the key cannot lift out, and the band's pull
//     — each ridge pushing its leg away from the seam — wedges it DOWN onto
//     the floors. The key's top bridges the seam, flush with the band.
//   * Nothing in the band hangs: a ridge's lean is a `pz_a` overhang on the
//     floor. The key prints STANDING on one end, so its section is printed
//     as drawn.
//   * Across the band, the grooves are open at both edges: the key slides in
//     from either edge, and out by pushing its other end. It CLICKS home on a
//     spring leaf in bar 0's groove wall (in the bracelet): a bump on the
//     leaf drops into a V-notch in the middle of the key's outer faces.
//
// Why three parts: two ends printed flat cannot lock each other against the
// pull and also slide together sideways. One of them has to reach OVER the
// other, and that overhang would run the whole band's width anchored at one
// edge only. The key escapes it by printing standing.
//
// This file draws nothing — variables, functions and modules only. Everything
// is named `pz_*`.

pz_thick  = 4.2;     // the band's thickness (asserted == `thick`)
pz_len    = 16.2;    // the key across the band = the band's width (asserted)

pz_seam   = 0.15;    // each end's face from the seam's middle: 0.3 apart
pz_fit    = 0.15;    // across the key's faces: leg <-> ridge, leg <-> wall
pz_vfit   = 0.2;     // vertical: a leg's foot over the floor, a ridge's top
                     //   under the key's bridge
pz_floor  = 1.0;     // the band under the grooves: it carries the pull
pz_bridge = 1.2;     // the key's top, over the ridges and the seam
pz_ridge  = 1.0;     // a ridge at the floor, along the band
pz_a      = 35;      // the ridge's undercut face, from vertical
pz_leg    = 1.6;     // a leg at the bridge, along the band

pz_zk = pz_thick - pz_bridge;     // 3.0 — the bridge's underside
pz_zr = pz_zk - pz_vfit;          // 2.8 — the ridges' tops
pz_zl = pz_floor + pz_vfit;       // 1.2 — the legs' feet

// A ridge's face, d along the band from its end's face, at height z.
function pz_dr(z) = pz_ridge + (z - pz_floor) * tan(pz_a);
// The key's leg, s from the seam's middle: inner face at height z, outer face.
function pz_si(z) = pz_seam + pz_dr(z) + pz_fit;
pz_so = pz_si(pz_zk) + pz_leg;            // 4.30
pz_do = pz_so + pz_fit - pz_seam;         // 4.30 — the groove's outer wall, d

// --------------------------------------------------------------- the click
// A LEAF in bar 0's groove's outer wall, running ACROSS the band, rooted
// towards +y, its free tip just past the band's middle. It bends along the
// band, which for the flat-printed band is in its layers' plane. Its
// bump stands `pz_click` into the key's path; the key's outer face has a
// V-notch at its middle that the bump drops into, free.
pz_click  = 0.4;     // how far the leaf bends while the key slides past
pz_lt     = 1.0;     // the leaf, along the band
pz_slot   = 0.65;    // behind it: room to bend `pz_click`, and 0.25 more
pz_ll     = 6.5;     // root -> bump, across the band
pz_tipx   = 1.0;     // the leaf's free tip, past the bump
pz_gap    = 0.6;     // the slot's mouth into the groove, at the tip
pz_br     = 0.6;     // the bump's radius
pz_ch     = 0.6;     // the key's ends: lead-in chamfers on the outer faces
pz_tch    = [0.5, 0.6];   // ... and the top edge, as the band's (run, rise)

// The bump's centre, d from the end's face (y = 0 at the band's middle).
pz_bd = pz_do - (pz_fit + pz_click) + pz_br;
// The notch: 45° flanks, deep enough that the seated bump clears both by 0.05.
pz_nd = sqrt(2) * (pz_br + 0.05) - (pz_br - pz_click);
pz_dmax = pz_do + pz_lt + pz_slot;        // the deepest cut, d
pz_strain = 1.5 * pz_lt * pz_click / (pz_ll * pz_ll) * 100;

// ---------------------------------------------------------------- sections
// The key's section, (s, z).
module pz_key_2d()
    for (m = [0, 1]) mirror([m, 0])
        polygon([[-0.01, pz_zk], [pz_si(pz_zk), pz_zk], [pz_si(pz_zl), pz_zl],
                 [pz_so, pz_zl], [pz_so, pz_thick], [-0.01, pz_thick]]);

// What one end loses, (d, z), d from its face into the end: the recess over
// the ridge (the key's bridge) and the dovetail groove.
module pz_cut_2d()
    polygon([[-1, pz_zr], [pz_dr(pz_zr), pz_zr], [pz_dr(pz_floor), pz_floor],
             [pz_do, pz_floor], [pz_do, pz_thick + 1], [-1, pz_thick + 1]]);

// The key, fastened: s along x from the seam's middle, y across the band
// from its middle, z up from the bed.
module pz_key()
    difference() {
        translate([0, pz_len/2, 0]) rotate([90, 0, 0])
            linear_extrude(pz_len) pz_key_2d();
        for (m = [0, 1]) mirror([m, 0, 0]) {
            // the V-notch the bump drops into
            translate([pz_so, 0, -1]) linear_extrude(pz_thick + 2)
                polygon([[0.01, -pz_nd - 0.01], [0.01, pz_nd + 0.01], [-pz_nd, 0]]);
            // lead-in chamfers at both ends of the outer face
            for (e = [-1, 1]) translate([pz_so, e * pz_len/2, -1])
                linear_extrude(pz_thick + 2)
                    polygon([[0.01, e*0.01], [0.01, -e*(pz_ch + 0.01)],
                             [-pz_ch - 0.01, e*0.01]]);
        }
        // the top edge at both ends, chamfered as the band's
        for (e = [-1, 1]) translate([0, e * pz_len/2, pz_thick])
            rotate([90, 0, 90]) linear_extrude(2*pz_so + 2, center = true)
                polygon([[e*0.01, 0.01], [-e*(pz_tch[0] + 0.01), 0.01],
                         [e*0.01, -(pz_tch[1] + 0.01)]]);
    }
