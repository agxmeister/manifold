// The buckle's LOCK SCREW (`buckle = "screw"` in bracelet.scad), shared by
// the bracelet (its threaded hole) and `models/lock-screw` (the screw).
//
// An UPRIGHT THUMBSCREW (2026-10-30; it used to lie along the band, in the
// far wall, with a 5 mm head between joint 0's knuckles — too small to turn,
// and its tip showed in the open way-in). It stands in the roof over the
// way-in, right behind the knob. Screwed DOWN, its tip stands in the gap
// behind the knob, so the knob cannot be pushed back to where it drops out:
// locked. Screwed UP, the tip rises clear of the knob's low back half. The
// big ribbed head sits on the buckle's top, turned by a finger; screwed down
// it clamps on the top face, so it does not shake loose.
//
//   section along the band's middle, locked
//
//              ┌──── head ────┐
//   ▓▓roof▓▓▓▓▓▓▓▓▓▓▓│thread│▓▓▓▓▓▓▓▓│ bar 0 │ joint 0
//   ▓▓ ( knob  )▄▄▄▄ │ tip  │ ▓▓▓▓▓▓
//   ──────────────────────────────────────── bed (wrist side)
//
// It prints separately, standing on its head; the hole prints upright too,
// so both threads are vertical ones with 45° flanks.
//
// This file draws nothing — variables, functions and modules only. Everything
// is named `sk_*`.

// ------------------------------------------------------------------ thread
sk_maj    = 3.4;     // male major diameter. Pushed back by the knob, the tip
                     //   bends at the roof: thicker than the old 2.9
sk_depth  = 0.35;    // radial depth of the tooth
sk_pitch  = 1.4;     // lead per turn: coarse, for a 0.4 nozzle
sk_crest  = 0.15;    // the crest's flat, axially
sk_fit    = 0.12;    // clearance, radial and axial
sk_tip    = 0.5;     // lead-in taper at the screw's tip
sk_mouth  = 0.4;     // the hole's top edge, chamfered: the screw finds it

sk_minor    = sk_maj - 2*sk_depth;          // 2.70
sk_hole_maj = sk_maj + 2*sk_fit;            // 3.64
sk_hole_min = sk_minor + 2*sk_fit;          // 2.94

// ---------------------------------------------------------- travel and head
sk_tip_z  = 0.3;     // locked: the tip, over the bed
sk_len    = 4.5;     // the thread, head to tip: the band (4.8) less `sk_tip_z`
                     //   — locked, the head sits on the top face
sk_travel = 2.0;     // locked -> released: the tip rises over the knob's back
sk_head_d = 9.0;     // the head, over its ribs
sk_head_l = 2.2;     // ... and its height
sk_ribs   = 18;      // round flutes round the rim, for a finger
sk_rib_r  = 0.7;     // ... their radius
sk_rib    = 0.5;     // ... and depth
sk_head_ch = 0.4;    // the head's edges, chamfered

sk_turns  = sk_travel / sk_pitch;

// Along the axis: the socket's ridge (the female crest) and the male root.
sk_crest_f = sk_pitch - (sk_crest + 2*sk_fit + 2*sk_depth);
sk_root    = sk_pitch - (sk_crest + 2*sk_depth);

assert(sk_crest_f >= 0.3, str("the socket's thread ridge is only ", sk_crest_f));
assert(sk_head_d >= sk_hole_maj + 4, "the head hardly stands out round the hole");
assert(sk_rib < sk_rib_r && sk_head_ch < sk_head_l/3, "the head's ribs or chamfers are off");

