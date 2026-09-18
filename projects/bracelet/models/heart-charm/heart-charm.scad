// heart-charm — a heart that snaps onto a bracelet charm pin.
//
// Built to the pattern models/flower-charm set and lib/charm-pin.scad
// documents: a flat plate printed FACE DOWN on the bed, decoration ENGRAVED
// into that face, and the socket boss rising from the back. Flip it over to
// wear it. Nothing needs support and nothing bridges.
//
// The silhouette does the work here. A heart is two overlapping lobes hulled
// down to a rounded tip, and the only two numbers worth arguing about are:
//
//   * the lobes must genuinely OVERLAP, not meet. Tangent circles union into
//     one piece only in exact arithmetic; on a mesh they leave a knife edge at
//     the notch, and the notch is the one place the two halves have to be
//     welded. `notch_lap` is asserted.
//   * the tip is a small CIRCLE, not a point. A heart drawn to a true apex
//     ends in a wall thinner than the nozzle, which the slicer drops.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-pin.scad>

// ---------------------------------------------------------------- the heart
plate       = 2.2;   // plate thickness — the same as the flower's
lobe_r      = 4.05;  // one lobe
lobe_x      = 3.8;   // and how far off centre it sits ...
lobe_y      = 3.2;   //   ... and how high
tip_r       = 1.1;   // the rounded point at the bottom. How FAR DOWN it sits
tip_y       = -5.6;  //   is what decides whether this reads as a heart or as a
                     //   spade: the lobes' sides run straight to the tip, so a
                     //   tip drawn far down makes two long flanks and a point.
                     //   Pulled up to where the lobes still dominate, the
                     //   flanks shorten and the outline goes round again.

heart_w     = 2*(lobe_x + lobe_r);                  // 15.70 — tip to tip
heart_top   = lobe_y + lobe_r;                      //  7.25
heart_bot   = tip_y - tip_r;                        // -6.70
heart_h     = heart_top - heart_bot;                // 13.95

notch_lap   = 2*lobe_r - 2*lobe_x;                  //  0.50 — how far the two
                                                    //   lobes reach past each
                                                    //   other at x = 0
assert(notch_lap >= 0.4,
       "the heart's lobes barely touch — the notch would export as a knife edge");
notch_y     = lobe_y + sqrt(pow(lobe_r, 2) - pow(lobe_x, 2));   // 4.60 — the
                                                    //   bottom of the cleft
assert(heart_w <= 16 && heart_h <= 16,
       "the heart outgrew `charm_reach` in bracelet.scad — respace the stations");

// The flank is the straight run of the hull from a lobe to the tip, and it is
// what the eye reads. Long flanks and a small lobe make a spade; keep the
// flank comparable to the lobe and it stays a heart.
flank       = norm([lobe_x, lobe_y - tip_y]) - lobe_r - tip_r;   // 4.44
assert(flank <= 2.0 * lobe_r,
       "the tip is drawn too far down — this is a spade, not a heart");

// The boss sits at the origin. What it needs from the plate is a shoulder: the
// face has to be solid out to `sock_od/2` plus a printable wall, all the way
// round. On a heart the tight direction is UP, into the cleft.
boss_shoulder = notch_y - sock_od/2;                // 1.00
assert(boss_shoulder >= 0.9,
       "the cleft cuts into the socket boss's shoulder — lower the boss or deepen the lobes");

// ------------------------------------------------------------------ the gloss
// Two engraved highlight streaks on the upper-left lobe — the only decoration.
// Cut, not raised, and kept a printable wall clear of the lobe's rim and of
// each other: two grooves that MERGE are harmless, two that miss by 0.1 mm
// leave a 0.1 mm rib.
gloss_w     = 1.8;
gloss_a     = [[-5.6, 3.0], [-4.6, 4.7]];
gloss_b     = [[-3.1, 1.2], [-2.3, 2.6]];
assert(charm_cut_depth(gloss_w) <= charm_cut_max(plate),
       "the gloss streaks cut deeper than the plate can spare");

echo(str("heart ", heart_w, " x ", heart_h, " mm, ", plate, " mm plate, ",
         sock_h, " mm tall printed"));
echo(str("gloss streaks ", charm_cut_depth(gloss_w), " mm deep, ",
         charm_cut_max(plate), " mm allowed"));
echo(str("socket: cavity d", cav_d, " mouth d", mouth_d, " over a d", charm_ball,
         " ball — ", charm_grip, " mm of grip per side, ", sock_slits, " slits"));
echo(str("swivel ", charm_tilt, " deg off axis, free spin"));

// ----------------------------------------------------------------- geometry

module heart_2d() {
    for (s = [-1, 1])
        hull() {
            translate([s*lobe_x, lobe_y]) circle(r = lobe_r);
            translate([0, tip_y]) circle(r = tip_r);
        }
}

module heart_charm() {
    difference() {
        union() {
            linear_extrude(plate) heart_2d();
            charm_socket(plate);               // boss: z = 0 .. sock_h
        }
        charm_groove(gloss_a[0], gloss_a[1], gloss_w);
        charm_groove(gloss_b[0], gloss_b[1], gloss_w - 0.4);
    }
}

heart_charm();
