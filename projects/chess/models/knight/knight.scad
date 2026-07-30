// knight — the knight as ONE fused solid (foot + horse in a single piece), an
// ALTERNATIVE to the two-part foot + horse for anyone who would rather print it
// upright in one go and accept a little support, instead of clipping two support-free
// parts together. Provided so both can be printed and compared. (The separately-
// printed parts are foot.scad + horse.scad; this file fuses them.)
//
// It reuses the very same geometry, but drops the pin/socket joint (pointless in one
// solid, and its 0.15 mm clearance would leave the two shells un-merged): the shared
// FOOT (no pin, `foot_body()`) with the horse BLADE (no socket, `blade()`) seated on
// top, its neck plunging `overlap` mm DOWN into the solid foot so the two genuinely
// share volume and union into ONE shell. (A flush seat alone touches only on a
// coplanar face — that unions into two shells, not a manifold solid.)
//
// Prints UPRIGHT on the foot's flat base. The flat blade's downward-facing outline —
// under the muzzle and jaw, and the mane-tooth undersides — wants light support; that
// is the trade this one-piece version makes against the two-part one, which sidesteps
// support by printing the horse lying flat.

$hide = true;
include <foot.scad>
include <horse.scad>

overlap = 2;   // how far the neck plunges into the solid foot, so the union merges

knight();

module knight() {
    union() {
        foot_body();                                        // shared foot, no pin
        translate([0, 0, foot_top_z - overlap]) blade();    // neck plunges in, no socket
    }
}
