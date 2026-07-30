// connector — dimensions SHARED by the knight's two printed parts (foot + horse), so
// the pin and its socket can never drift out of fit. This file defines named values
// plus the shared hex_prism() helper, and pulls in the shared Staunton foot; it
// renders nothing on its own.
//
// the knight is ONE component printed in TWO pieces for easier
// printing: the turned FOOT prints upright (flat base, pin points up, self-
// supporting), and the flat HORSE blade prints lying on a face (the whole
// silhouette flat on the bed — no overhangs, no support). They assemble with a
// HEX peg-and-socket: a hex pin rising from the foot top into a blind hex socket up
// inside the horse's neck, the horse's flat neck bottom seating flush on the foot's
// top disc.

include <../../lib/staunton.scad>

// ---- shared vertical reference ----
foot_zs        = 1.0;                 // foot at canonical height (the bishop's foot)
foot_top_z     = foot_h * foot_zs;    // 14.22 — the foot's flat top disc; the horse
                                      //   neck seats here and the pin rises from here

// ---- flat blade ----
blade_thickness = 12;    // Y-depth of the horse blade / neck slab

// ---- neck column (the short neck at the bottom of the horse) ----
// A straight slab column from the foot top up to where the chest flares. Half-width
// 8.5 keeps its Y-corners (radius sqrt(8.5^2 + 6^2) = 10.4) inside the foot's top
// disc (radius 10.9), so the neck seats fully on the foot.
neck_hw = 8.5;
neck_h  = 3.7;    // short — about 1/3 of the earlier 11 mm neck

// ---- HEX peg-and-socket joint (tight / glued friction fit) ----
// A HEX pin, not round: a hex hole prints far more cleanly than a round one — laid on
// its side (as the horse's socket is), a hex oriented vertex-up self-supports its
// roof, where a round hole's ceiling sags. FDM press fits are POSITIVE clearances
// (see the skill's connector-fit note): the socket is larger than the pin. wall_gap
// is the per-side clearance on the flats (tight — grips); ceiling_gap is extra room
// at the blind socket roof (a downward-sagging bridge) so the pin seats without
// bottoming out before the neck lands on the foot.
pin_af       = 5.5;                    // pin size ACROSS FLATS; across-corners = 6.35,
                                       //   inside the 12 mm blade depth with ~2.8 mm
                                       //   of wall to each face.
pin_h        = 8.0;                    // pin height above the foot top
wall_gap     = 0.15;                   // per-side clearance on the hex flats (tight)
ceiling_gap  = 0.25;                   // extra depth at the blind socket roof
pin_tip      = 0.8;                    // lead-in chamfer height at the pin tip

socket_af    = pin_af + 2 * wall_gap;  // 7.80 across flats
socket_depth = pin_h + ceiling_gap;    // 8.25 — so the neck seats flush on the foot

// A regular hexagonal prism, `af` across flats, height `h`, bottom on z = 0, with a
// FLAT face pointing +Y (a horizontal top edge). In the horse's print pose (laid on a
// face) +Y becomes UP, so the socket's ceiling is a short flat BRIDGE and its side
// walls sit at 30 deg from vertical — all self-supporting. (A vertex-up hex would put
// the two upper faces at 60 deg from vertical, which sag.) The foot's pin uses the
// SAME orientation so the two mate. Circumradius = af / sqrt(3) (across flats =
// R*sqrt3); OpenSCAD's $fn=6 already lands flat edges at top and bottom, so no spin.
module hex_prism(af, h) {
    cylinder(h = h, r = af / sqrt(3), $fn = 6);
}
