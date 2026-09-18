// puppy-charm — a puppy's face that snaps onto a bracelet charm pin.
//
// Same pattern as models/flower-charm: flat plate printed FACE DOWN, face
// ENGRAVED, socket boss on the back, flipped over to wear. See
// lib/charm-pin.scad for why that orientation is forced, and
// models/kitten-charm for why the silhouette carries the shape and the cuts
// only carry the detail.
//
// THREE THINGS MAKE THIS A DOG rather than the kitten with different ears, and
// all three are in the outline, because that is where a 16 mm charm has room:
//
//   * the ears HANG. Long lobes down the sides, reaching further out than the
//     skull and as far down as the chin. The first version had them as gentle
//     bulges on a big round head and the whole silhouette rendered as a cloud
//     — an ear you can see is an ear that clears the head by millimetres, so
//     the head shrank and the ears grew.
//   * a MUZZLE pokes out below the skull, a third circle. It is also what buys
//     room for the mouth: on a plain round head the rim curved up under the
//     mouth and left 0.9 mm of wall beside it.
//   * the NOSE is much bigger than a cat's, and the mouth runs DOWN out of it
//     and splits, instead of sitting under it.
//
// The big nose is the one cut here that needs thought. A 45-degree dimple 3 mm
// across would be 1.5 mm deep, well past what a 2.2 mm plate can spare, so it
// is truncated on a wide flat — `nose_tip` — which is what keeps it to 0.9 mm.
// That flat is a 1.2 mm horizontal ceiling and the overhang check reports it;
// it is a 1.2 mm bridge at the top of a self-supporting cone, which the slicer
// spans without noticing. Running the cone to a true apex instead would both
// cut through the plate and mesh into slivers.

$fa = 2;
$fs = 0.3;

include <../../lib/charm-pin.scad>

// ----------------------------------------------------------------- the head
plate       = 2.2;   // plate thickness — the same as the flower's
head_r      = 5.4;   // the skull ...
head_at     = [0, 0.6];
muzzle_r    = 4.7;   //   ... and the muzzle under it
muzzle_at   = [0, -3.2];

ear_top_r   = 2.3;   // a floppy ear: a lobe at the top of the head ...
ear_top     = [4.0, 2.6];
ear_bot_r   = 1.9;   //   ... hulled down to a narrower one beside the muzzle
ear_bot     = [5.6, -2.8];

// The ear's lower lobe and the muzzle sit side by side low on the face, and
// they must either OVERLAP properly or stand a printable wall apart. The band
// between is what to avoid: two outline lumps that miss each other by 0.1 mm
// leave a notch no nozzle fits into, and the silhouette reads as one blob
// either way. Overlapping is the better-looking of the two — a floppy ear
// frames the cheek — so that is what this asserts.
ear_cheek   = ear_bot_r + muzzle_r - norm(ear_bot - muzzle_at);    // 1.00
assert(ear_cheek >= 0.8,
       "the ear's lower lobe nearly misses the muzzle — overlap it or move it clear");

// Every lump has to genuinely OVERLAP the skull: union() does not merge solids
// that merely touch, and a detached ear or muzzle is a second piece in the
// export, which the connectivity check is there to catch. What measures that
// is the LENS the two circles share, NOT whether one centre lies inside the
// other — that test is neither necessary nor sufficient, and the first draft
// of this file asserted it and rejected a perfectly welded ear.
ear_lap     = head_r + ear_top_r - norm(ear_top - head_at);        // 3.23
muzzle_lap  = head_r + muzzle_r - norm(muzzle_at - head_at);       // 6.30
assert(ear_lap    >= 1.0, "the ear barely touches the head — it would export loose");
assert(muzzle_lap >= 1.0, "the muzzle barely touches the head — it would export loose");

// And every lump has to be VISIBLE, or it is filament spent on nothing. These
// two are the numbers the silhouette lives on.
ear_out     = (ear_bot[0] + ear_bot_r) - head_r;                   // 2.10
muzzle_out  = (muzzle_at[1] - muzzle_r) - (head_at[1] - head_r);   // -3.10
assert(ear_out >= 1.5, "the ears do not hang clear of the skull — no ears");
assert(-muzzle_out >= 1.5, "the muzzle does not poke below the skull — no muzzle");

