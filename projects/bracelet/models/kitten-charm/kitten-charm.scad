// kitten-charm — a kitten's face that snaps onto a bracelet charm pin.
//
// Same pattern as models/flower-charm: a flat plate printed FACE DOWN, the
// face ENGRAVED into it, the socket boss rising from the back, flipped over to
// wear. See lib/charm-pin.scad for why that orientation is forced.
//
// THE SILHOUETTE DOES THE WORK, and on an animal charm that is not a style
// choice, it is what fits. The ears are part of the outline, where they get to
// be millimetres of real material; the eyes, nose and mouth are engraved,
// where they cost nothing to print. What you cannot have at 16 mm is fine
// detail: WHISKERS WERE DRAWN AND TAKEN OUT AGAIN, twice. Any whisker that
// stays a printable wall clear of the head's rim, of the nose and of the next
// whisker comes out about 1.2 mm long, which is an invisible scratch; the ones
// that read properly on screen ended 0.2 mm from the rim. Four bold features
// beat eight faint ones, and the same goes for the inner-ear crease that also
// did not survive the arithmetic.
//
// The ears are the one thing here worth tuning by eye. The first version hulled
// a 2.7 mm base circle to a 0.9 mm tip out of a head hulled from TWO circles,
// and it rendered as a pair of elephant legs on a flat-topped head: the base
// was as wide as the gap between the ears, so there was no notch to read. What
// fixed it was a narrower base, a longer taper, and a head that is ONE circle,
// so the skull curves up between the ears instead of running flat across.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-pin.scad>

// ----------------------------------------------------------------- the head
plate       = 2.2;   // plate thickness — the same as the flower's
head_r      = 6.0;   // one circle. See the note above: hulling two of them
head_at     = [0, -1.6];   //   flattens the skull and kills the ear notch.

ear_base_r  = 2.2;   // the ear where it leaves the head ...
ear_base    = [3.0, 3.8];
ear_tip_r   = 0.8;   //   ... and its rounded point. NOT a point: an ear drawn
ear_tip     = [4.6, 7.2];  //   to a true apex ends thinner than the nozzle.

// The ear and the head must genuinely OVERLAP: union() does not merge solids
// that merely touch, and an ear perched on the rim exports as a loose crumb
// the connectivity check counts as a second piece. What measures that is the
// LENS the two circles share — `ear_lap` — and NOT whether the ear's centre
// happens to lie inside the head, which is neither necessary nor sufficient
// (the first draft asserted exactly that, and it rejected a well-welded ear).
// `ear_out` is how far the ear reaches past the head, i.e. the ear.
ear_ctr     = norm(ear_base - head_at);                  // 5.64
ear_lap     = head_r + ear_base_r - ear_ctr;             // 2.56
ear_out     = ear_ctr + ear_base_r - head_r;             // 1.84
assert(ear_lap >= 1.0,
       "the ear barely touches the head — it would export as a separate piece");
assert(ear_out >= 1.0,
       "the ear does not reach out past the head — there would be no ear");

// How deep the valley between the ears reads. The ears must sit CLOSE IN, or
// the head's own arc runs across between them and there is nothing to see: the
// first version put the bases out at x = 3.3 and rendered a flat-topped head
// with two legs on it. The valley is the head's arc at x = 0, so this is the
// number that says "cat" rather than "bear".
ear_notch   = (ear_tip[1] + ear_tip_r)
            - (head_at[1] + sqrt(pow(head_r, 2) - pow(max(0, ear_base[0] - ear_base_r), 2)));
assert(ear_notch >= 3.0, "the ears barely rise above the skull — bring their bases in");

charm_w     = 2*max(head_r, ear_tip[0] + ear_tip_r);     // 12.00
charm_top   = ear_tip[1] + ear_tip_r;                    //  8.00
charm_bot   = head_at[1] - head_r;                       // -7.60
charm_h     = charm_top - charm_bot;                     // 15.60
assert(charm_w <= 16 && charm_h <= 16,
       "the kitten outgrew `charm_reach` in bracelet.scad — respace the stations");

