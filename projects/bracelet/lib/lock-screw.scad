// The buckle's LOCK SCREW (`buckle = "screw"` in bracelet.scad), shared by
// the bracelet (its threaded hole) and `models/lock-screw` (the screw).
//
// The user's sketch, 2026-10-25: a screw ALONG the band, in the socket's far
// wall, between the way-in and bar 0's hinge. Screwed out towards the knob,
// its tip stands in the gap behind the knob, so the knob cannot be pushed
// back to where it drops out: locked. Screwed back, the tip hides in the
// wall: released. A ribbed head, turned by a finger, sits behind bar 0 in
// the gap between the two hinge clusters. The knob pushes straight along
// the screw, and a thread does not turn under an end push: no spring, no
// detent.
//
//   section along the band's middle, locked
//
//      way-in        far wall (bar 0)    joint 0
//   ( knob )▐◄tip══════thread══════╡▓head▓│  bar 1
//   ────────────────────────────────────────── bed
//
// It prints SEPARATELY, standing on its head, so the thread is a vertical
// one; the socket's half prints lying, so its tooth flanks are 45°: they
// hang no flatter than that over the hole. It goes in from behind bar 0,
// with joint 0 bent (see the README).
//
// This file draws nothing — variables, functions and modules only. Everything
// is named `sk_*`.

// ------------------------------------------------------------------ thread
sk_maj    = 2.9;     // male major diameter. The band is only 4.8 thick: the
                     //   hole leaves `sk_skin` of socket over and under it.
sk_depth  = 0.32;    // radial depth of the tooth
sk_pitch  = 1.3;     // lead per turn: coarse, for a 0.4 nozzle
sk_crest  = 0.15;    // the crest's flat, axially
sk_fit    = 0.12;    // clearance, radial and axial
sk_tip    = 0.5;     // lead-in taper at the screw's tip

sk_minor    = sk_maj - 2*sk_depth;          // 2.26
sk_hole_maj = sk_maj + 2*sk_fit;            // 3.14
sk_hole_min = sk_minor + 2*sk_fit;          // 2.50

// ---------------------------------------------------------- travel and head
sk_far    = 4.5;     // the far wall the thread runs in: way-in -> bar 0's +x face
sk_ext    = 1.8;     // locked: how far the tip stands out of the far wall
sk_rec    = 0.2;     // released: how far the tip hides inside it
sk_hgap   = 0.3;     // locked: the head <-> bar 0's +x face
sk_head_d = 5.0;     // the head, over its ribs
sk_head_l = 1.4;     // ... and along the screw
sk_ribs   = 16;
sk_rib    = 0.35;    // the ribs' depth
sk_head_ch = 0.3;    // the head's edges, chamfered

sk_travel = sk_ext + sk_rec;                // released -> locked
sk_turns  = sk_travel / sk_pitch;
sk_len    = sk_far + sk_ext + sk_hgap;      // the thread, head to tip

// Along the axis: the socket's ridge (the female crest) and the male root.
sk_crest_f = sk_pitch - (sk_crest + 2*sk_fit + 2*sk_depth);
sk_root    = sk_pitch - (sk_crest + 2*sk_depth);
// locked, the turns still in the wall
sk_engaged = (sk_far - sk_ext) / sk_pitch;

assert(sk_crest_f >= 0.2, str("the socket's thread ridge is only ", sk_crest_f));
assert(sk_engaged >= 1.8, str("locked, only ", sk_engaged, " turns hold the screw"));
assert(sk_head_d > sk_hole_maj + 1.0, "the head hardly stands proud of the hole");

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

// The ribbed head's plan: a star of `sk_ribs` rounded-off teeth.
module sk_head_2d()
    polygon([for (i = [0 : 2*sk_ribs - 1])
        let (a = i * 180/sk_ribs, r = (i % 2 == 0) ? sk_head_d/2 : sk_head_d/2 - sk_rib)
        [r*cos(a), r*sin(a)]]);

// The screw as printed: standing on its head, thread up.
module sk_screw() {
    // the head, its top and bottom edges chamfered
    hull() {
        linear_extrude(sk_head_l) offset(delta = -sk_head_ch) sk_head_2d();
        translate([0, 0, sk_head_ch])
            linear_extrude(sk_head_l - 2*sk_head_ch) sk_head_2d();
    }
    // the thread, sunk into the head so the two fuse
    translate([0, 0, sk_head_l - 0.2]) sk_male(sk_len + 0.2);
}