charm_w     = 2*max(head_r, ear_top[0] + ear_top_r, ear_bot[0] + ear_bot_r);  // 15.00
charm_top   = head_at[1] + head_r;                                 //  6.00
charm_bot   = min(head_at[1] - head_r, muzzle_at[1] - muzzle_r,
                  ear_bot[1] - ear_bot_r);                         // -7.90
charm_h     = charm_top - charm_bot;                               // 13.90
assert(charm_w <= 16 && charm_h <= 16,
       "the puppy outgrew `charm_reach` in bracelet.scad — respace the stations");

// The boss needs a shoulder — solid face out to `sock_od/2` plus a printable
// wall, all round — and on this outline the skull is the only circle wide
// enough to give it one, so the boss sits inside the skull. Slightly high of
// its centre, because the muzzle below adds area the ears above do not.
boss_at     = [0, 0.4];
boss_shoulder = head_r - norm(boss_at - head_at) - sock_od/2;      //  1.60
assert(boss_shoulder >= 0.9,
       "the socket boss's shoulder runs off the edge of the skull");

// ----------------------------------------------------------------- the face
eye_d       = 2.4;
eye_at      = [2.3, 2.2];
nose_d      = 3.0;   // the dog's one big feature — see the note at the top
nose_tip    = 1.2;
nose_at     = [0, -2.6];
mouth_w     = 1.4;
mouth_tip   = 0.6;
mouth_top   = [0, -3.7];   // inside the nose dimple, so the two MERGE. Two
                           //   cuts that merge are fine; two that miss by a
                           //   tenth of a millimetre leave a 0.1 mm rib.
mouth_split = [0, -4.8];
mouth_end   = [2.0, -4.4];

cut_max     = charm_cut_max(plate);                                //  1.00
assert(charm_cut_depth(eye_d) <= cut_max, "the eyes cut deeper than the plate can spare");
assert(charm_cut_depth(nose_d, nose_tip) <= cut_max,
       "the nose cuts deeper than the plate can spare — widen `nose_tip`");
assert(charm_cut_depth(mouth_w, mouth_tip) <= cut_max,
       "the mouth cuts deeper than the plate can spare");

echo(str("puppy ", charm_w, " x ", charm_h, " mm, ", plate, " mm plate, ",
         sock_h, " mm tall printed"));
echo(str("outline: ", ear_out, " mm of ear past the skull, ", -muzzle_out,
         " mm of muzzle below it, ear over muzzle by ", ear_cheek, " mm"));
echo(str("cuts: eye ", charm_cut_depth(eye_d), " nose ",
         charm_cut_depth(nose_d, nose_tip), " mouth ",
         charm_cut_depth(mouth_w, mouth_tip), " mm deep, ", cut_max, " mm allowed"));
echo(str("socket: cavity d", cav_d, " mouth d", mouth_d, " over a d", charm_ball,
         " ball — ", charm_grip, " mm of grip per side, ", sock_slits, " slits"));
echo(str("swivel ", charm_tilt, " deg off axis, free spin"));

// ----------------------------------------------------------------- geometry

module ear_2d(s) {
    hull() {
        translate([s*ear_top[0], ear_top[1]]) circle(r = ear_top_r);
        translate([s*ear_bot[0], ear_bot[1]]) circle(r = ear_bot_r);
    }
}

module puppy_2d() {
    union() {
        translate(head_at)   circle(r = head_r);
        translate(muzzle_at) circle(r = muzzle_r);
        for (s = [-1, 1]) ear_2d(s);
    }
}

module puppy_face() {
    for (s = [-1, 1]) {
        translate([s*eye_at[0], eye_at[1]]) charm_dimple(eye_d);
        charm_groove(mouth_split, [s*mouth_end[0], mouth_end[1]], mouth_w, mouth_tip);
    }
    translate(nose_at) charm_dimple(nose_d, nose_tip);
    charm_groove(mouth_top, mouth_split, mouth_w, mouth_tip);
}

module puppy_charm() {
    difference() {
        union() {
            linear_extrude(plate) puppy_2d();
            translate(boss_at) charm_socket(plate);   // boss: z = 0 .. sock_h
        }
        puppy_face();
    }
}

puppy_charm();
