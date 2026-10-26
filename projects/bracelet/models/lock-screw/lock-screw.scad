// The buckle's lock screw, for `buckle = "screw"` in models/bracelet.
// Prints standing on its ribbed head. Everything it is made of lives in
// lib/lock-screw.scad, which the bracelet shares for the threaded hole.
include <../../lib/lock-screw.scad>

$fn = 48;

sk_screw();