// The boss sits at the HEAD's centre, not the charm's bounding-box centre, and
// that is the only placement that works: what the boss needs from the plate is
// a shoulder — solid face out to `sock_od/2` plus a printable wall, all round —
// and on the head's centre that shoulder is the whole head radius. Slide it up
// towards the middle of the outline and the ears' valley eats into it from
// above. It costs nothing in balance either: the ears are small, so the
// charm's own centre of area sits within a millimetre of the head's centre.
boss_at     = head_at;
boss_shoulder = head_r - sock_od/2;                      //  2.40
assert(boss_shoulder >= 0.9,
       "the socket boss's shoulder runs off the edge of the head");

// ----------------------------------------------------------------- the face
// All four features are cuts. Depths come from lib/charm-pin.scad's 45-degree
// wedges, and `charm_cut_max` is what the plate can spare above them.
eye_d       = 2.6;
eye_at      = [2.6, 0.4];
nose_d      = 2.4;
nose_at     = [0, -2.8];
// The mouth needs THREE points a side, not two. Drawn as a plain V from under
// the nose out to the cheeks it read as a frown — the arms only ever go down.
// The flick back UP at the end is what turns it into a cat's mouth, and it is
// also the only reason the shape survives being 1.4 mm wide.
mouth_w     = 1.4;
mouth_tip   = 0.5;
mouth_pts   = [[0, -3.2],    // inside the nose dimple, so the two MERGE. Two
                             //   cuts that merge are fine; two that miss by a
                             //   tenth of a millimetre leave a 0.1 mm rib.
               [1.0, -4.6],  // down ...
               [2.2, -4.0]]; //   ... and back up

cut_max     = charm_cut_max(plate);                      // 1.00
assert(charm_cut_depth(eye_d)  <= cut_max, "the eyes cut deeper than the plate can spare");
assert(charm_cut_depth(nose_d) <= cut_max, "the nose cuts deeper than the plate can spare");
assert(charm_cut_depth(mouth_w, mouth_tip) <= cut_max,
       "the mouth cuts deeper than the plate can spare");

echo(str("kitten ", charm_w, " x ", charm_h, " mm, ", plate, " mm plate, ",
         sock_h, " mm tall printed"));
echo(str("ears: ", ear_out, " mm past the head, welded on a ", ear_lap,
         " mm lens, ", ear_notch, " mm of ear above the skull"));
echo(str("cuts: eye ", charm_cut_depth(eye_d), " nose ", charm_cut_depth(nose_d),
         " mouth ", charm_cut_depth(mouth_w, mouth_tip), " mm deep, ",
         cut_max, " mm allowed"));
echo(str("socket: cavity d", cav_d, " mouth d", mouth_d, " over a d", charm_ball,
         " ball — ", charm_grip, " mm of grip per side, ", sock_slits, " slits"));
echo(str("swivel ", charm_tilt, " deg off axis, free spin"));

// ----------------------------------------------------------------- geometry

module ear_2d(s) {
    hull() {
        translate([s*ear_base[0], ear_base[1]]) circle(r = ear_base_r);
        translate([s*ear_tip[0],  ear_tip[1]])  circle(r = ear_tip_r);
    }
}

module kitten_2d() {
    union() {
        translate(head_at) circle(r = head_r);
        for (s = [-1, 1]) ear_2d(s);
    }
}

module kitten_face() {
    for (s = [-1, 1]) {
        translate([s*eye_at[0], eye_at[1]]) charm_dimple(eye_d);
        charm_grooves([for (q = mouth_pts) [s*q[0], q[1]]], mouth_w, mouth_tip);
    }
    translate(nose_at) charm_dimple(nose_d);
}

module kitten_charm() {
    difference() {
        union() {
            linear_extrude(plate) kitten_2d();
            translate(boss_at) charm_socket(plate);   // boss: z = 0 .. sock_h
        }
        kitten_face();
    }
}

kitten_charm();
