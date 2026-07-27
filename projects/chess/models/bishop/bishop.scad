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
// The mitre carries the bishop's mark: a diagonal SLIT high on the mitre, offset
// toward one side and leaning along the flank, cut clear through as an open
// window with a rounded lower end.
//
// Single-part model: prints upright on its base, which is cut dead flat (z = 0)
// for a full disc of bed contact.
//
// Printability: like the pawn, the flaring skirt and shared base tiers descend
// outward and bridge without support. The downward-facing overhangs are the
// classic turned ones — under the ball, under the mitre as it necks in, under
// the belly's tuck, and under the collar brim. Their spans are small, so they
// bridge acceptably; add light support only for the crispest finish on the mitre
// and collar. The through-slit's only downward face is its short top edge
// (slit_w ~3 mm wide), which bridges cleanly.

include <../../lib/staunton.scad>

$fn = 96;

// ---- Mitre slit ----
// A single diagonal slot cut CLEAR THROUGH the mitre (the traditional bishop's
// mark — an open window). Per the reference silhouette it is NOT centred: it sits
// high on the mitre, up near the tip, offset sideways to about 2/5 of the way
// from the centreline toward the edge, and leans to follow the mitre flank. It is
// short — kept up near the tip, not run down toward the base — with a rounded
// lower end rather than a square one.
slit_x     = 3.8;   // lateral offset from the centreline (~2/5 to the edge)
slit_cz    = 62.5;  // centre height — high on the mitre, up toward the tip
slit_len   = 9;     // (tilted) length of the slot, top end to rounded bottom
slit_w     = 2.4;   // tangential width of the slot — a narrow window
slit_tilt  = 24;    // tilt from vertical (deg) — leans to follow the mitre flank,
                    //   top toward the tip, bottom out toward the edge
slit_depth = 30;    // Y span — larger than the mitre so it cuts clear through

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

// The mitre slit: a slab offset sideways by slit_x, leaned by slit_tilt, and
// spanning the full depth of the mitre in Y so it cuts clear through — an open
// window, front to back. It is a hull of a square top end and a Y-axis cylinder
// at the bottom, so the LOWER end reads as a rounded slot rather than a square
// notch. The tilt is a rotation about Y, which leaves the Y (through) span
// untouched, so the cut stays a clean window at any lean.
module mitre_slit() {
    r   = slit_w / 2;
    eps = 0.01;
    translate([slit_x, 0, slit_cz])
        rotate([0, slit_tilt, 0])
            hull() {
                // square top end
                translate([0, 0, slit_len / 2 - eps])
                    cube([slit_w, slit_depth, 2 * eps], center = true);
                // rounded bottom end (cylinder axis along the Y through-direction)
                translate([0, 0, -slit_len / 2 + r])
                    rotate([90, 0, 0])
                        cylinder(h = slit_depth, r = r, center = true, $fn = 24);
            }
}

// Ball finial + tall MITRE [r, z], apex on the axis down to the collar's neck
// pinch. Traced from the photo; the mitre cone continues narrowing past its old
// stub so it seats on the shared collar's slim top.
//
// The mitre is SMOOTHED through the shared Catmull-Rom sampler (`_cr_curve`)
// rather than revolved from raw points. Hand-placed points left visible
// horizontal facet bands on the revolved cone (the same "wavy" surface the
// king's crown had before it went analytic); running them through the spline
// samples the profile densely so the mitre reads as one clean curve. The small
// ball finial keeps its explicit points — it is not what was faceted.
function bishop_head() = concat(
    // Ball finial: small, kept as explicit points (the mitre below was the wavy
    // part). Apex on the axis down to the thin stem where the mitre begins.
    [
        [  0.00,  72.40],  // ball finial apex
        [  1.30,  71.70],
        [  2.00,  70.70],  // ball widest
        [  2.00,  70.10],
        [  1.50,  69.30],
        [  1.30,  68.80],  // thin stem under the ball
    ],
    // Mitre: smoothed through the Catmull-Rom sampler so the revolved cone has no
    // facet bands. seg = 8 samples per segment gives a clean surface.
    _cr_curve(bishop_mitre_cps(), 8)
);

// Mitre control points [r, z], top-first: the tip (continuing from the finial
// stem) swelling to the widest shoulder, then necking back in to the collar's
// pinch. Kept deliberately SPARSE — six points on a clean convex-then-concave
// progression — so the Catmull-Rom curve draws one smooth flank instead of
// tracing the tiny wobbles a dense hand-placed list carried onto the surface.
function bishop_mitre_cps() = [
    [  2.30,  68.20],  // mitre tip begins
    [  6.50,  63.80],  // upper flank (convex)
    [ 10.20,  58.20],
    [ 12.00,  55.00],  // mitre widest
    [  8.10,  50.50],  // lower flank necks in (concave)
    [  2.84,  47.90],  // meets the collar pinch
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