// ------------------------------------------------------------------ modules
// One period of the male tooth in (radius, axial), 45° flanks.
sk_tooth = [
    [sk_minor/2 - 0.3, -(sk_crest/2 + sk_depth)],
    [sk_minor/2,       -(sk_crest/2 + sk_depth)],
    [sk_maj/2,         -sk_crest/2],
    [sk_maj/2,          sk_crest/2],
    [sk_minor/2,        sk_crest/2 + sk_depth],
    [sk_minor/2 - 0.3,  sk_crest/2 + sk_depth],
];
// The socket's groove: the tooth grown by `sk_fit` every way.
sk_tooth_f = [
    [sk_minor/2 - 0.3, -(sk_crest/2 + sk_fit + sk_depth)],
    [sk_hole_min/2,    -(sk_crest/2 + sk_fit + sk_depth)],
    [sk_hole_maj/2,    -(sk_crest/2 + sk_fit)],
    [sk_hole_maj/2,     (sk_crest/2 + sk_fit)],
    [sk_hole_min/2,     (sk_crest/2 + sk_fit + sk_depth)],
    [sk_minor/2 - 0.3,  (sk_crest/2 + sk_fit + sk_depth)],
];

module sk_rib_at(i, prof, steps)
    rotate([0, 0, i * 360/steps])
        translate([0, 0, i * sk_pitch/steps])
            rotate([90, 0, 0])
                linear_extrude(0.02, center = true) polygon(prof);

// Phase 0 at z = 0, overrunning a full turn below 0 and above `len`.
module sk_helix(len, prof, steps = 30) {
    n = ceil((len + 2*sk_pitch) / sk_pitch * steps);
    translate([0, 0, -sk_pitch])
        for (i = [0 : n - 1]) hull() {
            sk_rib_at(i, prof, steps);
            sk_rib_at(i + 1, prof, steps);
        }
}

// The male thread, z = 0 .. len, tapered at the top.
module sk_male(len) intersection() {
    union() {
        cylinder(d = sk_minor, h = len, $fn = 48);
        sk_helix(len, sk_tooth);
    }
    union() {
        cylinder(d = sk_maj + 1, h = len - sk_tip);
        translate([0, 0, len - sk_tip])
            cylinder(d1 = sk_maj + 1, d2 = sk_minor - 0.4, h = sk_tip);
    }
}

// The socket's cutter, z = 0 .. depth, overrunning both ends by 1.
module sk_female(depth) intersection() {
    union() {
        translate([0, 0, -1]) cylinder(d = sk_hole_min, h = depth + 2, $fn = 48);
        sk_helix(depth + 1, sk_tooth_f);
    }
    translate([0, 0, -1]) cylinder(d = sk_hole_maj + 1, h = depth + 2);
}

// The ribbed head's plan: a disc with round flutes round its rim.
module sk_head_2d()
    difference() {
        circle(d = sk_head_d, $fn = 96);
        for (i = [0 : sk_ribs - 1]) rotate(i * 360/sk_ribs)
            translate([sk_head_d/2 + sk_rib_r - sk_rib, 0]) circle(r = sk_rib_r, $fn = 24);
    }

// The screw as printed: standing on its head (its top face), thread up.
module sk_screw() {
    // the head: the fluted disc, its top and bottom edges chamfered 45°
    // (an intersection, not a hull: a hull would fill the flutes)
    intersection() {
        linear_extrude(sk_head_l) sk_head_2d();
        union() {
            cylinder(d1 = sk_head_d - 2*sk_head_ch, d2 = sk_head_d, h = sk_head_ch, $fn = 96);
            translate([0, 0, sk_head_ch])
                cylinder(d = sk_head_d, h = sk_head_l - 2*sk_head_ch, $fn = 96);
            translate([0, 0, sk_head_l - sk_head_ch])
                cylinder(d1 = sk_head_d, d2 = sk_head_d - 2*sk_head_ch, h = sk_head_ch, $fn = 96);
        }
    }
    // the thread, sunk into the head so the two fuse
    translate([0, 0, sk_head_l - 0.2]) sk_male(sk_len + 0.2);
}

// The bracelet's hole, upright, z = 0 .. depth: the thread right through,
// its top edge chamfered.
module sk_hole(depth) {
    sk_female(depth);
    translate([0, 0, depth - sk_mouth])
        cylinder(d1 = sk_hole_maj, d2 = sk_hole_maj + 2*sk_mouth + 0.02, h = sk_mouth + 0.01, $fn = 48);
}
