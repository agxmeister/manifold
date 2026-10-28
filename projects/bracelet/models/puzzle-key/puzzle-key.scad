// The puzzle buckle's key, for `buckle = "puzzle"` in models/bracelet.
// Prints LYING, top face down on the bed, legs up (the user's choice,
// 2026-10-27; it was first drawn standing). The legs' undercut inner
// faces are then 35° overhangs. Everything it is made of lives in
// lib/puzzle-key.scad, which the bracelet shares for the grooves.
//
// FACES (2026-10-28): `face` decorates the key's top. The key underneath is
// always the same, so every face fits the same band. A decorated key prints
// UPRIGHT, as it sits in the band: legs on the bed, the face on top; its
// top bridges the 5.4 between the legs.
//   "plain"    — flat, printed top down as before
//   "elephant" — an elephant head (elephant.scad)
include <../../lib/puzzle-key.scad>
include <elephant.scad>

$fn = 48;

face = "plain";
assert(face == "plain" || face == "elephant", str("unknown face ", face));

assert(pz_nd < pz_leg, "the notch cuts through the leg");
assert(pz_a <= 40, "the legs' inner faces would hang past 40 deg, printed top down");

if (face == "plain")
    translate([0, 0, pz_thick]) rotate([180, 0, 0]) pz_key();
else
    // upright, the legs' feet on the bed
    translate([0, 0, -pz_zl]) {
        pz_key();
        if (face == "elephant") ek_face();
    }
