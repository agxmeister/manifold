// An ELEPHANT HEAD on the puzzle key's top face (`face = "elephant"` in
// puzzle-key.scad, 2026-10-28). Seen from above, like a watch face: the
// face's "up" runs along the band (+x), the trunk hangs towards -x, the big
// ears spread across the band (y), where the key is long.
//
// Everything stands on the key's top (z = `pz_thick`) and is a HEIGHT
// FIELD: half-ellipsoid domes, and the trunk a hull of domes. The key
// prints upright, legs on the bed, so the face is its top and nothing hangs.
// It is clipped to the key's own outline (`ek_outline_2d`), so it never
// reaches over the band's ends, the notches or the chamfered ends, and the
// key slides in as before.
//
// Frame: the key's, fastened — x along the band from the key's middle, y
// across it, z up from the bed. Needs lib/puzzle-key.scad included first.

// ----------------------------------------------------------------- head
ek_head   = [0.5, 0, 3.4, 4.0, 2.8];   // [x, y, rx, ry, height]
// ----------------------------------------------------------------- ears
ek_ear    = [-0.2, 4.4, 3.9, 3.0, 1.5];   // the +y ear; -y mirrored
ek_inner  = 0.5;     // the inner ear's dimple, as a share of the ear
ek_in_d   = 0.3;     // ... its depth below the ear's top
ek_in_dy  = 0.5;     //   and how far it sits out from the ear's middle
// ----------------------------------------------------------------- trunk
// The trunk's path, root to curled tip: [x, y, radius, rise above the
// head]. Where the head is lower than the rise, the trunk stands on the
// key's top on its own.
ek_trunk  = [[ 1.2,  0.0,  1.45, 0.7 ],
             [ 0.0,  0.0,  1.35, 0.7 ],
             [-1.3,  0.05, 1.2,  0.7 ],
             [-2.5,  0.3,  1.05, 0.75],
             [-3.2,  1.0,  0.95, 1.3 ],
             [-3.0,  1.9,  0.8,  1.15],
             [-2.3,  2.1,  0.65, 0.95]];
// ----------------------------------------------------------------- eyes
ek_eye    = [2.2, 1.8];     // [x, |y|] — dimples in the head
ek_eye_r  = 0.55;
ek_eye_d  = 0.45;           // how deep

// The head's height above the key's top at (x, y).
function ek_head_h(x, y) =
    let(u = (x - ek_head[0]) / ek_head[2], v = (y - ek_head[1]) / ek_head[3],
        q = 1 - u*u - v*v)
    q > 0 ? ek_head[4] * sqrt(q) : 0;

// A half-ellipsoid standing on z = 0: plan radii rx, ry, height h.
module ek_dome(rx, ry, h)
    scale([rx, ry, h]) intersection() {
        sphere(r = 1, $fn = 48);
        translate([-1, -1, 0]) cube(2);
    }

// The key's top outline: inside its faces, off the notches, the lead-ins and
// the chamfered ends, `ek_inset` in from each.
ek_inset = 0.15;
module ek_outline_2d()
    offset(delta = -ek_inset) difference() {
        square([2*pz_so, pz_len - 2*pz_tch[0]], center = true);
        for (m = [0, 1]) mirror([m, 0]) {
            translate([pz_so, 0])
                polygon([[0.01, -pz_nd - 0.01], [0.01, pz_nd + 0.01], [-pz_nd, 0]]);
            for (e = [-1, 1]) translate([pz_so, e * pz_len/2])
                polygon([[0.01, e*0.01], [0.01, -e*(pz_ch + 0.01)], [-pz_ch - 0.01, e*0.01]]);
        }
    }

module ek_ears()
    for (m = [0, 1]) mirror([0, m, 0]) difference() {
        translate([ek_ear[0], ek_ear[1], 0]) ek_dome(ek_ear[2], ek_ear[3], ek_ear[4]);
        // the inner ear, a shallow dish
        translate([ek_ear[0], ek_ear[1] + ek_in_dy, ek_ear[4] - ek_in_d + 1])
            scale([ek_inner*ek_ear[2], ek_inner*ek_ear[3], 1]) sphere(r = 1, $fn = 48);
    }

module ek_trunk()
    for (i = [0 : len(ek_trunk) - 2]) hull()
        for (p = [ek_trunk[i], ek_trunk[i+1]])
            translate([p[0], p[1], 0])
                ek_dome(p[2], p[2], max(ek_head_h(p[0], p[1]), 0) + p[3]);

module ek_head()
    difference() {
        translate([ek_head[0], ek_head[1], 0]) ek_dome(ek_head[2], ek_head[3], ek_head[4]);
        for (s = [-1, 1])
            translate([ek_eye[0], s*ek_eye[1],
                       ek_head_h(ek_eye[0], ek_eye[1]) + ek_eye_r - ek_eye_d])
                sphere(r = ek_eye_r, $fn = 32);
    }

// The whole face, on the key's top.
module ek_face()
    translate([0, 0, pz_thick - 0.01]) intersection() {
        union() { ek_ears(); ek_head(); ek_trunk(); }
        translate([0, 0, -1]) linear_extrude(20) ek_outline_2d();
    }
