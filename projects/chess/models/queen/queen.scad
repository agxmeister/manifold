// queen — the classic Staunton QUEEN, turned as a solid of revolution.
//
// The pawn's big sister, built from the SAME shared parts as the rest of the set
// (see ../../lib/staunton.scad): head (finial + coronet) + collar + body + foot.
// Her collar is the shared collar widened and stretched (rs 1.19, zs 1.27) and
// her foot is the shared foot stretched taller (zs 1.35) — landing, like every
// piece, on the shared 16 mm footprint. The body is a smooth curve through a few
// control points (`body_pts`): a slim WAIST just under the collar (no separate
// neck — the curve tapers into the collar) swelling to a tall bell at the foot.
// The stacked ball FINIAL + flaring CORONET head is her own.
//
// The head was traced from the reference photo; the set is scaled at a single
// ~0.351 mm/px vertical rate (the pawn's rate), which places the queen at ~86 mm
// — taller than the bishop (~72 mm), shorter than the king, faithful to their
// relative heights in the photo.
//
// Single-part model: prints upright on its base, which is cut dead flat (z = 0)
// for a full disc of bed contact.
//
// Printability: like the pawn, the swelling body and flaring base tiers descend
// outward and bridge without support. The downward-facing overhangs are the
// classic turned ones — under the coronet rim and under the collar brim (the
// same short overhang the pawn's collar has). Their spans are small, so they
// bridge acceptably; add light support only for the crispest finish on the
// coronet and collar.

include <../../lib/staunton.scad>

$fn = 96;

// Shared-part scales + where they sit on the axis (bottom-up).
foot_zs    = 1.35;              // foot stretched taller
collar_rs  = 1.19;            // collar brim widened
collar_zs  = 1.27;           // collar stretched taller
body_z0    = 20.40;         // body's bottom, where it meets the foot
body_h     = 24.85;        // body height (collar bottom - body bottom)
collar_z0  = body_z0 + body_h;  // 45.25 — collar seats on the body top

queen();

module queen() {
    // Revolve the assembled half-section. The profile is closed back to the axis
    // along the flat base (append [0, 0]); the finial apex sits on the axis.
    rotate_extrude()
        polygon(concat(
            queen_head(),                              // finial + coronet
            collar_pts(collar_rs, collar_zs, collar_z0),
            body_pts(queen_body(), body_h, body_z0),   // waisted tall bell
            foot_pts(foot_zs, 0),
            [[0, 0]]                                    // close along the axis
        ));
}

// Stacked ball FINIAL + flaring CORONET [r, z], apex on the axis down to the
// coronet base (just above the collar's neck pinch). Traced from the photo; the
// scalloped crown points read as a continuous turned rim.
function queen_head() = [
    [  0.00,  85.94],  // finial apex (on the axis)
    [  1.40,  85.10],
    [  1.65,  84.00],
    [  1.45,  82.90],  // pinch above the finial ball
    [  2.10,  81.60],
    [  2.50,  80.20],  // finial ball widest
    [  2.30,  79.00],
    [  2.20,  77.80],  // pinch under the finial ball
    [  2.90,  76.50],
    [  4.30,  75.10],  // ramp flares out to the coronet
    [  6.10,  73.90],
    [  8.40,  73.10],
    [ 12.10,  72.70],  // coronet rim widest (crown points, top lip)
    [ 12.10,  71.30],
    [ 11.00,  70.00],  // coronet underside cones in (~40 deg from vertical)
    [  9.60,  68.40],
    [  8.30,  66.60],
    [  7.30,  64.60],
    [  6.50,  62.40],
    [  5.90,  60.40],
    [  5.40,  59.00],  // coronet base
];

// Body control points [t, r]: t = 1 at the collar (top), t = 0 at the foot.
// A slim WAIST just under the collar (the curve eases in from the collar's
// bottom radius, no cylinder neck) that swells smoothly into a tall bell and
// widens to meet the foot.
function queen_body() = [
    [ 1.00,  5.08 ],  // top, meets the collar
    [ 0.92,  4.80 ],  // eases in toward the waist
    [ 0.83,  4.62 ],  // waist narrowest
    [ 0.70,  4.74 ],
    [ 0.56,  5.15 ],
    [ 0.44,  5.75 ],
    [ 0.33,  6.45 ],
    [ 0.23,  7.30 ],
    [ 0.13,  8.25 ],
    [ 0.05,  9.20 ],
    [ 0.00, 10.00 ],  // bottom, meets the foot
];
