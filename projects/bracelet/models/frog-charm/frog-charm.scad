// frog-charm — a frog's face that snaps onto a bracelet charm pin.
//
// Same pattern as models/flower-charm: flat plate printed FACE DOWN, face
// ENGRAVED, socket boss on the back, flipped over to wear. See
// lib/charm-pin.scad for why that orientation is forced.
//
// A frog is the one face in this set where the SILHOUETTE can carry the eyes,
// and it should: eyes drawn as two circles bulging out of the top of the head
// are 5.8 mm of real material each, so the pupils engraved inside them get a
// 1.6 mm wall all round and the eyes read from across a room. Compare the
// kitten, where the eyes had to be dimples on a flat face.
//
// The head is deliberately a WIDE STADIUM — two hulled circles, flat top and
// flat bottom. The flat bottom is what buys room for a mouth this low: an
// 11.8 mm circle would have curved up under it and left 0.9 mm of rim.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-pin.scad>

// ----------------------------------------------------------------- the head
plate       = 2.2;   // plate thickness — the same as the flower's
head_r      = 5.9;   // the two circles the head is hulled from ...
head_x      = 2.0;   //   ... and how far apart they sit
head_y      = -1.4;  //   ... and where, relative to the socket at the origin

eye_r       = 2.9;   // an eye, as part of the OUTLINE, not a cut
eye_at      = [4.2, 3.4];

// The eye and the head must genuinely OVERLAP — union() does not merge solids
// that merely touch, and a tangent eye exports as a separate piece that the
// connectivity check counts and a printer drops on the bed. What measures that
// is the LENS the two circles share, not whether one centre is inside the
// other: centre-inside is neither necessary (a big overlap can have both
// centres outside) nor sufficient, and asserting it rejects a perfectly welded
// eye. `eye_lap` is the lens along the line of centres, `eye_out` is how far
// the eye reaches past the head — which is the bulge, and the whole point.
eye_ctr     = norm([eye_at[0] - head_x, eye_at[1] - head_y]);   // 5.28
eye_lap     = head_r + eye_r - eye_ctr;                         // 3.52
eye_out     = eye_ctr + eye_r - head_r;                         // 2.28
assert(eye_lap >= 1.0,
       "the eye barely touches the head — it would export as a separate piece");
assert(eye_out >= 1.0,
       "the eye does not bulge past the head — there would be no eyes");

head_w      = 2*(head_x + head_r);                       // 15.80
charm_w     = max(head_w, 2*(eye_at[0] + eye_r));        // 15.80
charm_top   = eye_at[1] + eye_r;                         //  6.30
charm_bot   = head_y - head_r;                           // -7.30
charm_h     = charm_top - charm_bot;                     // 13.60
assert(charm_w <= 16 && charm_h <= 16,
       "the frog outgrew `charm_reach` in bracelet.scad — respace the stations");

boss_at     = [0, -0.6];   // a little below the head's centre, so the boss's
                           //   shoulder clears the flat top
boss_shoulder = (head_y + head_r) - boss_at[1] - sock_od/2;   // 1.50
assert(boss_shoulder >= 0.9,
       "the socket boss's shoulder runs off the top of the head");

// ----------------------------------------------------------------- the face
pupil_d     = 2.6;         // engraved inside the eye bulge
nostril_d   = 1.2;         // a narrow cut needs a narrow flat, or 45 degrees
nostril_tip = 0.4;         //   leaves it 0.1 mm deep and invisible
nostril_at  = [1.3, -1.8];

// The mouth is the widest cut here and the whole expression, so it is worth
// more than three points. Drawn as a chevron — one groove down to a point and
// one back up — it rendered as an arrowhead, not a smile; swept along an ARC
// it reads the way a frog's mouth should. The arc's centre is ABOVE the face,
// so it curves downward in the middle, and the radius is much larger than the
// head, which is what keeps it a lazy smile rather than a semicircle.
mouth_w     = 1.8;
mouth_r     = 7.0;
mouth_c     = [0, 2.0];
mouth_arc   = [228, 312];   // degrees, measured from `mouth_c`
mouth_n     = 9;            // points on the arc — enough that the hulled
                            //   segments do not read as a polygon
mouth_pts   = [for (i = [0 : mouth_n - 1])
                   let (a = mouth_arc[0] + i*(mouth_arc[1] - mouth_arc[0])/(mouth_n - 1))
                   [mouth_c[0] + mouth_r*cos(a), mouth_c[1] + mouth_r*sin(a)]];
mouth_low   = mouth_c[1] - mouth_r;                      // -5.00 — its deepest
assert(mouth_low - mouth_w/2 - (head_y - head_r) >= 1.2,
       "the mouth runs too close to the chin — raise it or drop the head");

cut_max     = charm_cut_max(plate);                      //  1.00
assert(charm_cut_depth(pupil_d) <= cut_max, "the pupils cut deeper than the plate can spare");
assert(charm_cut_depth(nostril_d, nostril_tip) <= cut_max,
       "the nostrils cut deeper than the plate can spare");
assert(charm_cut_depth(mouth_w) <= cut_max,
       "the mouth cuts deeper than the plate can spare");

echo(str("frog ", charm_w, " x ", charm_h, " mm, ", plate, " mm plate, ",
         sock_h, " mm tall printed"));
echo(str("cuts: pupil ", charm_cut_depth(pupil_d), " nostril ",
         charm_cut_depth(nostril_d, nostril_tip), " mouth ",
         charm_cut_depth(mouth_w), " mm deep, ", cut_max, " mm allowed"));
echo(str("socket: cavity d", cav_d, " mouth d", mouth_d, " over a d", charm_ball,
         " ball — ", charm_grip, " mm of grip per side, ", sock_slits, " slits"));
echo(str("swivel ", charm_tilt, " deg off axis, free spin"));

// ----------------------------------------------------------------- geometry

module frog_2d() {
    union() {
        hull() {
            translate([-head_x, head_y]) circle(r = head_r);
            translate([ head_x, head_y]) circle(r = head_r);
        }
        for (s = [-1, 1]) translate([s*eye_at[0], eye_at[1]]) circle(r = eye_r);
    }
}

module frog_face() {
    for (s = [-1, 1]) {
        translate([s*eye_at[0],     eye_at[1]])     charm_dimple(pupil_d);
        translate([s*nostril_at[0], nostril_at[1]]) charm_dimple(nostril_d, nostril_tip);
    }
    charm_grooves(mouth_pts, mouth_w);
}

module frog_charm() {
    difference() {
        union() {
            linear_extrude(plate) frog_2d();
            translate(boss_at) charm_socket(plate);   // boss: z = 0 .. sock_h
        }
        frog_face();
    }
}

frog_charm();
