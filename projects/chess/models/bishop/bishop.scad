// bishop — the classic Staunton BISHOP, turned as a solid of revolution.
//
// Built from the SAME shared parts as the rest of the set (see
// ../../lib/staunton.scad): head (mitre + finial) + collar + body + foot. The
// collar and foot are the shared turned parts; the body is a smooth curve
// through a few control points (`body_pts`) — here a swelling belly that tapers
// up into the collar with no separate neck, and tucks back in just above the
// foot. The mitre + ball-finial head are the bishop's own.
//
// The head was traced from the reference photo; the bishop reaches ~72 mm —
// about 1.5x the pawn, faithful to their relative heights in the photo, so it
// stands taller by rank.
//
// The mitre carries the bishop's mark: the traditional diagonal SLIT, cut as a
// thin subtracted recess into the front of the mitre (a solid core is left
// behind it, so it engraves rather than pierces).
//
// Single-part model: prints upright on its base, which is cut dead flat (z = 0)
// for a full disc of bed contact.
//
// Printability: like the pawn, the flaring skirt and shared base tiers descend
// outward and bridge without support. The downward-facing overhangs are the
// classic turned ones — under the ball, under the mitre as it necks in, under
// the belly's tuck, and under the collar brim. Their spans are small, so they
// bridge acceptably; add light support only for the crispest finish on the mitre
// and collar.

include <../../lib/staunton.scad>

$fn = 96;

// ---- Mitre slit ----
slit_z     = 55;    // centre height of the diagonal mitre slit — kept in the
                    //   fatter mid-mitre so its ends don't feather to a razor
slit_tilt  = 30;    // tilt of the slit from horizontal (deg)
slit_w     = 9;     // slit width across the mitre (X), kept inside the mitre's
                    //   curve so its ends don't feather to a razor edge
slit_h     = 2.4;   // slit thickness
slit_floor = 3.0;   // inner reach of the slit (leaves a solid core behind it)

// Where the shared parts sit on the axis (bottom-up).
foot_zs    = 1.0;               // foot at canonical height
collar_rs  = 1.0;              // collar at canonical width
collar_zs  = 1.06;             // collar stretched slightly taller
body_z0    = 14.80;           // body's bottom, where it meets the foot
body_h     = 21.79;          // body height (collar bottom - body bottom)
collar_z0  = body_z0 + body_h;  // 36.59 — collar seats on the body top

bishop();

module bishop() {
    difference() {
        // Revolve the assembled half-section. The profile is closed back to the
        // axis along the flat base (append [0, 0]); the ball apex sits on the axis.
        rotate_extrude()
            polygon(concat(
                bishop_head(),                             // mitre + finial
                collar_pts(collar_rs, collar_zs, collar_z0),
                body_pts(bishop_body(), body_h, body_z0),  // swelling belly
                foot_pts(foot_zs, 0),
                [[0, 0]]                                    // close along the axis
            ));
        mitre_slit();
    }
}

// The diagonal mitre slit: a thin slab tilted about X and pushed into the front
// (+Y) of the mitre. It floors at slit_floor (well inside the mitre) so it
// engraves the front without cutting through to the back.
module mitre_slit() {
    depth = 14;  // slab reach — from the inner core out past the front surface
    translate([0, 0, slit_z])              // pivot at the slit's inner root
        rotate([slit_tilt, 0, 0])          // tilt the slot diagonally
            translate([0, slit_floor + depth / 2 - 1, 0])  // reach out the front
                cube([slit_w, depth, slit_h], center = true);
}

// Ball finial + tall MITRE [r, z], apex on the axis down to the collar's neck
// pinch. Traced from the photo; the mitre cone continues narrowing past its old
// stub so it seats on the shared collar's slim top.
function bishop_head() = [
    [  0.00,  72.40],  // ball finial apex
    [  1.30,  71.70],
    [  2.00,  70.70],  // ball widest
    [  2.00,  70.10],
    [  1.50,  69.30],
    [  1.30,  68.80],  // thin stem under the ball
    [  2.30,  68.20],  // mitre tip begins
    [  3.60,  67.10],
    [  4.90,  65.80],
    [  6.10,  64.40],
    [  7.20,  62.80],
    [  8.30,  61.10],
    [  9.40,  59.30],
    [ 10.60,  57.60],
    [ 11.70,  56.20],  // mitre widest
    [ 12.00,  55.00],
    [ 11.40,  53.80],  // mitre underside carried down as a cone (within ~50 deg
    [ 10.30,  52.50],  //   of vertical so it bridges without support)
    [  9.10,  51.30],
    [  7.90,  50.30],
    [  6.60,  49.50],
    [  5.30,  48.90],
    [  3.90,  48.30],  // necks in toward the collar pinch
    [  2.84,  47.90],
];

// Body control points [t, r]: t = 1 at the collar (top), t = 0 at the foot.
// A swelling belly — slim near the collar, ballooning to its widest a little
// above the foot, then tucking back in to meet the foot. The points are spaced
// so the radius widens gently from the very top and accelerates smoothly into
// the belly (no near-flat top segment, which would kink the profile into a ring).
function bishop_body() = [
    [ 1.00,  4.27 ],  // top, meets the collar
    [ 0.80,  4.45 ],  // slim upper body, already easing outward
    [ 0.60,  5.05 ],
    [ 0.44,  6.20 ],
    [ 0.30,  8.00 ],
    [ 0.20,  9.70 ],
    [ 0.12, 11.05 ],
    [ 0.06, 11.88 ],  // belly widest
    [ 0.00, 11.25 ],  // tucks in to meet the foot
];
