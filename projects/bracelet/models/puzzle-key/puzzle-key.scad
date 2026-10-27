// The puzzle buckle's key, for `buckle = "puzzle"` in models/bracelet.
// Prints LYING, top face down on the bed, legs up (the user's choice,
// 2026-10-27; it was first drawn standing). The legs' undercut inner
// faces are then 35° overhangs. Everything it is made of lives in
// lib/puzzle-key.scad, which the bracelet shares for the grooves.
include <../../lib/puzzle-key.scad>

$fn = 48;

assert(pz_nd < pz_leg, "the notch cuts through the leg");
assert(pz_a <= 40, "the legs' inner faces would hang past 40 deg, printed top down");

translate([0, 0, pz_thick]) rotate([180, 0, 0]) pz_key();
